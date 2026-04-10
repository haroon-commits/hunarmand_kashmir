import 'package:flutter/material.dart';

class Course {
  final String title;
  final String description;
  final String icon;
  final String duration;
  final String fee;
  final List<String> topics;

  Course({
    required this.title,
    required this.description,
    required this.icon,
    required this.duration,
    required this.fee,
    required this.topics,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'icon': icon,
        'duration': duration,
        'fee': fee,
        'topics': topics,
      };

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        title: json['title'],
        description: json['description'],
        icon: json['icon'] ?? '🎓',
        duration: json['duration'],
        fee: json['fee'],
        topics: List<String>.from(json['topics']),
      );
}

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

class DonationTier {
  final String title;
  final String amount;
  final String description;
  final String icon;
  final bool popular;

  DonationTier({
    required this.title,
    required this.amount,
    required this.description,
    required this.icon,
    this.popular = false,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'amount': amount,
        'description': description,
        'icon': icon,
        'popular': popular,
      };

  factory DonationTier.fromJson(Map<String, dynamic> json) => DonationTier(
        title: json['title'],
        amount: json['amount'],
        description: json['description'],
        icon: json['icon'] ?? '❤️',
        popular: json['popular'] ?? false,
      );
}

class TeamMember {
  final String name;
  final String role;
  final String imageUrl;

  TeamMember({
    required this.name,
    required this.role,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'role': role,
        'imageUrl': imageUrl,
      };

  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
        name: json['name'],
        role: json['role'],
        imageUrl: json['imageUrl'] ?? (json['icon'] ?? 'https://via.placeholder.com/200?text=Team'),
      );
}

class GalleryImage {
  final String imageUrl;
  final String label;

  GalleryImage({required this.imageUrl, required this.label});

  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
        'label': label,
      };

  factory GalleryImage.fromJson(Map<String, dynamic> json) => GalleryImage(
        imageUrl: json['imageUrl'] ?? (json['icon'] ?? 'https://via.placeholder.com/400x300?text=Gallery+Image'),
        label: json['label'] ?? '',
      );
}

class AppContent {
  final String appTitle;
  final String logoText;
  final String? logoPath;
  final String heroHeadline;
  final String heroSubheadline;
  final List<Course> courses;
  final List<Feature> features;
  final List<DonationTier> donationTiers;
  final List<TeamMember> teamMembers;
  final String footerDescription;
  final String contactAddress;
  final String contactPhone;
  final String contactEmail;
  final String donateHeroTitle;
  final String donateHeroDescription;
  final String contactHeroTitle;
  final String contactHeroDescription;
  final String aboutStoryHeadline;
  final String aboutStoryText;
  final String aboutMissionText;
  final String aboutVisionText;
  final String aboutValuesText;
  final String homeWhyTitle;
  final String homeWhyDescription;
  final String homeCtaTitle;
  final String homeCtaDescription;
  final String galleryHeroTitle;
  final String galleryHeroDescription;
  final List<GalleryImage> galleryImages;

  AppContent({
    required this.appTitle,
    required this.logoText,
    this.logoPath,
    required this.heroHeadline,
    required this.heroSubheadline,
    required this.courses,
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
    required this.aboutVisionText,
    required this.aboutValuesText,
    required this.donateHeroTitle,
    required this.donateHeroDescription,
    required this.contactHeroTitle,
    required this.contactHeroDescription,
    required this.homeWhyTitle,
    required this.homeWhyDescription,
    required this.homeCtaTitle,
    required this.homeCtaDescription,
    required this.galleryHeroTitle,
    required this.galleryHeroDescription,
    required this.galleryImages,
  });

  AppContent copyWith({
    String? appTitle,
    String? logoText,
    String? logoPath,
    String? heroHeadline,
    String? heroSubheadline,
    List<Course>? courses,
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
    String? aboutVisionText,
    String? aboutValuesText,
    String? donateHeroTitle,
    String? donateHeroDescription,
    String? contactHeroTitle,
    String? contactHeroDescription,
    String? homeWhyTitle,
    String? homeWhyDescription,
    String? homeCtaTitle,
    String? homeCtaDescription,
    String? galleryHeroTitle,
    String? galleryHeroDescription,
    List<GalleryImage>? galleryImages,
  }) {
    return AppContent(
      appTitle: appTitle ?? this.appTitle,
      logoText: logoText ?? this.logoText,
      logoPath: logoPath ?? this.logoPath,
      heroHeadline: heroHeadline ?? this.heroHeadline,
      heroSubheadline: heroSubheadline ?? this.heroSubheadline,
      courses: courses ?? this.courses,
      features: features ?? this.features,
      donationTiers: donationTiers ?? this.donationTiers,
      teamMembers: teamMembers ?? this.teamMembers,
      footerDescription: footerDescription ?? this.footerDescription,
      contactAddress: contactAddress ?? this.contactAddress,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      aboutStoryHeadline: aboutStoryHeadline ?? this.aboutStoryHeadline,
      aboutStoryText: aboutStoryText ?? this.aboutStoryText,
      aboutMissionText: aboutMissionText ?? this.aboutMissionText,
      aboutVisionText: aboutVisionText ?? this.aboutVisionText,
      aboutValuesText: aboutValuesText ?? this.aboutValuesText,
      donateHeroTitle: donateHeroTitle ?? this.donateHeroTitle,
      donateHeroDescription: donateHeroDescription ?? this.donateHeroDescription,
      contactHeroTitle: contactHeroTitle ?? this.contactHeroTitle,
      contactHeroDescription: contactHeroDescription ?? this.contactHeroDescription,
      homeWhyTitle: homeWhyTitle ?? this.homeWhyTitle,
      homeWhyDescription: homeWhyDescription ?? this.homeWhyDescription,
      homeCtaTitle: homeCtaTitle ?? this.homeCtaTitle,
      homeCtaDescription: homeCtaDescription ?? this.homeCtaDescription,
      galleryHeroTitle: galleryHeroTitle ?? this.galleryHeroTitle,
      galleryHeroDescription: galleryHeroDescription ?? this.galleryHeroDescription,
      galleryImages: galleryImages ?? this.galleryImages,
    );
  }

  Map<String, dynamic> toJson() => {
        'appTitle': appTitle,
        'logoText': logoText,
        'logoPath': logoPath,
        'heroHeadline': heroHeadline,
        'heroSubheadline': heroSubheadline,
        'courses': courses.map((x) => x.toJson()).toList(),
        'features': features.map((x) => x.toJson()).toList(),
        'donationTiers': donationTiers.map((x) => x.toJson()).toList(),
        'teamMembers': teamMembers.map((x) => x.toJson()).toList(),
        'footerDescription': footerDescription,
        'contactAddress': contactAddress,
        'contactPhone': contactPhone,
        'contactEmail': contactEmail,
        'aboutStoryHeadline': aboutStoryHeadline,
        'aboutStoryText': aboutStoryText,
        'aboutMissionText': aboutMissionText,
        'aboutVisionText': aboutVisionText,
        'aboutValuesText': aboutValuesText,
        'donateHeroTitle': donateHeroTitle,
        'donateHeroDescription': donateHeroDescription,
        'contactHeroTitle': contactHeroTitle,
        'contactHeroDescription': contactHeroDescription,
        'homeWhyTitle': homeWhyTitle,
        'homeWhyDescription': homeWhyDescription,
        'homeCtaTitle': homeCtaTitle,
        'homeCtaDescription': homeCtaDescription,
        'galleryHeroTitle': galleryHeroTitle,
        'galleryHeroDescription': galleryHeroDescription,
        'galleryImages': galleryImages.map((x) => x.toJson()).toList(),
      };

  factory AppContent.fromJson(Map<String, dynamic> json) => AppContent(
        appTitle: json['appTitle'],
        logoText: json['logoText'],
        logoPath: json['logoPath'],
        heroHeadline: json['heroHeadline'],
        heroSubheadline: json['heroSubheadline'],
        courses: List<Course>.from(json['courses'].map((x) => Course.fromJson(x))),
        features: List<Feature>.from(json['features'].map((x) => Feature.fromJson(x))),
        donationTiers: List<DonationTier>.from(json['donationTiers'].map((x) => DonationTier.fromJson(x))),
        teamMembers: List<TeamMember>.from(json['teamMembers'].map((x) => TeamMember.fromJson(x))),
        footerDescription: json['footerDescription'],
        contactAddress: json['contactAddress'],
        contactPhone: json['contactPhone'],
        contactEmail: json['contactEmail'],
        aboutStoryHeadline: json['aboutStoryHeadline'] ?? '',
        aboutStoryText: json['aboutStoryText'] ?? '',
        aboutMissionText: json['aboutMissionText'] ?? '',
        aboutVisionText: json['aboutVisionText'] ?? '',
        aboutValuesText: json['aboutValuesText'] ?? '',
        donateHeroTitle: json['donateHeroTitle'] ?? 'Invest in Dignity, Not Dependency.',
        donateHeroDescription: json['donateHeroDescription'] ?? 'Your contribution unlocks futures. Help empower youth in Kashmir to earn a livelihood and build self-reliant communities.',
        contactHeroTitle: json['contactHeroTitle'] ?? 'Get in Touch',
        contactHeroDescription: json['contactHeroDescription'] ?? 'Have questions? We are here to help you start your journey or discuss collaboration opportunities.',
        homeWhyTitle: json['homeWhyTitle'] ?? 'Why Hunarmand Kashmir?',
        homeWhyDescription: json['homeWhyDescription'] ?? 'We believe in "Skills over Degrees". In a rapidly changing world, we provide practical, hands-on training that the industry demands, right here in Mirpur.',
        homeCtaTitle: json['homeCtaTitle'] ?? 'Your Journey Begins Here',
        homeCtaDescription: json['homeCtaDescription'] ?? "Don't let lack of opportunity hold you back. Join Hunarmand Kashmir today and unlock a future of dignity, independence, and success.",
        galleryHeroTitle: json['galleryHeroTitle'] ?? 'Moments of Hope',
        galleryHeroDescription: json['galleryHeroDescription'] ?? 'Witness the journey of transformation. From Mirpur to Bhimber, empowering every corner of Kashmir.',
        galleryImages: json['galleryImages'] != null
            ? List<GalleryImage>.from(json['galleryImages'].map((x) => GalleryImage.fromJson(x)))
            : [],
      );
}
