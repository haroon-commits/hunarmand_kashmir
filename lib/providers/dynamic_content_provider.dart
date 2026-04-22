/// ═══════════════════════════════════════════════════════════════════════
/// FILE: dynamic_content_provider.dart
/// PURPOSE: The heart of the Headless CMS architecture. This provider
///          maintains a persistent real-time stream with Firebase Firestore,
///          serving as the single source of truth for ALL dynamic website
///          content (text, images, navigation, and configuration).
/// CONNECTIONS:
///   - REGISTERED IN: main.dart (via ChangeNotifierProvider in MultiProvider)
///   - DEPENDS ON: models/content_model.dart (AppContent + all sub-models)
///   - DEPENDS ON: cloud_firestore package (Firebase Firestore SDK)
///   - USED BY: Every public screen (home, about, courses, gallery, contact, donate)
///              via Consumer<DynamicContentProvider> or context.read/watch
///   - USED BY: widgets/nav/hunarmand_app_bar.dart → reads logoPath, logoText
///   - USED BY: widgets/nav/hunarmand_drawer.dart → reads logoPath, logoText, appTitle
///   - USED BY: widgets/layout/app_footer.dart → reads logoText, footerDescription, contact*
///   - USED BY: widgets/feedback/splash_screen.dart → checks isLoading status
///   - MODIFIED BY: All 7 admin editor files call update*() methods
///   - FIRESTORE PATH: 'content/website' (single document stores entire state)
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart'; // Flutter core for ChangeNotifier, debugPrint
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore SDK for real-time database operations
import '../models/content_model.dart'; // AppContent + Course, Feature, DonationTier, TeamMember, GalleryImage models

/// DynamicContentProvider - The heart of the platform's Headless CMS architecture.
/// This provider maintains a real-time connection with Firebase Firestore,
/// serving as the single source of truth for all website text, images, and configuration.
///
/// DATA FLOW ARCHITECTURE:
///   ┌─────────────────────────────────────────────────────────────┐
///   │  Firestore ('content/website')                               │
///   │       ↓ (real-time stream via snapshots().listen())          │
///   │  DynamicContentProvider._content (AppContent instance)       │
///   │       ↓ (notifyListeners() triggers rebuild)                 │
///   │  Consumer<DynamicContentProvider> widgets in all screens     │
///   └─────────────────────────────────────────────────────────────┘
///
///   Admin update flow:
///   ┌─────────────────────────────────────────────────────────────┐
///   │  Admin Editor → provider.updateXxx(newValue)                 │
///   │       ↓ (copyWith creates new AppContent)                    │
///   │  saveContent() → Firestore.set(content.toJson())             │
///   │       ↓ (Firestore emits new snapshot)                       │
///   │  _loadFromFirestore listener → _content updated              │
///   │       ↓ (notifyListeners())                                  │
///   │  All Consumer widgets rebuild with new data                  │
///   └─────────────────────────────────────────────────────────────┘
class DynamicContentProvider extends ChangeNotifier {
  /// The current state of all website content.
  /// This is the single AppContent instance that ALL screens read from.
  /// Initialized by _loadFromFirestore() on app startup.
  /// Updated by update*() methods from admin editors.
  late AppContent _content;

  /// Flag representing whether the initial data fetch is still in progress.
  /// While true, main.dart shows the SplashScreen widget.
  /// Set to false once _loadFromFirestore() receives its first Firestore snapshot.
  bool _isLoading = true;

  /// Instance of Firestore for database operations.
  /// Created once and reused for all read/write operations throughout the provider's lifetime.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fixed path to the primary content document in Firestore.
  /// The entire website state is stored in a single document at 'content/website'.
  /// This simplifies real-time sync: one listener covers all content updates.
  final String _documentPath = 'content/website';

  /// Active Firestore snapshot listener subscription.
  /// Stored so it can be cancelled in dispose() to prevent memory leaks.
  /// The listener fires every time the Firestore document changes (locally or remotely).
  var _subscription;

  /// Public getter for accessing the current website content from screens/widgets.
  /// CALLED BY: Every screen via Consumer<DynamicContentProvider> → provider.content
  /// RETURNS: The latest AppContent instance synchronized with Firestore.
  AppContent get content => _content;

  /// Public getter for checking the loading status.
  /// CALLED BY: main.dart → Consumer3 conditional → shows SplashScreen if true
  /// RETURNS: true while awaiting the first Firestore snapshot, false after data arrives.
  bool get isLoading => _isLoading;

  /// Constructor: Automatically triggers the Firestore sync on creation.
  /// Called when ChangeNotifierProvider creates this instance in main.dart's MultiProvider.
  /// The _init() call starts the real-time stream immediately.
  DynamicContentProvider() {
    _init(); // Begin Firestore synchronization as soon as the provider is created
  }

  /// Lifecycle cleanup: Cancels the Firestore subscription when the provider is disposed.
  /// This prevents memory leaks and orphaned database listeners.
  /// Called automatically by Flutter when the ChangeNotifierProvider is removed from the tree.
  @override
  void dispose() {
    _subscription?.cancel(); // Cancel the Firestore stream listener if active
    super.dispose(); // Call parent dispose to clean up ChangeNotifier resources
  }

  /// Internal initializer that kicks off the Firestore synchronization.
  /// Added a 5-second safety timeout to ensure the UI proceeds regardless of network.
  Future<void> _init() async {
    debugPrint('[INITIALIZATION] Starting DynamicContentProvider sync...');
    
    // Start the Firestore listener
    _loadFromFirestore();

    // Safety timeout: If loading is still true after 5 seconds, force it to false.
    // This prevents the user from being stuck on the splash screen indefinitely.
    Future.delayed(const Duration(seconds: 5), () {
      if (_isLoading) {
        debugPrint('[INITIALIZATION] Timeout reached. Forcing splash screen removal.');
        _isLoading = false;
        // If content wasn't loaded yet, ensure we have defaults to render
        try {
          _content; 
        } catch (_) {
          _content = _getDefaults();
        }
        notifyListeners();
      }
    });
  }

  /// Establishes a permanent real-time stream with the Firestore document.
  /// This is the CORE synchronization mechanism of the entire application.
  ///
  /// HOW IT WORKS:
  ///   1. _firestore.doc(_documentPath).snapshots() creates a Stream of document snapshots
  ///   2. .listen() subscribes to that stream, firing the callback on every change
  ///   3. If the document exists → deserialize JSON into AppContent via fromJson()
  ///   4. If the document doesn't exist (first-ever run) → seed with defaults and save
  ///   5. On any data update → set _isLoading = false and call notifyListeners()
  ///   6. notifyListeners() causes ALL Consumer<DynamicContentProvider> widgets to rebuild
  ///
  /// ERROR HANDLING:
  ///   If Firestore is unreachable (no internet, Firebase misconfigured), the onError
  ///   callback applies local defaults so the app still renders meaningful content.
  void _loadFromFirestore() {
    // Creating a persistent listener on the Firestore document.
    // _subscription stores the reference so we can cancel it in dispose().
    _subscription = _firestore.doc(_documentPath).snapshots().listen(
      (doc) {
        // Check if the Firestore document exists and contains data
        if (doc.exists && doc.data() != null) {
          // SUCCESS PATH: Document exists in Firestore
          // Deserialize the Firestore JSON map into a strongly-typed AppContent object.
          // doc.data()! is the Map<String, dynamic> representing the entire document.
          // AppContent.fromJson() is defined in models/content_model.dart.
          _content = AppContent.fromJson(doc.data()!);
        } else {
          // FIRST-RUN PATH: Document doesn't exist yet (fresh Firebase project)
          // Populate _content with production-ready default data
          _content = _getDefaults();
          // Write the defaults to Firestore so the document exists for future loads
          saveContent();
        }
        // Mark loading as complete so main.dart can hide the SplashScreen
        if (_isLoading) {
          debugPrint('[INITIALIZATION] First Firestore snapshot received successfully.');
          _isLoading = false;
        }
        // Notify ALL listening widgets to rebuild with the new/updated content
        // This triggers rebuilds in every Consumer<DynamicContentProvider> across the app
        notifyListeners();
      },
      onError: (e) {
        // ERROR PATH: Firestore connection failed (network error, permission denied, etc.)
        debugPrint('Error in Firestore stream: $e');
        // Fail-safe: use hardcoded defaults so the app still renders UI
        _content = _getDefaults();
        // Mark loading as complete even on error (don't leave user on splash forever)
        _isLoading = false;
        // Notify widgets to render with default content
        notifyListeners();
      },
    );
  }

  /// Defines the production-ready default content for every section of the platform.
  /// This serves as the 'Out of Box' experience for a new deployment.
  ///
  /// CALLED BY: _loadFromFirestore() → when Firestore doc doesn't exist (first run)
  /// CALLED BY: _loadFromFirestore() → onError callback (network failure fallback)
  ///
  /// STRUCTURE: Creates a complete AppContent with:
  ///   - 5 courses (AI, Design, E-Commerce, Freelancing, Social Media)
  ///   - 3 features (Mentorship, Practical Learning, Career Support)
  ///   - 3 donation tiers (Small, Growth, Future Builder)
  ///   - 3 team members with Unsplash placeholder images
  ///   - 8 gallery images from Unsplash
  ///   - All text content for every page (home, about, courses, gallery, contact, donate)
  AppContent _getDefaults() {
    return AppContent(
      // ── Global Branding ──
      appTitle: 'Hunarmand Kashmir', // Browser tab title and app header
      logoText: 'ہنرمند', // Urdu branding text (rendered with AmiriQuran font)

      // ── Home Screen: Hero Section ──
      heroHeadline: 'Empowering Kashmir through Digital Excellence', // Main landing headline
      heroSubheadline: 'Join the valley\'s premier skill-building initiative. Master modern technologies, build a global career, and transform your future with expert-led mentorship.', // Supporting narrative

      // ── Courses: Master list of all offered courses ──
      // Each Course object maps to a CourseCard in home_screen.dart and courses_screen.dart
      courses: [
        Course(
          title: 'AI Mastery', // Course title displayed on card heading
          description: 'Practical AI skills for real income. Learn to use AI tools to build products and earn online.', // Card body text
          icon: '🤖', // Emoji rendered via dynamic_icon.dart
          duration: '3 Months', // Duration label
          fee: 'Rs. 8,000', // Fee label
          topics: ['ChatGPT & Prompt Engineering', 'AI Image Generation', 'AI for Business', 'Freelancing with AI'], // Curriculum checklist
        ),
        Course(
          title: 'Graphic Design',
          description: 'Professional design skills. Master the tools used by top designers worldwide.',
          icon: '🎨',
          duration: '3 Months',
          fee: 'Rs. 7,000',
          topics: ['Adobe Photoshop', 'Adobe Illustrator', 'Canva Pro', 'Brand Identity Design'],
        ),
        Course(
          title: 'E-Commerce',
          description: 'Build and scale online stores. Learn to sell products globally from Kashmir.',
          icon: '🛍️',
          duration: '3 Months',
          fee: 'Rs. 6,000',
          topics: ['Shopify Store Setup', 'Product Listing', 'Digital Marketing', 'Amazon FBA Basics'],
        ),
        Course(
          title: 'Freelancing',
          description: 'Work with global clients. Get your first international client within the first month.',
          icon: '💻',
          duration: '2 Months',
          fee: 'Rs. 5,000',
          topics: ['Fiverr & Upwork Profile', 'Proposal Writing', 'Client Communication', 'Payment Methods'],
        ),
        Course(
          title: 'Social Media Marketing',
          description: 'Digital growth strategies. Help businesses grow their online presence.',
          icon: '📢',
          duration: '3 Months',
          fee: 'Rs. 7,000',
          topics: ['Content Strategy', 'Instagram & Facebook Ads', 'TikTok Marketing', 'Analytics & Reporting'],
        ),
      ],

      // ── Features: Selling points shown on home screen 'Why Us' section ──
      features: [
        Feature(
          icon: '👨‍🏫', // Emoji for the feature card icon
          title: 'Expert Mentorship', // Card heading
          description: 'Learn from industry professionals who have worked globally.', // Card body
        ),
        Feature(
          icon: '🛠️',
          title: 'Practical Learning',
          description: 'No boring theory. Work on real projects that build your portfolio.',
        ),
        Feature(
          icon: '🚀',
          title: 'Career Support',
          description: 'From resume building to freelance gigs, we guide your career path.',
        ),
      ],

      // ── Donation Tiers: Financial support levels for public donors ──
      donationTiers: [
        DonationTier(title: 'Small Support', amount: '\$10', description: 'Helps one student with basic tools.', icon: '☕'),
        DonationTier(title: 'Growth Pack', amount: '\$50', description: 'Covers training for one month.', icon: '🌱', popular: true), // Marked as 'MOST POPULAR' in UI
        DonationTier(title: 'Future Builder', amount: '\$200', description: 'Full scholarship for one student.', icon: '🏢'),
      ],

      // ── Team Members: Leadership profiles shown on About page ──
      teamMembers: [
        TeamMember(name: 'Adnan Khan', role: 'Lead Mentor', imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80'),
        TeamMember(name: 'Sarah Malik', role: 'Design Head', imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&q=80'),
        TeamMember(name: 'Omar Farooq', role: 'Web Instructor', imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&q=80'),
      ],

      // ── Footer & Contact ──
      footerDescription: 'Empowering Youth. Empowering the youth of Kashmir through digital skills, fostering self-reliance, and building a future where talent meets opportunity.', // Footer branding narrative
      contactAddress: 'SCO Software Technology Park, Mirpur', // Physical address
      contactPhone: '0313 884 0971', // Primary phone number
      contactEmail: 'salam@hunarmandkashmir.com', // Official email

      // ── About Page Content ──
      aboutStoryHeadline: 'From Kashmir to Global Opportunities', // Story section heading
      aboutStoryText: 'Hunarmand Kashmir was born from a simple yet powerful truth: talent is everywhere, but opportunity is not. For far too long, the brilliant minds of Kashmir have faced challenges—geographical isolation, limited infrastructure, and limited exposure to global industries.\n\nWe believe digital skills are the great equalizer. With the right training, mentorship, and access, a student from even the most remote areas of Kashmir can work with companies and clients across the world.', // Full story narrative
      aboutMissionText: 'To bridge the skills gap in Kashmir by delivering world-class digital training that empowers 10,000 young people by 2030 to achieve financial independence with dignity and confidence.', // Mission statement
      aboutVisionText: 'A self-reliant Kashmir where every young person has the skills to compete globally without leaving their homeland.', // Vision statement
      aboutValuesText: 'We are more than an institute; we are a family. We support each other, share opportunities, and grow together as a skilled collective.', // Values narrative

      // ── Donate Page Hero ──
      donateHeroTitle: 'Invest in Dignity, Not Dependency.', // Donate page headline
      donateHeroDescription: 'Your contribution unlocks futures. Help empower youth in Kashmir to earn a livelihood and build self-reliant communities.', // Donate page description

      // ── Contact Page Hero ──
      contactHeroTitle: 'Get in Touch', // Contact page headline
      contactHeroDescription: 'Have questions? We are here to help you start your journey or discuss collaboration opportunities.', // Contact page description

      // ── Home Page: Why Us Section ──
      homeWhyTitle: 'Why Hunarmand Kashmir?', // Why Us section headline
      homeWhyDescription: 'We believe in "Skills over Degrees". In a rapidly changing world, we provide practical, hands-on training that the industry demands, right here in Mirpur.', // Why Us description

      // ── Home Page: Call-to-Action Section ──
      homeCtaTitle: 'Your Journey Begins Here', // CTA headline
      homeCtaDescription: "Don't let lack of opportunity hold you back. Join Hunarmand Kashmir today and unlock a future of dignity, independence, and success.", // CTA description

      // ── Gallery Page ──
      galleryHeroTitle: 'Moments of Hope', // Gallery page headline
      galleryHeroDescription: 'Witness the journey of transformation. From Mirpur to Bhimber, empowering every corner of Kashmir.', // Gallery description
      galleryImages: [
        // Each GalleryImage contains an Unsplash URL and descriptive label
        GalleryImage(imageUrl: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&q=80', label: 'Web Development Lab'),
        GalleryImage(imageUrl: 'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=800&q=80', label: 'Design Studio'),
        GalleryImage(imageUrl: 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800&q=80', label: 'Coding Workshop'),
        GalleryImage(imageUrl: 'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=800&q=80', label: 'Mentorship Session'),
        GalleryImage(imageUrl: 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=800&q=80', label: 'Team Graduation'),
        GalleryImage(imageUrl: 'https://images.unsplash.com/photo-1427504494785-3a9ca7044f45?w=800&q=80', label: 'Campus View'),
        GalleryImage(imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&q=80', label: 'Digital Skills Training'),
        GalleryImage(imageUrl: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=800&q=80', label: 'Project Collaboration'),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // CONTENT UPDATE METHODS
  // Each method follows the same pattern:
  //   1. Create a new AppContent via _content.copyWith(changedField: newValue)
  //   2. Call saveContent() to persist to Firestore
  //   3. Firestore emits a new snapshot → _loadFromFirestore listener fires
  //   4. notifyListeners() causes all Consumer widgets to rebuild
  // ═══════════════════════════════════════════════════════════════════════

  /// Commits the current local state to the permanent Firestore database.
  /// This method serializes _content to JSON and writes it to the Firestore document.
  ///
  /// CALLED BY: Every update*() method below, and _loadFromFirestore() on first run.
  /// FLOW: _content.toJson() → Firestore.doc.set() → Firestore emits snapshot → listener updates UI
  Future<void> saveContent() async {
    try {
      // Serialize the entire AppContent to a JSON map and write to Firestore.
      // .set() overwrites the entire document with the new state.
      await _firestore.doc(_documentPath).set(_content.toJson());
      // Immediately notify listeners for optimistic UI update
      // (the Firestore listener will also fire, but this ensures instant feedback)
      notifyListeners();
    } catch (e) {
      // Log the error without crashing the app; the UI stays on the last known good state
      debugPrint('Error saving content to Firestore: $e');
    }
  }

  /// Updates the main Hero section headlines on the home screen.
  /// CALLED BY: screens/admin/editors/home_editor.dart → 'Save Hero' button
  /// AFFECTS: screens/home_screen.dart → _HeroSection headline and subheadline
  void updateHero(String headline, String subheadline) {
    // Create a new AppContent with updated hero fields, preserving all other fields
    _content = _content.copyWith(
      heroHeadline: headline, // New hero headline text
      heroSubheadline: subheadline, // New hero subheadline text
    );
    saveContent(); // Persist to Firestore and notify listeners
  }

  /// Updates the primary logo image path and Urdu branding text.
  /// CALLED BY: screens/admin/editors/global_editor.dart → 'Save' button
  /// AFFECTS: hunarmand_app_bar.dart, hunarmand_drawer.dart, app_footer.dart (logo display)
  void updateLogo(String? path, String text) {
    // Create a new AppContent with updated logo fields
    _content = _content.copyWith(
      logoText: text, // New Urdu branding text
      logoPath: path, // New logo image URL (can be null for text-only branding)
    );
    saveContent(); // Persist and notify
  }

  /// Updates the global footer narrative description.
  /// CALLED BY: screens/admin/editors/global_editor.dart → 'Save' button
  /// AFFECTS: widgets/layout/app_footer.dart → _buildLogoColumn footer description text
  void updateFooter(String description) {
    _content = _content.copyWith(
      footerDescription: description, // New footer description text
    );
    saveContent(); // Persist and notify
  }

  /// Updates centralized contact information (Address, Phone, Email).
  /// CALLED BY: screens/admin/editors/contact_editor.dart → 'Save' button
  /// AFFECTS: screens/contact_screen.dart → ContactInfoTile widgets
  /// AFFECTS: widgets/layout/app_footer.dart → _buildContactColumn
  void updateContact(String address, String phone, String email) {
    _content = _content.copyWith(
      contactAddress: address, // New physical address
      contactPhone: phone, // New phone number
      contactEmail: email, // New email address
    );
    saveContent(); // Persist and notify
  }

  /// Updates the entire About Us narrative structure.
  /// CALLED BY: screens/admin/editors/about_editor.dart → 'Save' button
  /// AFFECTS: screens/about_screen.dart → story section, mission/vision cards, values card
  void updateAbout(String headline, String story, String mission, String vision, String values) {
    _content = _content.copyWith(
      aboutStoryHeadline: headline, // New story section headline
      aboutStoryText: story, // New story narrative body
      aboutMissionText: mission, // New mission statement
      aboutVisionText: vision, // New vision statement
      aboutValuesText: values, // New values narrative
    );
    saveContent(); // Persist and notify
  }

  /// Updates the Donation screen hero banners.
  /// CALLED BY: screens/admin/editors/donate_editor.dart → 'Save Hero' button
  /// AFFECTS: screens/donate_screen.dart → _buildHero section title and description
  void updateDonateHero(String title, String description) {
    _content = _content.copyWith(
      donateHeroTitle: title, // New donate page headline
      donateHeroDescription: description, // New donate page description
    );
    saveContent(); // Persist and notify
  }

  /// Updates the Contact screen hero banners.
  /// CALLED BY: screens/admin/editors/contact_editor.dart → 'Save Hero' button
  /// AFFECTS: screens/contact_screen.dart → SliverGreenPageHeader title and subtitle
  void updateContactHero(String title, String description) {
    _content = _content.copyWith(
      contactHeroTitle: title, // New contact page headline
      contactHeroDescription: description, // New contact page description
    );
    saveContent(); // Persist and notify
  }

  /// Updates the 'Why Us' sales arguments on the home screen.
  /// CALLED BY: screens/admin/editors/home_editor.dart → 'Save Why Section' button
  /// AFFECTS: screens/home_screen.dart → _WhySectionSliver headline and description
  void updateHomeWhy(String title, String description) {
    _content = _content.copyWith(
      homeWhyTitle: title, // New 'Why Us' heading
      homeWhyDescription: description, // New 'Why Us' body text
    );
    saveContent(); // Persist and notify
  }

  /// Updates the Home screen Call-To-Action section content.
  /// CALLED BY: screens/admin/editors/home_editor.dart → 'Save CTA Section' button
  /// AFFECTS: screens/home_screen.dart → _CtaSection title and description
  void updateHomeCta(String title, String description) {
    _content = _content.copyWith(
      homeCtaTitle: title, // New CTA heading
      homeCtaDescription: description, // New CTA body text
    );
    saveContent(); // Persist and notify
  }

  /// Updates the Gallery screen header text.
  /// CALLED BY: screens/admin/editors/gallery_editor.dart → 'Save Hero' button
  /// AFFECTS: screens/gallery_screen.dart → SliverGreenPageHeader title and subtitle
  void updateGalleryHero(String title, String description) {
    _content = _content.copyWith(
      galleryHeroTitle: title, // New gallery page headline
      galleryHeroDescription: description, // New gallery page description
    );
    saveContent(); // Persist and notify
  }

  /// Replaces the entire gallery image collection.
  /// CALLED BY: screens/admin/editors/gallery_editor.dart → 'Save Gallery' button
  /// AFFECTS: screens/gallery_screen.dart → gallery grid with GalleryCardWidget items
  void updateGalleryImages(List<GalleryImage> images) {
    _content = _content.copyWith(
      galleryImages: images, // Complete replacement of gallery image list
    );
    saveContent(); // Persist and notify
  }

  /// Replaces the platform's key feature list.
  /// CALLED BY: screens/admin/editors/home_editor.dart → features management section
  /// AFFECTS: screens/home_screen.dart → _WhySectionSliver → FeatureCard widgets
  void updateFeatures(List<Feature> features) {
    _content = _content.copyWith(
      features: features, // Complete replacement of features list
    );
    saveContent(); // Persist and notify
  }

  /// Replaces the team member registry.
  /// CALLED BY: screens/admin/editors/about_editor.dart → team members management
  /// AFFECTS: screens/about_screen.dart → _buildTeamSection → TeamCard widgets
  void updateTeamMembers(List<TeamMember> team) {
    _content = _content.copyWith(
      teamMembers: team, // Complete replacement of team members list
    );
    saveContent(); // Persist and notify
  }

  /// Replaces the donation impact tiers.
  /// CALLED BY: screens/admin/editors/donate_editor.dart → tiers management section
  /// AFFECTS: screens/donate_screen.dart → _buildDonationTiers → DonationTierCard widgets
  void updateDonationTiers(List<DonationTier> tiers) {
    _content = _content.copyWith(
      donationTiers: tiers, // Complete replacement of donation tiers list
    );
    saveContent(); // Persist and notify
  }

  /// Adds a new course to the curriculum.
  /// CALLED BY: screens/admin/editors/courses_editor.dart → 'Add Course' button
  /// AFFECTS: screens/courses_screen.dart → new course card appears in the grid
  /// AFFECTS: screens/home_screen.dart → new course appears in top-3 preview
  void addCourse(Course course) {
    _content.courses.add(course); // Append the new course to the existing list
    saveContent(); // Persist and notify
  }

  /// Updates an existing course at a specific index in the courses list.
  /// CALLED BY: screens/admin/editors/courses_editor.dart → 'Update' button on course tile
  /// AFFECTS: The corresponding course card in courses_screen.dart and home_screen.dart
  void updateCourse(int index, Course course) {
    _content.courses[index] = course; // Replace the course at the given position
    saveContent(); // Persist and notify
  }

  /// Permanently removes a course from the curriculum by its index.
  /// CALLED BY: screens/admin/editors/courses_editor.dart → 'Delete' button on course tile
  /// AFFECTS: The course card is removed from courses_screen.dart and home_screen.dart
  void removeCourse(int index) {
    _content.courses.removeAt(index); // Remove the course at the given position
    saveContent(); // Persist and notify
  }
}
