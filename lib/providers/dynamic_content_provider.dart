import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/content_model.dart';
import '../data/app_data.dart' as source;

class DynamicContentProvider extends ChangeNotifier {
  late AppContent _content;
  bool _isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _documentPath = 'content/website';
  var _subscription;

  AppContent get content => _content;
  bool get isLoading => _isLoading;

  DynamicContentProvider() {
    _init();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    _loadFromFirestore();
  }

  void _loadFromFirestore() {
    _subscription = _firestore.doc(_documentPath).snapshots().listen(
      (doc) {
        if (doc.exists && doc.data() != null) {
          _content = AppContent.fromJson(doc.data()!);
        } else {
          // First time initialization: use defaults and seed Firestore
          _content = _getDefaults();
          saveContent();
        }
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('Error in Firestore stream: $e');
        _content = _getDefaults();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  AppContent _getDefaults() {
    return AppContent(
      appTitle: 'Hunarmand Kashmir',
      logoText: 'ہنرمند',
      heroHeadline: 'Empowering Kashmir through Digital Excellence',
      heroSubheadline: 'Join the valley\'s premier skill-building initiative. Master modern technologies, build a global career, and transform your future with expert-led mentorship.',
      courses: source.AppData.courses.map((c) => Course(
        title: c.title,
        description: c.description,
        icon: '📚', // Refactored from IconData
        duration: c.duration,
        fee: c.fee,
        topics: c.topics,
      )).toList(),
      features: source.AppData.features.map((f) => Feature(
        icon: '🚀', // Refactored from IconData
        title: f.title,
        description: f.description,
      )).toList(),
      donationTiers: [
        DonationTier(title: 'Small Support', amount: '\$10', description: 'Helps one student with basic tools.', icon: '☕'),
        DonationTier(title: 'Growth Pack', amount: '\$50', description: 'Covers training for one month.', icon: '🌱', popular: true),
        DonationTier(title: 'Future Builder', amount: '\$200', description: 'Full scholarship for one student.', icon: '🏢'),
      ],
      teamMembers: [
        TeamMember(name: 'Adnan Khan', role: 'Lead Mentor', imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80'),
        TeamMember(name: 'Sarah Malik', role: 'Design Head', imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&q=80'),
        TeamMember(name: 'Omar Farooq', role: 'Web Instructor', imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&q=80'),
      ],
      footerDescription: 'Empowering Youth. Empowering the youth of Kashmir through digital skills, fostering self-reliance, and building a future where talent meets opportunity.',
      contactAddress: 'SCO Software Technology Park, Mirpur',
      contactPhone: '0313 884 0971',
      contactEmail: 'salam@hunarmandkashmir.com',
      aboutStoryHeadline: 'From Kashmir to Global Opportunities',
      aboutStoryText: 'Hunarmand Kashmir was born from a simple yet powerful truth: talent is everywhere, but opportunity is not. For far too long, the brilliant minds of Kashmir have faced challenges—geographical isolation, limited infrastructure, and limited exposure to global industries.\n\nWe believe digital skills are the great equalizer. With the right training, mentorship, and access, a student from even the most remote areas of Kashmir can work with companies and clients across the world.',
      aboutMissionText: 'To bridge the skills gap in Kashmir by delivering world-class digital training that empowers 10,000 young people by 2030 to achieve financial independence with dignity and confidence.',
      aboutVisionText: 'A self-reliant Kashmir where every young person has the skills to compete globally without leaving their homeland.',
      aboutValuesText: 'We are more than an institute; we are a family. We support each other, share opportunities, and grow together as a skilled collective.',
      donateHeroTitle: 'Invest in Dignity, Not Dependency.',
      donateHeroDescription: 'Your contribution unlocks futures. Help empower youth in Kashmir to earn a livelihood and build self-reliant communities.',
      contactHeroTitle: 'Get in Touch',
      contactHeroDescription: 'Have questions? We are here to help you start your journey or discuss collaboration opportunities.',
      homeWhyTitle: 'Why Hunarmand Kashmir?',
      homeWhyDescription: 'We believe in "Skills over Degrees". In a rapidly changing world, we provide practical, hands-on training that the industry demands, right here in Mirpur.',
      homeCtaTitle: 'Your Journey Begins Here',
      homeCtaDescription: "Don't let lack of opportunity hold you back. Join Hunarmand Kashmir today and unlock a future of dignity, independence, and success.",
      galleryHeroTitle: 'Moments of Hope',
      galleryHeroDescription: 'Witness the journey of transformation. From Mirpur to Bhimber, empowering every corner of Kashmir.',
      galleryImages: [
        GalleryImage(
            imageUrl: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&q=80',
            label: 'Web Development Lab'),
        GalleryImage(
            imageUrl: 'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=800&q=80',
            label: 'Design Studio'),
        GalleryImage(
            imageUrl: 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800&q=80',
            label: 'Coding Workshop'),
        GalleryImage(
            imageUrl: 'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=800&q=80',
            label: 'Mentorship Session'),
        GalleryImage(
            imageUrl: 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=800&q=80',
            label: 'Team Graduation'),
        GalleryImage(
            imageUrl: 'https://images.unsplash.com/photo-1427504494785-3a9ca7044f45?w=800&q=80',
            label: 'Campus View'),
        GalleryImage(
            imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&q=80',
            label: 'Digital Skills Training'),
        GalleryImage(
            imageUrl: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=800&q=80',
            label: 'Project Collaboration'),
      ],
    );
  }

  Future<void> saveContent() async {
    try {
      await _firestore.doc(_documentPath).set(_content.toJson());
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving content to Firestore: $e');
    }
  }

  void updateHero(String headline, String subheadline) {
    _content = _content.copyWith(
      heroHeadline: headline,
      heroSubheadline: subheadline,
    );
    saveContent();
  }

  void updateLogo(String? path, String text) {
    _content = _content.copyWith(
      logoText: text,
      logoPath: path,
    );
    saveContent();
  }

  void updateFooter(String description) {
    _content = _content.copyWith(
      footerDescription: description,
    );
    saveContent();
  }

  void updateContact(String address, String phone, String email) {
    _content = _content.copyWith(
      contactAddress: address,
      contactPhone: phone,
      contactEmail: email,
    );
    saveContent();
  }

  void updateAbout(String headline, String story, String mission, String vision, String values) {
    _content = _content.copyWith(
      aboutStoryHeadline: headline,
      aboutStoryText: story,
      aboutMissionText: mission,
      aboutVisionText: vision,
      aboutValuesText: values,
    );
    saveContent();
  }

  void updateDonateHero(String title, String description) {
    _content = _content.copyWith(
      donateHeroTitle: title,
      donateHeroDescription: description,
    );
    saveContent();
  }

  void updateContactHero(String title, String description) {
    _content = _content.copyWith(
      contactHeroTitle: title,
      contactHeroDescription: description,
    );
    saveContent();
  }

  void updateHomeWhy(String title, String description) {
    _content = _content.copyWith(
      homeWhyTitle: title,
      homeWhyDescription: description,
    );
    saveContent();
  }

  void updateHomeCta(String title, String description) {
    _content = _content.copyWith(
      homeCtaTitle: title,
      homeCtaDescription: description,
    );
    saveContent();
  }

  void updateGalleryHero(String title, String description) {
    _content = _content.copyWith(
      galleryHeroTitle: title,
      galleryHeroDescription: description,
    );
    saveContent();
  }

  void updateGalleryImages(List<GalleryImage> images) {
    _content = _content.copyWith(
      galleryImages: images,
    );
    saveContent();
  }

  void updateFeatures(List<Feature> features) {
    _content = _content.copyWith(
      features: features,
    );
    saveContent();
  }

  void updateTeamMembers(List<TeamMember> team) {
    _content = _content.copyWith(
      teamMembers: team,
    );
    saveContent();
  }

  void updateDonationTiers(List<DonationTier> tiers) {
    _content = _content.copyWith(
      donationTiers: tiers,
    );
    saveContent();
  }

  void addCourse(Course course) {
    _content.courses.add(course);
    saveContent();
  }

  void updateCourse(int index, Course course) {
    _content.courses[index] = course;
    saveContent();
  }

  void removeCourse(int index) {
    _content.courses.removeAt(index);
    saveContent();
  }
  
  // Similar methods for features, team, etc. can be added as needed
}
