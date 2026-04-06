import 'package:flutter/material.dart';

// ----------------------- Models -----------------------

class Course {
  final String title;
  final String description;
  final IconData icon;
  final String duration;
  final String fee;
  final List<String> topics;

  const Course({
    required this.title,
    required this.description,
    required this.icon,
    required this.duration,
    required this.fee,
    required this.topics,
  });
}

class Feature {
  final IconData icon;
  final String title;
  final String description;

  const Feature({
    required this.icon,
    required this.title,
    required this.description,
  });

  void operator [](String other) {}
}

class DonationTier {
  final String title;
  final String amount;
  final String description;
  final IconData icon;
  final bool popular;

  const DonationTier({
    required this.title,
    required this.amount,
    required this.description,
    required this.icon,
    required this.popular,
  });
}

class TeamMember {
  final String name;
  final String role;
  final IconData emoji;

  const TeamMember({
    required this.name,
    required this.role,
    required this.emoji,
  });
}

// ----------------------- Data -----------------------

class AppData {
  static const List<Course> courses = [
    Course(
      title: 'AI Mastery',
      description:
          'Practical AI skills for real income. Learn to use AI tools to build products and earn online.',
      icon: Icons.smart_toy_outlined,
      duration: '3 Months',
      fee: 'Rs. 8,000',
      topics: [
        'ChatGPT & Prompt Engineering',
        'AI Image Generation',
        'AI for Business',
        'Freelancing with AI',
      ],
    ),
    Course(
      title: 'Graphic Design',
      description:
          'Professional design skills. Master the tools used by top designers worldwide.',
      icon: Icons.palette_outlined,
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
      title: 'E-Commerce',
      description:
          'Build and scale online stores. Learn to sell products globally from Kashmir.',
      icon: Icons.shopping_bag_outlined,
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
      title: 'Freelancing',
      description:
          'Work with global clients. Get your first international client within the first month.',
      icon: Icons.laptop_mac_outlined,
      duration: '2 Months',
      fee: 'Rs. 5,000',
      topics: [
        'Fiverr & Upwork Profile',
        'Proposal Writing',
        'Client Communication',
        'Payment Methods',
      ],
    ),
    Course(
      title: 'Social Media Marketing',
      description:
          'Digital growth strategies. Help businesses grow their online presence.',
      icon: Icons.campaign_outlined,
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

  static const List<Feature> features = [
    Feature(
      icon: Icons.connect_without_contact_outlined,
      title: 'Expert Mentorship',
      description:
          'Learn from industry professionals who have worked globally.',
    ),
    Feature(
      icon: Icons.build_circle_outlined,
      title: 'Practical Learning',
      description:
          'No boring theory. Work on real projects that build your portfolio.',
    ),
    Feature(
      icon: Icons.rocket_launch_outlined,
      title: 'Career Support',
      description:
          'From resume building to freelance gigs, we guide your career path.',
    ),
  ];

  static const List<DonationTier> donationTiers = [
    DonationTier(
      title: 'Learning Kit',
      amount: 'Rs. 2,000',
      description:
          'Provide a student with essential learning materials, internet access for a month, and software subscriptions.',
      icon: Icons.backpack_outlined,
      popular: false,
    ),
    DonationTier(
      title: 'Sponsor a Skill',
      amount: 'Rs. 5,000',
      description:
          'Cover the cost of a complete short-term module (e.g., Graphic Design Basics) for one deserving student.',
      icon: Icons.menu_book_outlined,
      popular: true,
    ),
    DonationTier(
      title: 'Full Scholarship',
      amount: 'Rs. 15,000',
      description:
          'Sponsor a student\'s entire journey from beginner to job-ready professional, including mentorship.',
      icon: Icons.school_outlined,
      popular: false,
    ),
  ];

  static const List<TeamMember> teamMembers = [
    TeamMember(
      name: 'Ahmad Raza',
      role: 'Founder & Lead Mentor',
      emoji: Icons.person_outline,
    ),
    TeamMember(
      name: 'Sana Mir',
      role: 'Graphic Design Trainer',
      emoji: Icons.brush_outlined,
    ),
    TeamMember(
      name: 'Bilal Khan',
      role: 'AI & Freelancing Mentor',
      emoji: Icons.computer_outlined,
    ),
  ];
}
