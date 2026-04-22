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
  // Checking if the icon string is a web URL by looking for the 'http' prefix
  bool isUrl = icon.startsWith('http');

  // Branch 1: The icon is a network image URL
  if (isUrl) {
    return ClipRRect(
      // If circle mode is requested, use a very large radius (100) to make it circular.
      // Otherwise, use a subtle 8px radius for rounded corners.
      borderRadius: BorderRadius.circular(circle ? 100 : 8),
      // Loading the image from the network at the specified dimensions
      child: Image.network(
        icon, // The URL string passed in as the icon parameter
        width: size, // Setting the image width to match the requested size
        height: size, // Setting the image height to match the requested size
        fit: BoxFit.cover, // Scaling the image to fill the box, cropping if needed
        // Error handler: if the network image fails to load (broken URL, no internet),
        // display a broken image icon instead with the optional tint color
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.broken_image, color: color, size: size * 0.8),
      ),
    );
  }
  // Branch 2: The icon is an emoji or text character (e.g., '🤖', '🎨', '👨‍🏫')
  else {
    return Text(
      icon, // Rendering the emoji string directly as text
      style: TextStyle(fontSize: size), // Scaling the emoji to the requested size
    );
  }
}
