// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Removes the HTML loading indicator once the Flutter app is ready.
void hideWebLoader() {
  final loader = html.document.getElementById('loading-indicator');
  if (loader != null) {
    loader.remove();
  }
}
