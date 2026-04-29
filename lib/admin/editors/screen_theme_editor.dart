import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/content_model.dart';
import '../../providers/dynamic_content_provider.dart';
import '../../utils/responsive.dart';

class ScreenThemeEditor extends StatefulWidget {
  const ScreenThemeEditor({super.key});

  @override
  State<ScreenThemeEditor> createState() => _ScreenThemeEditorState();
}

class _ScreenThemeEditorState extends State<ScreenThemeEditor> {
  String _selectedScreen = 'Home';
  final List<String> _screens = ['Home', 'About', 'Courses', 'Gallery', 'Contact', 'Donate'];

  // Map of screen names to their sections
  final Map<String, List<Map<String, String>>> _screenSections = {
    'Home': [
      {'id': 'home_hero', 'label': 'Hero Section'},
      {'id': 'home_features', 'label': 'Features Section'},
      {'id': 'home_why', 'label': 'Why Us Section'},
      {'id': 'home_cta', 'label': 'Call to Action'},
    ],
    'About': [
      {'id': 'about_hero', 'label': 'Hero Header'},
      {'id': 'about_story', 'label': 'Our Story Section'},
      {'id': 'about_team', 'label': 'Leadership Team'},
    ],
    'Courses': [
      {'id': 'courses_hero', 'label': 'Hero Header'},
      {'id': 'courses_list', 'label': 'Courses Grid'},
      {'id': 'courses_discounts', 'label': 'Discounts Section'},
    ],
    'Donate': [
      {'id': 'donate_hero', 'label': 'Hero Header'},
      {'id': 'donate_impact', 'label': 'Impact Section'},
      {'id': 'donate_tiers', 'label': 'Donation Tiers'},
    ],
    'Gallery': [
      {'id': 'gallery_hero', 'label': 'Hero Header'},
      {'id': 'gallery_grid', 'label': 'Gallery Grid'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<DynamicContentProvider>(
      builder: (context, provider, _) {
        // Global screen settings
        ScreenSettings screenSettings;
        Function(ScreenSettings) updateScreenFn;

        switch (_selectedScreen) {
          case 'About':
            screenSettings = provider.content.aboutSettings;
            updateScreenFn = provider.updateAboutTheme;
            break;
          case 'Courses':
            screenSettings = provider.content.coursesSettings;
            updateScreenFn = provider.updateCoursesTheme;
            break;
          case 'Gallery':
            screenSettings = provider.content.gallerySettings;
            updateScreenFn = provider.updateGalleryTheme;
            break;
          case 'Contact':
            screenSettings = provider.content.contactSettings;
            updateScreenFn = provider.updateContactTheme;
            break;
          case 'Donate':
            screenSettings = provider.content.donateSettings;
            updateScreenFn = provider.updateDonateTheme;
            break;
          default:
            screenSettings = provider.content.homeSettings;
            updateScreenFn = provider.updateHomeTheme;
        }

        final sections = _screenSections[_selectedScreen] ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Granular Section Styling',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0D3320),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Customize every section and heading specifically on this page.',
                style: GoogleFonts.inter(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              // Screen Selector
              _buildDropdownSelector(
                label: 'Select Screen to Style',
                value: _selectedScreen,
                items: _screens,
                onChanged: (val) => setState(() => _selectedScreen = val!),
              ),
              const SizedBox(height: 32),

              _buildSectionTitle('General Page Atmosphere'),
              _buildSettingsCard(
                settings: screenSettings,
                onUpdate: updateScreenFn,
                showBg: true,
              ),

              if (sections.isNotEmpty) ...[
                const SizedBox(height: 48),
                _buildSectionTitle('Section-Specific Controls'),
                const SizedBox(height: 8),
                ...sections.map((section) {
                  final sectionId = section['id']!;
                  final sectionLabel = section['label']!;
                  final sectionStyle = provider.content.sectionStyles[sectionId] ??
                      ScreenSettings(
                        backgroundColorHex: '#FAFAFA',
                        titleColorHex: '#1A1A1A',
                        bodyColorHex: '#555555',
                        buttonColorHex: '#0D3320',
                        buttonTextColorHex: '#FFFFFF',
                        titleFontSize: 32.0,
                        bodyFontSize: 16.0,
                        subtitleFontSize: 18.0,
                        fontFamily: 'Inter',
                      );

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: ExpansionTile(
                      title: Text(sectionLabel,
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Text('Edit heading and body styles for this section',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                      childrenPadding: const EdgeInsets.all(16),
                      backgroundColor: Colors.white,
                      collapsedBackgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200)),
                      collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200)),
                      children: [
                        _buildSettingsCard(
                          settings: sectionStyle,
                          onUpdate: (newSet) => provider.updateSectionStyle(sectionId, newSet),
                          showBg: true,
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdownSelector({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items.map((s) => DropdownMenuItem(value: s, child: Text('$s Screen Styles'))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard({
    required ScreenSettings settings,
    required Function(ScreenSettings) onUpdate,
    bool showBg = false,
  }) {
    return Column(
      children: [
        if (showBg)
          _buildColorTile('Background Color', settings.backgroundColorHex, (val) {
            onUpdate(_copySettings(settings, backgroundColorHex: val));
          }),
        _buildColorTile('Heading Text Color', settings.titleColorHex, (val) {
          onUpdate(_copySettings(settings, titleColorHex: val));
        }),
        _buildColorTile('Body Text Color', settings.bodyColorHex, (val) {
          onUpdate(_copySettings(settings, bodyColorHex: val));
        }),
        const Divider(height: 32),
        _buildFontSelector('Section Font Family', settings.fontFamily, (val) {
          onUpdate(_copySettings(settings, fontFamily: val));
        }),
        _buildSliderTile('Heading Font Size', settings.titleFontSize, 12, 120, (val) {
          onUpdate(_copySettings(settings, titleFontSize: val));
        }),
        _buildSliderTile('Body Font Size', settings.bodyFontSize, 8, 60, (val) {
          onUpdate(_copySettings(settings, bodyFontSize: val));
        }),
        _buildSliderTile('Supporting Text Size', settings.subtitleFontSize, 10, 60, (val) {
          onUpdate(_copySettings(settings, subtitleFontSize: val));
        }),
      ],
    );
  }

  ScreenSettings _copySettings(ScreenSettings s, {
    String? backgroundColorHex,
    String? titleColorHex,
    String? bodyColorHex,
    String? buttonColorHex,
    String? buttonTextColorHex,
    double? titleFontSize,
    double? bodyFontSize,
    double? subtitleFontSize,
    String? fontFamily,
  }) {
    return ScreenSettings(
      backgroundColorHex: backgroundColorHex ?? s.backgroundColorHex,
      titleColorHex: titleColorHex ?? s.titleColorHex,
      bodyColorHex: bodyColorHex ?? s.bodyColorHex,
      buttonColorHex: buttonColorHex ?? s.buttonColorHex,
      buttonTextColorHex: buttonTextColorHex ?? s.buttonTextColorHex,
      titleFontSize: titleFontSize ?? s.titleFontSize,
      bodyFontSize: bodyFontSize ?? s.bodyFontSize,
      subtitleFontSize: subtitleFontSize ?? s.subtitleFontSize,
      fontFamily: fontFamily ?? s.fontFamily,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: Colors.grey[500],
        ),
      ),
    );
  }

  Widget _buildColorTile(String label, String hex, Function(String) onChanged) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: GoogleFonts.inter(fontSize: 14)),
      subtitle: Text(hex, style: GoogleFonts.robotoMono(fontSize: 12, color: Colors.blue)),
      trailing: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: _hexToColor(hex),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
      ),
      onTap: () async {
        final controller = TextEditingController(text: hex);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Edit $label'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: '#RRGGBB'),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  onChanged(controller.text);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliderTile(String label, double value, double min, double max, Function(double) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 14)),
              Text('${value.toInt()}px', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF0D3320))),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            activeColor: const Color(0xFFF5A623),
            inactiveColor: Colors.grey.shade200,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildFontSelector(String label, String currentFont, Function(String) onChanged) {
    final fonts = ['Inter', 'Playfair Display', 'Roboto', 'Outfit', 'Montserrat', 'Poppins'];
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: GoogleFonts.inter(fontSize: 14)),
      trailing: DropdownButton<String>(
        value: fonts.contains(currentFont) ? currentFont : 'Inter',
        items: fonts.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
        onChanged: (val) => onChanged(val!),
      ),
    );
  }

  Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
