/// ═══════════════════════════════════════════════════════════════════════
/// FILE: content_model.dart
/// PURPOSE: Defines ALL data models for the platform's headless CMS.
///          Every piece of dynamic text, image, and configuration on the
///          website is represented by one of the classes in this file.
/// CONNECTIONS:
///   - USED BY: providers/dynamic_content_provider.dart (reads/writes AppContent)
///   - USED BY: All screen files (access content fields via provider.content.*)
///   - USED BY: All admin editor files (modify content via provider.update*() methods)
///   - SYNCED WITH: Firebase Firestore document at 'content/website'
/// ═══════════════════════════════════════════════════════════════════════

/// Represents a single educational course offered by the platform.
/// Contains all metadata required to render the course details and curriculum.
///
/// USED BY:
///   - screens/home_screen.dart → CourseCard widget (shows title, description, duration, fee)
///   - screens/courses_screen.dart → _expandedCourseCard (shows full details + topics)
///   - screens/admin/editors/courses_editor.dart → CRUD operations on courses
///   - providers/dynamic_content_provider.dart → addCourse(), updateCourse(), removeCourse()
class Course {
  /// The display title of the course (e.g., 'AI Mastery').
  /// Rendered as the card heading in home_screen.dart and courses_screen.dart.
  final String title;

  /// A brief overview of what the student will learn.
  /// Shown as body text in CourseCard and expanded course detail view.
  final String description;

  /// String representation of an emoji or icon used for the course (e.g., '🤖').
  /// Rendered via renderDynamicIcon() in widgets/utils/dynamic_icon.dart.
  final String icon;

  /// Time duration for the course completion (e.g., '3 Months').
  /// Displayed alongside the fee in course listings.
  final String duration;

  /// Enrollment fee in local currency (e.g., 'Rs. 8,000').
  /// Displayed as a prominent label in CourseCard and expanded view.
  final String fee;

  /// Detailed list of curriculum topics or modules (e.g., ['ChatGPT & Prompt Engineering']).
  /// Rendered as a checklist in courses_screen.dart _expandedCourseCard().
  final List<String> topics;

  /// Optional external URL for the course registration form.
  /// When set, the 'Register Now' button in courses_screen.dart opens this link.
  /// When null or empty, the button falls back to the contact page.
  final String? registrationLink;

  /// Constructor requiring all fields to create a complete Course instance.
  Course({
    required this.title,
    required this.description,
    required this.icon,
    required this.duration,
    required this.fee,
    required this.topics,
    this.registrationLink, // Optional; null means fallback to contact page
  });

  /// Converts the Course instance into a JSON-compatible map.
  /// Called by AppContent.toJson() when saving the entire state to Firestore.
  /// Each field maps directly to a Firestore document field name.
  Map<String, dynamic> toJson() => {
        'title': title, // Maps to Firestore field 'title'
        'description': description, // Maps to Firestore field 'description'
        'icon': icon, // Maps to Firestore field 'icon'
        'duration': duration, // Maps to Firestore field 'duration'
        'fee': fee, // Maps to Firestore field 'fee'
        'topics': topics, // Maps to Firestore field 'topics' (stored as array)
        'registrationLink': registrationLink, // Optional external registration URL
      };

  /// Factory constructor to create a Course instance from a Firestore JSON map.
  /// Called by AppContent.fromJson() when loading data from Firestore.
  /// The '?? '🎓'' provides a safe default if the icon field is missing in old documents.
  factory Course.fromJson(Map<String, dynamic> json) => Course(
        title: json['title'], // Reads the 'title' field from Firestore document
        description: json['description'], // Reads the 'description' field
        icon: json['icon'] ?? '🎓', // Fallback emoji if icon is null in Firestore
        duration: json['duration'], // Reads the 'duration' field
        fee: json['fee'], // Reads the 'fee' field
        topics: List<String>.from(json['topics']), // Converts Firestore array to Dart List<String>
        registrationLink: json['registrationLink'], // Optional; null if not set in Firestore
      );
}

/// Represents a key feature or selling point of the platform.
/// Displayed in the 'Why Hunarmand Kashmir?' section on the home screen.
///
/// USED BY:
///   - screens/home_screen.dart → _WhySectionSliver → FeatureCard widget
///   - widgets/cards/feature_card.dart → renders icon, title, description
///   - screens/admin/editors/home_editor.dart → edit features list
///   - providers/dynamic_content_provider.dart → updateFeatures()
class Feature {
  final String icon;
  final String title;
  final String description;

  Feature({
    required this.icon,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'icon': icon,
        'title': title,
        'description': description,
      };

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        icon: json['icon'] ?? '✨',
        title: json['title'],
        description: json['description'],
      );
}

class Stat {
  final String icon;
  final String value;
  final String label;

  Stat({
    required this.icon,
    required this.value,
    required this.label,
  });

  Map<String, dynamic> toJson() => {
        'icon': icon,
        'value': value,
        'label': label,
      };

  factory Stat.fromJson(Map<String, dynamic> json) => Stat(
        icon: json['icon'] ?? '📊',
        value: json['value'],
        label: json['label'],
      );
}

/// Defines a specific financial tier for users to donate and support students.
/// Each tier represents a suggested donation amount and its projected impact.
///
/// USED BY:
///   - screens/donate_screen.dart → _buildDonationTiers() → DonationTierCard widget
///   - widgets/cards/donation_tier_card.dart → renders icon, title, amount, description
///   - screens/admin/editors/donate_editor.dart → CRUD operations on tiers
///   - providers/dynamic_content_provider.dart → updateDonationTiers()
class DonationTier {
  /// Label for the tier (e.g., 'Small Support', 'Growth Pack').
  final String title;

  /// Suggested donation amount as a formatted string (e.g., '\$10', '\$50').
  final String amount;

  /// Explanation of how the donation will be utilized.
  final String description;

  /// Emoji representing the impact of the donation (e.g., '☕', '🌱').
  /// Rendered via renderDynamicIcon() in widgets/utils/dynamic_icon.dart.
  final String icon;

  /// Highlights this tier as the most recommended option in the UI.
  /// When true, DonationTierCard shows a 'MOST POPULAR' badge and gold border.
  final bool popular;

  /// Constructor with required fields and an optional [popular] flag (defaults to false).
  DonationTier({
    required this.title,
    required this.amount,
    required this.description,
    required this.icon,
    this.popular = false, // Most tiers are not popular by default
  });

  /// Serializes the DonationTier to a JSON map for Firestore storage.
  /// Called as part of AppContent.toJson() → donationTiers.map((x) => x.toJson()).
  Map<String, dynamic> toJson() => {
        'title': title, // Tier label
        'amount': amount, // Formatted currency string
        'description': description, // Impact narrative
        'icon': icon, // Emoji string
        'popular': popular, // Boolean flag for UI emphasis
      };

  /// Deserializes a DonationTier from a Firestore JSON map.
  /// Falls back to '❤️' for missing icons and false for missing popular flag.
  factory DonationTier.fromJson(Map<String, dynamic> json) => DonationTier(
        title: json['title'], // Reads tier title from Firestore
        amount: json['amount'], // Reads amount from Firestore
        description: json['description'], // Reads description from Firestore
        icon: json['icon'] ?? '❤️', // Safe fallback if icon is null
        popular: json['popular'] ?? false, // Safe fallback if popular flag is missing
      );
}

/// Information about a member of the Hunarmand instructional or leadership team.
/// Displayed in the 'Voices of Guidance' section on the About page.
///
/// USED BY:
///   - screens/about_screen.dart → _buildTeamSection() → TeamCard widget
///   - screens/admin/editors/about_editor.dart → edit team members list
///   - providers/dynamic_content_provider.dart → updateTeamMembers()
class TeamMember {
  /// Full name of the team member (e.g., 'Adnan Khan').
  final String name;

  /// Professional role or title (e.g., 'Lead Mentor').
  final String role;

  /// Network URL for the team member's profile image, or an emoji fallback.
  /// If it starts with 'http', about_screen.dart renders it via Image.network();
  /// otherwise it displays as a centered Text emoji.
  final String imageUrl;

  /// Constructor requiring all three fields.
  TeamMember({
    required this.name,
    required this.role,
    required this.imageUrl,
  });

  /// Serializes the TeamMember to a JSON map for Firestore storage.
  Map<String, dynamic> toJson() => {
        'name': name, // Full name string
        'role': role, // Role/title string
        'imageUrl': imageUrl, // URL string or emoji
      };

  /// Deserializes a TeamMember from a Firestore JSON map.
  /// Handles legacy data where the image might be stored under 'icon' instead of 'imageUrl'.
  /// Falls back to a placeholder image URL if neither field exists.
  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
        name: json['name'], // Reads name from Firestore
        role: json['role'], // Reads role from Firestore
        imageUrl: json['imageUrl'] ?? // First tries 'imageUrl' field
            (json['icon'] ?? // Then tries legacy 'icon' field
                'https://via.placeholder.com/200?text=Team'), // Final fallback: placeholder
      );
}

/// Metadata for a single image in the site's media gallery.
/// Displayed as interactive cards in the Gallery screen with hover effects.
///
/// USED BY:
///   - screens/gallery_screen.dart → GalleryCardWidget (renders image + label overlay)
///   - screens/admin/editors/gallery_editor.dart → _buildGalleryOrganizer() for CRUD
///   - providers/dynamic_content_provider.dart → updateGalleryImages()
class GalleryImage {
  /// Direct URL to the hosted image asset (e.g., Unsplash or custom CDN URL).
  /// Loaded via Image.network() in gallery_screen.dart's GalleryCardWidget.
  final String imageUrl;

  /// Caption or contextual label for the image (e.g., 'Web Development Lab').
  /// Shown as an overlay at the bottom of each gallery card.
  final String label;

  /// Constructor requiring both the URL and label fields.
  GalleryImage({required this.imageUrl, required this.label});

  /// Serializes the GalleryImage to a JSON map for Firestore storage.
  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl, // The hosted image URL
        'label': label, // The descriptive caption
      };

  /// Deserializes a GalleryImage from a Firestore JSON map.
  /// Handles legacy data where the URL might be stored under 'icon'.
  /// Falls back to a placeholder if no URL is found; defaults label to empty string.
  factory GalleryImage.fromJson(Map<String, dynamic> json) => GalleryImage(
        imageUrl: json['imageUrl'] ?? // First tries 'imageUrl'
            (json['icon'] ?? // Then tries legacy 'icon' field
                'https://via.placeholder.com/400x300?text=Gallery+Image'), // Placeholder fallback
        label: json['label'] ?? '', // Defaults to empty string if label is missing
      );
}

/// Defines dynamic theme variables to manage application styles via the CMS.
/// Stored inside AppContent to allow global broadcast of design changes.
class ThemeConfig {
  final String primaryColorHex;
  final String accentColorHex;
  final String backgroundColorHex;
  final String cardBackgroundColorHex;
  final String textDarkHex;
  final String textLightHex;

  final double cardBorderRadius;
  final double buttonBorderRadius;

  ThemeConfig({
    required this.primaryColorHex,
    required this.accentColorHex,
    required this.backgroundColorHex,
    required this.cardBackgroundColorHex,
    required this.textDarkHex,
    required this.textLightHex,
    required this.cardBorderRadius,
    required this.buttonBorderRadius,
  });

  Map<String, dynamic> toJson() => {
        'primaryColorHex': primaryColorHex,
        'accentColorHex': accentColorHex,
        'backgroundColorHex': backgroundColorHex,
        'cardBackgroundColorHex': cardBackgroundColorHex,
        'textDarkHex': textDarkHex,
        'textLightHex': textLightHex,
        'cardBorderRadius': cardBorderRadius,
        'buttonBorderRadius': buttonBorderRadius,
      };

  factory ThemeConfig.fromJson(Map<String, dynamic>? json) => ThemeConfig(
        primaryColorHex: json?['primaryColorHex'] ?? '#0D3320', // Default darkGreen
        accentColorHex: json?['accentColorHex'] ?? '#F5A623', // Default gold
        backgroundColorHex: json?['backgroundColorHex'] ?? '#FAFAFA',
        cardBackgroundColorHex: json?['cardBackgroundColorHex'] ?? '#FFFFFF',
        textDarkHex: json?['textDarkHex'] ?? '#1A1A1A',
        textLightHex: json?['textLightHex'] ?? '#FFFFFF',
        cardBorderRadius: (json?['cardBorderRadius'] ?? 20.0).toDouble(),
        buttonBorderRadius: (json?['buttonBorderRadius'] ?? 16.0).toDouble(),
      );
}

/// Defines structural toggles to hide or show entire sections and UI elements.
class LayoutConfig {
  final bool showHomeCourses;
  final bool showHomeFeatures;
  final bool showHomeWhyUs;
  final bool showHomeCta;
  final bool showHomeStats;
  final bool showAboutTeam;
  final bool showIconsInCards;

  LayoutConfig({
    required this.showHomeCourses,
    required this.showHomeFeatures,
    required this.showHomeWhyUs,
    required this.showHomeCta,
    required this.showHomeStats,
    required this.showAboutTeam,
    required this.showIconsInCards,
  });

  Map<String, dynamic> toJson() => {
        'showHomeCourses': showHomeCourses,
        'showHomeFeatures': showHomeFeatures,
        'showHomeWhyUs': showHomeWhyUs,
        'showHomeCta': showHomeCta,
        'showHomeStats': showHomeStats,
        'showAboutTeam': showAboutTeam,
        'showIconsInCards': showIconsInCards,
      };

  factory LayoutConfig.fromJson(Map<String, dynamic>? json) => LayoutConfig(
        showHomeCourses: json?['showHomeCourses'] ?? true,
        showHomeFeatures: json?['showHomeFeatures'] ?? true,
        showHomeWhyUs: json?['showHomeWhyUs'] ?? true,
        showHomeCta: json?['showHomeCta'] ?? true,
        showHomeStats: json?['showHomeStats'] ?? true,
        showAboutTeam: json?['showAboutTeam'] ?? true,
        showIconsInCards: json?['showIconsInCards'] ?? true,
      );
}

/// The root model representing the entire dynamic content state of the platform.
/// This single object contains EVERY piece of text, image URL, and configuration
/// that appears on the website. It is synchronized with Firestore to enable
/// real-time admin updates without code deployment.
///
/// ARCHITECTURE:
///   1. DynamicContentProvider holds one instance of AppContent (_content)
///   2. Firestore document 'content/website' is the persistent storage
///   3. Any admin change → update*() → copyWith() → saveContent() → Firestore → notifyListeners()
///   4. Consumer<DynamicContentProvider> in screens rebuilds UI with new data
///
/// USED BY:
///   - providers/dynamic_content_provider.dart → _content field, all update*() methods
///   - Every screen file → reads content.* fields via Consumer<DynamicContentProvider>
///   - Every admin editor → modifies content via provider.update*() methods
class AppContent {
  /// Global title shown in the browser tab and app headers.
  final String appTitle;

  /// Optional URL for a graphical logo image.
  /// When non-null and non-empty, app bar and drawer show Image.network() instead of logoText.
  final String? logoPath;

  /// Main headline for the Home screen hero section.
  /// Rendered in _HeroSection of home_screen.dart with PlayfairDisplay font.
  final String heroHeadline;

  /// Supporting sub-headline for the Home screen hero section.
  /// Shown below the headline in lighter, smaller text.
  final String heroSubheadline;

  /// Master list of courses offered by the institute.
  /// Rendered in home_screen.dart (top 3) and courses_screen.dart (all).
  final List<Course> courses;

  /// Platform statistics shown on the home screen.
  final List<Stat> stats;

  /// List of selling points of the platform.
  /// Rendered in home_screen.dart _WhySectionSliver → FeatureCard widgets.
  final List<Feature> features;

  /// Configurable donation levels for the public.
  /// Rendered in donate_screen.dart → DonationTierCard widgets.
  final List<DonationTier> donationTiers;

  /// Public profiles of team members.
  /// Rendered in about_screen.dart _buildTeamSection() → TeamCard widgets.
  final List<TeamMember> teamMembers;

  /// Branding description shown in the site footer (app_footer.dart).
  final String footerDescription;

  /// Physical headquarters address. Shown in contact_screen.dart and app_footer.dart.
  final String contactAddress;

  /// Primary official phone number. Shown in contact_screen.dart and app_footer.dart.
  final String contactPhone;

  /// Official email address for inquiries. Shown in contact_screen.dart and app_footer.dart.
  final String contactEmail;

  /// Headline for the donation page hero section (donate_screen.dart _buildHero).
  final String donateHeroTitle;

  /// Supporting text for the donation page (donate_screen.dart _buildHero).
  final String donateHeroDescription;

  /// Headline for the contact page hero section (contact_screen.dart SliverGreenPageHeader).
  final String contactHeroTitle;

  /// Supporting text for the contact page (contact_screen.dart SliverGreenPageHeader).
  final String contactHeroDescription;

  /// Main headline for the about page story section (about_screen.dart _buildStorySection).
  final String aboutStoryHeadline;

  /// The full history and narrative of the initiative (about_screen.dart _buildStoryText).
  final String aboutStoryText;

  /// Mission statement of Hunarmand Kashmir (about_screen.dart _buildMissionVisionSection).
  final String aboutMissionText;
  final String aboutMissionIcon;

  /// Long-term vision statement (about_screen.dart _buildMissionVisionSection).
  final String aboutVisionText;
  final String aboutVisionIcon;

  /// Core principles and values (about_screen.dart _buildMissionVisionSection).
  final String aboutValuesText;
  final String aboutValuesIcon;

  /// Headline for the 'Why Us' section on the home screen (home_screen.dart _WhySectionSliver).
  final String homeWhyTitle;

  /// Detailed description for the 'Why Us' section.
  final String homeWhyDescription;

  /// Headline for the Call-To-Action section (home_screen.dart _CtaSection).
  final String homeCtaTitle;

  /// Body text for the Call-To-Action section.
  final String homeCtaDescription;

  /// Headline for the 'Learning Choice' section (courses_screen.dart).
  final String courseLearningChoiceTitle;

  /// Sub-description for the 'Learning Choice' section.
  final String courseLearningChoiceDescription;

  /// Icon for Location 1 (Freelancing Hub).
  final String courseLocation1Icon;
  final String courseLocation1Title;
  final String courseLocation1Text;
  final String courseLocation1Timing;

  /// Icon for Location 2 (STP).
  final String courseLocation2Icon;
  final String courseLocation2Title;
  final String courseLocation2Text;
  final String courseLocation2Timing;

  /// Icon for Location 3 (Online).
  final String courseLocation3Icon;
  final String courseLocation3Title;
  final String courseLocation3Text;
  final String courseLocation3Timing;

  /// Icon for Orphan Support section.
  final String courseOrphanSupportIcon;
  final String courseOrphanSupportTitle;
  final String courseOrphanSupportDescription;

  /// Headline for the gallery page (gallery_screen.dart SliverGreenPageHeader).
  final String galleryHeroTitle;

  /// Sub-headline for the gallery page.
  final String galleryHeroDescription;

  /// Collection of images for the gallery (gallery_screen.dart grid).
  final List<GalleryImage> galleryImages;

  /// Global design configuration (colors, corner radii).
  final ThemeConfig themeConfig;

  /// Structural visibility toggles (hide/show sections).
  final LayoutConfig layoutConfig;

  /// Master constructor requiring all content fields.
  /// Called by fromJson() (Firestore load) and _getDefaults() (first-run seeding).
  AppContent({
    required this.appTitle,
    this.logoPath,
    required this.heroHeadline,
    required this.heroSubheadline,
    required this.courses,
    required this.stats,
    required this.features,
    required this.donationTiers,
    required this.teamMembers,
    required this.footerDescription,
    required this.contactAddress,
    required this.contactPhone,
    required this.contactEmail,
    required this.aboutStoryHeadline,
    required this.aboutStoryText,
    required this.aboutMissionText,
    required this.aboutMissionIcon,
    required this.aboutVisionText,
    required this.aboutVisionIcon,
    required this.aboutValuesText,
    required this.aboutValuesIcon,
    required this.donateHeroTitle,
    required this.donateHeroDescription,
    required this.contactHeroTitle,
    required this.contactHeroDescription,
    required this.homeWhyTitle,
    required this.homeWhyDescription,
    required this.homeCtaTitle,
    required this.homeCtaDescription,
    required this.courseLearningChoiceTitle,
    required this.courseLearningChoiceDescription,
    required this.courseLocation1Icon,
    required this.courseLocation1Title,
    required this.courseLocation1Text,
    required this.courseLocation1Timing,
    required this.courseLocation2Icon,
    required this.courseLocation2Title,
    required this.courseLocation2Text,
    required this.courseLocation2Timing,
    required this.courseLocation3Icon,
    required this.courseLocation3Title,
    required this.courseLocation3Text,
    required this.courseLocation3Timing,
    required this.courseOrphanSupportIcon,
    required this.courseOrphanSupportTitle,
    required this.courseOrphanSupportDescription,
    required this.galleryHeroTitle,
    required this.galleryHeroDescription,
    required this.galleryImages,
    required this.themeConfig,
    required this.layoutConfig,
  });

  /// Creates a copy of the current AppContent with modified values.
  /// Facilitates the 'immutability and update' pattern used in state management.
  ///
  /// CALLED BY: Every update*() method in DynamicContentProvider.
  /// PATTERN: Old state → copyWith(changedField: newValue) → new AppContent instance
  /// This ensures the old state is never mutated, enabling clean state transitions.
  ///
  /// Each parameter is optional (nullable). If null, the current value is preserved.
  /// If a new value is provided, it replaces the old one in the returned copy.
  AppContent copyWith({
    String? appTitle,
    String? logoPath,
    String? heroHeadline,
    String? heroSubheadline,
    List<Course>? courses,
    List<Stat>? stats,
    List<Feature>? features,
    List<DonationTier>? donationTiers,
    List<TeamMember>? teamMembers,
    String? footerDescription,
    String? contactAddress,
    String? contactPhone,
    String? contactEmail,
    String? aboutStoryHeadline,
    String? aboutStoryText,
    String? aboutMissionText,
    String? aboutMissionIcon,
    String? aboutVisionText,
    String? aboutVisionIcon,
    String? aboutValuesText,
    String? aboutValuesIcon,
    String? donateHeroTitle,
    String? donateHeroDescription,
    String? contactHeroTitle,
    String? contactHeroDescription,
    String? homeWhyTitle,
    String? homeWhyDescription,
    String? homeCtaTitle,
    String? homeCtaDescription,
    String? courseLearningChoiceTitle,
    String? courseLearningChoiceDescription,
    String? courseLocation1Icon,
    String? courseLocation1Title,
    String? courseLocation1Text,
    String? courseLocation1Timing,
    String? courseLocation2Icon,
    String? courseLocation2Title,
    String? courseLocation2Text,
    String? courseLocation2Timing,
    String? courseLocation3Icon,
    String? courseLocation3Title,
    String? courseLocation3Text,
    String? courseLocation3Timing,
    String? courseOrphanSupportIcon,
    String? courseOrphanSupportTitle,
    String? courseOrphanSupportDescription,
    String? galleryHeroTitle,
    String? galleryHeroDescription,
    List<GalleryImage>? galleryImages,
    ThemeConfig? themeConfig,
    LayoutConfig? layoutConfig,
  }) {
    // Creating a brand-new AppContent instance.
    // For each field: use the new value if provided, otherwise keep the existing value (this.*).
    return AppContent(
      appTitle: appTitle ?? this.appTitle, // Keep old if null
      logoPath: logoPath ?? this.logoPath, // Keep old if null
      heroHeadline: heroHeadline ?? this.heroHeadline, // Keep old if null
      heroSubheadline: heroSubheadline ?? this.heroSubheadline, // Keep old if null
      courses: courses ?? this.courses, // Keep old list if null
      stats: stats ?? this.stats, // Keep old list if null
      features: features ?? this.features, // Keep old list if null
      donationTiers: donationTiers ?? this.donationTiers, // Keep old list if null
      teamMembers: teamMembers ?? this.teamMembers, // Keep old list if null
      footerDescription: footerDescription ?? this.footerDescription, // Keep old if null
      contactAddress: contactAddress ?? this.contactAddress, // Keep old if null
      contactPhone: contactPhone ?? this.contactPhone, // Keep old if null
      contactEmail: contactEmail ?? this.contactEmail, // Keep old if null
      aboutStoryHeadline: aboutStoryHeadline ?? this.aboutStoryHeadline,
      aboutStoryText: aboutStoryText ?? this.aboutStoryText,
      aboutMissionText: aboutMissionText ?? this.aboutMissionText,
      aboutMissionIcon: aboutMissionIcon ?? this.aboutMissionIcon,
      aboutVisionText: aboutVisionText ?? this.aboutVisionText,
      aboutVisionIcon: aboutVisionIcon ?? this.aboutVisionIcon,
      aboutValuesText: aboutValuesText ?? this.aboutValuesText,
      aboutValuesIcon: aboutValuesIcon ?? this.aboutValuesIcon, // Keep old if null
      donateHeroTitle: donateHeroTitle ?? this.donateHeroTitle, // Keep old if null
      donateHeroDescription: donateHeroDescription ?? this.donateHeroDescription, // Keep old if null
      contactHeroTitle: contactHeroTitle ?? this.contactHeroTitle, // Keep old if null
      contactHeroDescription: contactHeroDescription ?? this.contactHeroDescription, // Keep old if null
      homeWhyTitle: homeWhyTitle ?? this.homeWhyTitle, // Keep old if null
      homeWhyDescription: homeWhyDescription ?? this.homeWhyDescription, // Keep old if null
      homeCtaTitle: homeCtaTitle ?? this.homeCtaTitle, // Keep old if null
      homeCtaDescription: homeCtaDescription ?? this.homeCtaDescription, // Keep old if null
      courseLearningChoiceTitle: courseLearningChoiceTitle ?? this.courseLearningChoiceTitle,
      courseLearningChoiceDescription: courseLearningChoiceDescription ?? this.courseLearningChoiceDescription,
      courseLocation1Icon: courseLocation1Icon ?? this.courseLocation1Icon,
      courseLocation1Title: courseLocation1Title ?? this.courseLocation1Title,
      courseLocation1Text: courseLocation1Text ?? this.courseLocation1Text,
      courseLocation1Timing: courseLocation1Timing ?? this.courseLocation1Timing,
      courseLocation2Icon: courseLocation2Icon ?? this.courseLocation2Icon,
      courseLocation2Title: courseLocation2Title ?? this.courseLocation2Title,
      courseLocation2Text: courseLocation2Text ?? this.courseLocation2Text,
      courseLocation2Timing: courseLocation2Timing ?? this.courseLocation2Timing,
      courseLocation3Icon: courseLocation3Icon ?? this.courseLocation3Icon,
      courseLocation3Title: courseLocation3Title ?? this.courseLocation3Title,
      courseLocation3Text: courseLocation3Text ?? this.courseLocation3Text,
      courseLocation3Timing: courseLocation3Timing ?? this.courseLocation3Timing,
      courseOrphanSupportIcon: courseOrphanSupportIcon ?? this.courseOrphanSupportIcon,
      courseOrphanSupportTitle: courseOrphanSupportTitle ?? this.courseOrphanSupportTitle,
      courseOrphanSupportDescription: courseOrphanSupportDescription ?? this.courseOrphanSupportDescription,
      galleryHeroTitle: galleryHeroTitle ?? this.galleryHeroTitle, // Keep old if null
      galleryHeroDescription: galleryHeroDescription ?? this.galleryHeroDescription, // Keep old if null
      galleryImages: galleryImages ?? this.galleryImages, // Keep old list if null
      themeConfig: themeConfig ?? this.themeConfig, // Keep old config if null
      layoutConfig: layoutConfig ?? this.layoutConfig, // Keep old layout if null
    );
  }

  /// Serializes the entire application content to a JSON map.
  /// Called by DynamicContentProvider.saveContent() to persist state to Firestore.
  /// Each nested model (Course, Feature, etc.) calls its own toJson() method.
  Map<String, dynamic> toJson() => {
        'appTitle': appTitle, // Serializes the app title string
        'logoPath': logoPath, // Serializes the optional logo URL (can be null)
        'heroHeadline': heroHeadline, // Serializes the hero headline
        'heroSubheadline': heroSubheadline, // Serializes the hero subheadline
        'courses': courses.map((x) => x.toJson()).toList(), // Converts each Course to JSON map, then collects into a List
        'stats': stats.map((x) => x.toJson()).toList(), // Converts each Stat to JSON map
        'features': features.map((x) => x.toJson()).toList(), // Converts each Feature to JSON map
        'donationTiers': donationTiers.map((x) => x.toJson()).toList(), // Converts each DonationTier to JSON map
        'teamMembers': teamMembers.map((x) => x.toJson()).toList(), // Converts each TeamMember to JSON map
        'footerDescription': footerDescription, // Serializes footer text
        'contactAddress': contactAddress, // Serializes address string
        'contactPhone': contactPhone, // Serializes phone string
        'contactEmail': contactEmail, // Serializes email string
        'aboutStoryHeadline': aboutStoryHeadline,
        'aboutStoryText': aboutStoryText,
        'aboutMissionText': aboutMissionText,
        'aboutMissionIcon': aboutMissionIcon,
        'aboutVisionText': aboutVisionText,
        'aboutVisionIcon': aboutVisionIcon,
        'aboutValuesText': aboutValuesText,
        'aboutValuesIcon': aboutValuesIcon, // Serializes values narrative
        'donateHeroTitle': donateHeroTitle, // Serializes donate page title
        'donateHeroDescription': donateHeroDescription, // Serializes donate page description
        'contactHeroTitle': contactHeroTitle, // Serializes contact page title
        'contactHeroDescription': contactHeroDescription, // Serializes contact page description
        'homeWhyTitle': homeWhyTitle, // Serializes 'Why Us' title
        'homeWhyDescription': homeWhyDescription, // Serializes 'Why Us' description
        'homeCtaTitle': homeCtaTitle, // Serializes CTA title
        'homeCtaDescription': homeCtaDescription, // Serializes CTA description
        'courseLearningChoiceTitle': courseLearningChoiceTitle,
        'courseLearningChoiceDescription': courseLearningChoiceDescription,
        'courseLocation1Icon': courseLocation1Icon,
        'courseLocation1Title': courseLocation1Title,
        'courseLocation1Text': courseLocation1Text,
        'courseLocation1Timing': courseLocation1Timing,
        'courseLocation2Icon': courseLocation2Icon,
        'courseLocation2Title': courseLocation2Title,
        'courseLocation2Text': courseLocation2Text,
        'courseLocation2Timing': courseLocation2Timing,
        'courseLocation3Icon': courseLocation3Icon,
        'courseLocation3Title': courseLocation3Title,
        'courseLocation3Text': courseLocation3Text,
        'courseLocation3Timing': courseLocation3Timing,
        'courseOrphanSupportIcon': courseOrphanSupportIcon,
        'courseOrphanSupportTitle': courseOrphanSupportTitle,
        'courseOrphanSupportDescription': courseOrphanSupportDescription,
        'galleryHeroTitle': galleryHeroTitle, // Serializes gallery title
        'galleryHeroDescription': galleryHeroDescription, // Serializes gallery description
        'galleryImages': galleryImages.map((x) => x.toJson()).toList(), // Converts each GalleryImage to JSON map
        'themeConfig': themeConfig.toJson(), // Serializes theme config
        'layoutConfig': layoutConfig.toJson(), // Serializes layout config
      };

  /// Main factory constructor for synchronizing state with Firestore.
  /// Called by DynamicContentProvider._loadFromFirestore() when a Firestore snapshot arrives.
  /// Each field reads from the JSON map with safe fallback defaults for backward compatibility.
  ///
  /// PATTERN: Firestore document → Map<String, dynamic> → AppContent.fromJson(map) → _content
  factory AppContent.fromJson(Map<String, dynamic> json) => AppContent(
        appTitle: json['appTitle'], // Reads global app title from Firestore
        logoPath: json['logoPath'], // Reads optional logo URL (may be null)
        heroHeadline: json['heroHeadline'], // Reads hero headline
        heroSubheadline: json['heroSubheadline'], // Reads hero subheadline
        // Deserializes each course JSON map into a Course object, then collects into a typed List
        courses: List<Course>.from(json['courses'].map((x) => Course.fromJson(x))),
        // Deserializes each stat JSON map into a Stat object
        stats: List<Stat>.from((json['stats'] ?? []).map((x) => Stat.fromJson(x))),
        // Deserializes each feature JSON map into a Feature object
        features: List<Feature>.from(json['features'].map((x) => Feature.fromJson(x))),
        // Deserializes each donation tier JSON map into a DonationTier object
        donationTiers: List<DonationTier>.from(json['donationTiers'].map((x) => DonationTier.fromJson(x))),
        // Deserializes each team member JSON map into a TeamMember object
        teamMembers: List<TeamMember>.from(json['teamMembers'].map((x) => TeamMember.fromJson(x))),
        footerDescription: json['footerDescription'], // Reads footer description from Firestore
        contactAddress: json['contactAddress'], // Reads contact address from Firestore
        contactPhone: json['contactPhone'], // Reads phone number from Firestore
        contactEmail: json['contactEmail'], // Reads email address from Firestore
        // All About-page fields have '' fallbacks for backward compatibility with older Firestore documents
        aboutStoryHeadline: json['aboutStoryHeadline'] ?? '',
        aboutStoryText: json['aboutStoryText'] ?? '',
        aboutMissionText: json['aboutMissionText'] ?? '',
        aboutMissionIcon: json['aboutMissionIcon'] ?? 'material:history',
        aboutVisionText: json['aboutVisionText'] ?? '',
        aboutVisionIcon: json['aboutVisionIcon'] ?? 'material:favorite',
        aboutValuesText: json['aboutValuesText'] ?? '',
        aboutValuesIcon: json['aboutValuesIcon'] ?? 'material:diversity', // Fallback: empty string
        // Donate page fields have descriptive fallback text for first-time deployments
        donateHeroTitle: json['donateHeroTitle'] ?? 'Invest in Dignity, Not Dependency.',
        donateHeroDescription: json['donateHeroDescription'] ?? 'Your contribution unlocks futures. Help empower youth in Kashmir to earn a livelihood and build self-reliant communities.',
        // Contact page fields with descriptive fallback text
        contactHeroTitle: json['contactHeroTitle'] ?? 'Get in Touch',
        contactHeroDescription: json['contactHeroDescription'] ?? 'Have questions? We are here to help you start your journey or discuss collaboration opportunities.',
        // Home page 'Why Us' section with descriptive fallback text
        homeWhyTitle: json['homeWhyTitle'] ?? 'Why Hunarmand Kashmir?',
        homeWhyDescription: json['homeWhyDescription'] ?? 'We believe in "Skills over Degrees". In a rapidly changing world, we provide practical, hands-on training that the industry demands, right here in Mirpur.',
        // Home page CTA section with descriptive fallback text
        homeCtaTitle: json['homeCtaTitle'] ?? 'Your Journey Begins Here',
        homeCtaDescription: json['homeCtaDescription'] ?? "Don't let lack of opportunity hold you back. Join Hunarmand Kashmir today and unlock a future of dignity, independence, and success.",
        courseLearningChoiceTitle: json['courseLearningChoiceTitle'] ?? 'Your Learning, Your Choice',
        courseLearningChoiceDescription: json['courseLearningChoiceDescription'] ?? 'Choose the location and schedule that fits your routine.',
        courseLocation1Icon: json['courseLocation1Icon'] ?? 'material:school',
        courseLocation1Title: json['courseLocation1Title'] ?? 'Freelancing Hub (HFK)',
        courseLocation1Text: json['courseLocation1Text'] ?? 'Hassan Colony, Mirpur',
        courseLocation1Timing: json['courseLocation1Timing'] ?? 'Mon–Fri Batches',
        courseLocation2Icon: json['courseLocation2Icon'] ?? 'material:business',
        courseLocation2Title: json['courseLocation2Title'] ?? 'SCO Software Technology Park',
        courseLocation2Text: json['courseLocation2Text'] ?? 'SCO Software Technology Park, Mirpur',
        courseLocation2Timing: json['courseLocation2Timing'] ?? 'Special Timing',
        courseLocation3Icon: json['courseLocation3Icon'] ?? 'material:laptop',
        courseLocation3Title: json['courseLocation3Title'] ?? 'Online Classes Live',
        courseLocation3Text: json['courseLocation3Text'] ?? 'Learn from anywhere in Kashmir',
        courseLocation3Timing: json['courseLocation3Timing'] ?? 'Flexible Timings',
        courseOrphanSupportIcon: json['courseOrphanSupportIcon'] ?? '❤️',
        courseOrphanSupportTitle: json['courseOrphanSupportTitle'] ?? 'Support for Orphans',
        courseOrphanSupportDescription: json['courseOrphanSupportDescription'] ?? 'We provide a 100% Fee Waiver for orphan students to ensure they have the same opportunities as everyone else.',
        // Gallery page fields with descriptive fallback text
        galleryHeroTitle: json['galleryHeroTitle'] ?? 'Moments of Hope',
        galleryHeroDescription: json['galleryHeroDescription'] ?? 'Witness the journey of transformation. From Mirpur to Bhimber, empowering every corner of Kashmir.',
        // Gallery images: checks if the field exists, deserializes if so, otherwise empty list
        galleryImages: json['galleryImages'] != null
            ? List<GalleryImage>.from(json['galleryImages'].map((x) => GalleryImage.fromJson(x)))
            : [], // Fallback: empty gallery for older Firestore documents
        themeConfig: ThemeConfig.fromJson(json['themeConfig']), // Safe deserialization
        layoutConfig: LayoutConfig.fromJson(json['layoutConfig']), // Safe deserialization
      );
}
