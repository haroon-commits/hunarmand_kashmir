import 'package:flutter/material.dart'; // Importing Flutter material icons and types

/// Represents a single educational course offered by the platform.
class Course {
  // The name of the course
  final String title;
  // A brief summary of what the course covers
  final String description;
  // Visual icon representing the course category
  final IconData icon;
  // Expected timeframe to complete the course
  final String duration;
  // Cost of enrollment in the course
  final String fee;
  // Specific list of modules covered in this course
  final List<String> topics;

  // Immutable constructor for the Course model
  const Course({
    required this.title,
    required this.description,
    required this.icon,
    required this.duration,
    required this.fee,
    required this.topics,
  });
}

/// Represents a key selling point or feature of the Hunarmand platform.
class Feature {
  // Decorative icon for the feature
  final IconData icon;
  // Short headline for the feature
  final String title;
  // Detailed explanation of the platform's advantage
  final String description;

  // Immutable constructor for the Feature model
  const Feature({
    required this.icon,
    required this.title,
    required this.description,
  });
}

/// Represents a contribution level for supporting students.
class DonationTier {
  // Label for the donation level (e.g., 'Learning Kit')
  final String title;
  // Monetary value associated with this tier
  final String amount;
  // Explanation of how this donation impactfully helps a student
  final String description;
  // Icon symbolizing the type of support provided
  final IconData icon;
  // Flag to highlight this tier as a recommended choice in the UI
  final bool popular;

  // Immutable constructor for the DonationTier model
  const DonationTier({
    required this.title,
    required this.amount,
    required this.description,
    required this.icon,
    this.popular = false, // Defaults to false unless specified as popular
  });
}

/// Represents a member of the teaching or leadership team.
class TeamMember {
  // Full name of the team member
  final String name;
  // Their professional title or area of expertise
  final String role;
  // Profile placeholder icon
  final IconData emoji;

  // Immutable constructor for the TeamMember model
  const TeamMember({
    required this.name,
    required this.role,
    required this.emoji,
  });
}

/// A centralized static repository containing all the hardcoded data for the application.
/// This acts as a single source of truth for UI content across all screens.
class AppData {
  /// A list of available courses shown in the gallery and courses screens.
  static const List<Course> courses = [
    Course(
      title: 'AI Mastery', // Advanced technology focus
      description:
          'Practical AI skills for real income. Learn to use AI tools to build products and earn online.',
      icon: Icons.smart_toy_outlined, // Modern AI icon
      duration: '3 Months', // Standard term length
      fee: 'Rs. 8,000', // Pricing in local currency
      topics: [
        'ChatGPT & Prompt Engineering',
        'AI Image Generation',
        'AI for Business',
        'Freelancing with AI',
      ],
    ),
    Course(
      title: 'Graphic Design', // Creatively oriented course
      description:
          'Professional design skills. Master the tools used by top designers worldwide.',
      icon: Icons.palette_outlined, // Art palette icon
      duration: '3 Months',
      fee: 'Rs. 7,000',
      topics: [
        'Adobe Photoshop',
        'Adobe Illustrator',
        'Canva Pro',
        'Brand Identity Design',
      ],
    ),
    Course(
      title: 'E-Commerce', // Commercial & Business focus
      description:
          'Build and scale online stores. Learn to sell products globally from Kashmir.',
      icon: Icons.shopping_bag_outlined, // Shopping bag icon
      duration: '3 Months',
      fee: 'Rs. 6,000',
      topics: [
        'Shopify Store Setup',
        'Product Listing',
        'Digital Marketing',
        'Amazon FBA Basics',
      ],
    ),
    Course(
      title: 'Freelancing', // Career-centric short course
      description:
          'Work with global clients. Get your first international client within the first month.',
      icon: Icons.laptop_mac_outlined, // Laptop icon
      duration: '2 Months', // Shorter, intensive duration
      fee: 'Rs. 5,000',
      topics: [
        'Fiverr & Upwork Profile',
        'Proposal Writing',
        'Client Communication',
        'Payment Methods',
      ],
    ),
    Course(
      title: 'Social Media Marketing', // Marketing specialty
      description:
          'Digital growth strategies. Help businesses grow their online presence.',
      icon: Icons.campaign_outlined, // Megaphone icon
      duration: '3 Months',
      fee: 'Rs. 7,000',
      topics: [
        'Content Strategy',
        'Instagram & Facebook Ads',
        'TikTok Marketing',
        'Analytics & Reporting',
      ],
    ),
  ];

  /// Core value propositions of the Hunarmand initiative.
  static const List<Feature> features = [
    Feature(
      icon: Icons.connect_without_contact_outlined, // Community connection icon
      title: 'Expert Mentorship',
      description:
          'Learn from industry professionals who have worked globally.',
    ),
    Feature(
      icon: Icons.build_circle_outlined, // Tools/Construction icon
      title: 'Practical Learning',
      description:
          'No boring theory. Work on real projects that build your portfolio.',
    ),
    Feature(
      icon: Icons.rocket_launch_outlined, // Launch/Success icon
      title: 'Career Support',
      description:
          'From resume building to freelance gigs, we guide your career path.',
    ),
  ];

  /// Specific levels of financial support available for donors.
  static const List<DonationTier> donationTiers = [
    DonationTier(
      title: 'Learning Kit',
      amount: 'Rs. 2,000', // Entry-level support
      description:
          'Provide a student with essential learning materials, internet access for a month, and software subscriptions.',
      icon: Icons.backpack_outlined, // Education materials icon
      popular: false, // Standard tier
    ),
    DonationTier(
      title: 'Sponsor a Skill',
      amount: 'Rs. 5,000', // Mid-range impactful support
      description:
          'Cover the cost of a complete short-term module for one deserving student.',
      icon: Icons.menu_book_outlined, // Course book icon
      popular: true, // Recommended "golden" tier in UI
    ),
    DonationTier(
      title: 'Full Scholarship',
      amount: 'Rs. 15,000', // Maximum impact tier
      description:
          'Sponsor a student\'s full journey from beginner to job-ready professional.',
      icon: Icons.school_outlined, // Graduation icon
      popular: false, // Premium tier
    ),
  ];

  /// List of human faces behind the project displayed on the About page.
  static const List<TeamMember> teamMembers = [
    TeamMember(
      name: 'Ahmad Raza',
      role: 'Founder & Lead Mentor',
      emoji: Icons.person_outline, // Leadership icon
    ),
    TeamMember(
      name: 'Sana Mir',
      role: 'Graphic Design Trainer',
      emoji: Icons.brush_outlined, // Design-focused icon
    ),
    TeamMember(
      name: 'Bilal Khan',
      role: 'AI & Freelancing Mentor',
      emoji: Icons.computer_outlined, // Tech-focused icon
    ),
  ];
}
