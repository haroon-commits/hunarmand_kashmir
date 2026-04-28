/// ═══════════════════════════════════════════════════════════════════════
/// FILE: dynamic_icon.dart
/// PURPOSE: A utility function that decides how to render an icon string.
///          If the string is a URL (starts with 'http'), it loads a network
///          image. Otherwise, it renders the string as an emoji/text character.
/// CONNECTIONS:
///   - USED BY: widgets/cards/feature_card.dart → renders Feature.icon
///   - USED BY: widgets/cards/course_card.dart → renders Course.icon
///   - USED BY: widgets/cards/donation_tier_card.dart → renders DonationTier.icon
///   - DATA SOURCE: icon strings come from models/content_model.dart
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart'; // Flutter core for Widget, ClipRRect, Image, Text, Icon, etc.

/// A utility function to render icons that can either be a remote image URL
/// or a localized character/emoji string.
///
/// PARAMETERS:
///   - [icon]: The string to render. Can be 'http://...' for network images or '🤖' for emoji.
///   - [color]: Optional tint color applied to fallback error icons (not used for emoji).
///   - [size]: Controls both the image dimensions and the emoji font size.
///   - [circle]: When true AND the icon is a URL, clips the image into a circle shape.
///
/// RETURNS: A Widget (either Image.network or Text) ready to be placed in the widget tree.
Widget renderDynamicIcon(String icon, {Color? color, double size = 24, bool circle = false}) {
  // Branch 1: The icon is a network image URL
  if (icon.startsWith('http')) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(circle ? 100 : 8),
      child: Image.network(
        icon,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.broken_image, color: color, size: size * 0.8),
      ),
    );
  }
  
  // Branch 2: The icon is a Material Icon (e.g., 'material:school')
  if (icon.startsWith('material:')) {
    final iconName = icon.replaceFirst('material:', '').trim();
    return Icon(
      _getMaterialIcon(iconName),
      color: color,
      size: size,
    );
  }

  // Branch 3: The icon is an emoji or text character (e.g., '🤖', '🎨', '👨‍🏫')
  return Text(
    icon,
    style: TextStyle(fontSize: size),
  );
}

/// Helper map to resolve string names to Material Icons.
IconData _getMaterialIcon(String name) {
  switch (name) {
    case 'school': return Icons.school_outlined;
    case 'business': return Icons.business_outlined;
    case 'laptop': return Icons.laptop_outlined;
    case 'work': return Icons.work_outline;
    case 'star': return Icons.star_border;
    case 'group': return Icons.group_outlined;
    case 'email': return Icons.email_outlined;
    case 'phone': return Icons.phone_outlined;
    case 'location': return Icons.location_on_outlined;
    case 'favorite': return Icons.favorite_border;
    case 'verified': return Icons.verified_user_outlined;
    case 'rocket': return Icons.rocket_launch_outlined;
    case 'support': return Icons.support_agent_outlined;
    case 'code': return Icons.code_outlined;
    case 'palette': return Icons.palette_outlined;
    case 'shopping': return Icons.shopping_bag_outlined;
    case 'campaign': return Icons.campaign_outlined;
    case 'security': return Icons.security_outlined;
    case 'trending': return Icons.trending_up_outlined;
    case 'book': return Icons.book_outlined;
    case 'design': return Icons.design_services_outlined;
    case 'web': return Icons.language_outlined;
    case 'store': return Icons.store_outlined;
    case 'marketing': return Icons.ads_click_outlined;
    case 'payments': return Icons.payments_outlined;
    case 'volunteer': return Icons.volunteer_activism_outlined;
    case 'diversity': return Icons.diversity_3_outlined;
    case 'psychology': return Icons.psychology_outlined;
    case 'history': return Icons.history_edu_outlined;
    case 'wallet': return Icons.account_balance_wallet_outlined;
    case 'public': return Icons.public_outlined;
    case 'handshake': return Icons.handshake_outlined;
    case 'lightbulb': return Icons.lightbulb_outline;
    case 'assignment': return Icons.assignment_outlined;
    default: return Icons.help_outline; // Fallback icon
  }
}
