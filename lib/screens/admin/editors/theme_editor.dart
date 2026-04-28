import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/content_model.dart';
import '../../../providers/dynamic_content_provider.dart';

class ThemeEditor extends StatefulWidget {
  const ThemeEditor({super.key});

  @override
  State<ThemeEditor> createState() => _ThemeEditorState();
}

class _ThemeEditorState extends State<ThemeEditor> {
  late String _primaryColorHex;
  late String _accentColorHex;
  late String _backgroundColorHex;
  late String _cardBackgroundColorHex;
  late String _textDarkHex;
  late String _textLightHex;
  late double _cardBorderRadius;
  late double _buttonBorderRadius;

  late bool _showHomeCourses;
  late bool _showHomeFeatures;
  late bool _showHomeWhyUs;
  late bool _showHomeCta;
  late bool _showAboutTeam;
  late bool _showIconsInCards;
  late bool _showHomeStats;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final theme = context.read<DynamicContentProvider>().content.themeConfig;
    _primaryColorHex = theme.primaryColorHex;
    _accentColorHex = theme.accentColorHex;
    _backgroundColorHex = theme.backgroundColorHex;
    _cardBackgroundColorHex = theme.cardBackgroundColorHex;
    _textDarkHex = theme.textDarkHex;
    _textLightHex = theme.textLightHex;
    _cardBorderRadius = theme.cardBorderRadius;
    _buttonBorderRadius = theme.buttonBorderRadius;

    final layout = context.read<DynamicContentProvider>().content.layoutConfig;
    _showHomeCourses = layout.showHomeCourses;
    _showHomeFeatures = layout.showHomeFeatures;
    _showHomeWhyUs = layout.showHomeWhyUs;
    _showHomeCta = layout.showHomeCta;
    _showAboutTeam = layout.showAboutTeam;
    _showIconsInCards = layout.showIconsInCards;
    _showHomeStats = layout.showHomeStats;
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2, 8).toUpperCase()}';
  }

  void _saveTheme() async {
    setState(() => _isSaving = true);
    
    final newTheme = ThemeConfig(
      primaryColorHex: _primaryColorHex,
      accentColorHex: _accentColorHex,
      backgroundColorHex: _backgroundColorHex,
      cardBackgroundColorHex: _cardBackgroundColorHex,
      textDarkHex: _textDarkHex,
      textLightHex: _textLightHex,
      cardBorderRadius: _cardBorderRadius,
      buttonBorderRadius: _buttonBorderRadius,
    );

    final newLayout = LayoutConfig(
      showHomeCourses: _showHomeCourses,
      showHomeFeatures: _showHomeFeatures,
      showHomeWhyUs: _showHomeWhyUs,
      showHomeCta: _showHomeCta,
      showHomeStats: _showHomeStats,
      showAboutTeam: _showAboutTeam,
      showIconsInCards: _showIconsInCards,
    );

    context.read<DynamicContentProvider>().updateTheme(newTheme);
    context.read<DynamicContentProvider>().updateLayout(newLayout);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Theme settings saved successfully!')),
      );
    }
    setState(() => _isSaving = false);
  }

  void _showColorPicker(String title, Color initialColor, ValueChanged<Color> onColorChanged) {
    Color tempColor = initialColor;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: initialColor,
              onColorChanged: (c) => tempColor = c,
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
              displayThumbColor: true,
              paletteType: PaletteType.hsv,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onColorChanged(tempColor);
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildColorTile(String title, String subtitle, String currentHex, ValueChanged<String> onChanged) {
    return ListTile(
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: GoogleFonts.inter(color: Colors.grey.shade600)),
      trailing: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _hexToColor(currentHex),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
      ),
      onTap: () {
        _showColorPicker(title, _hexToColor(currentHex), (color) {
          onChanged(_colorToHex(color));
        });
      },
    );
  }

  Widget _buildSliderTile(String title, String subtitle, double value, double min, double max, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16)),
          Text(subtitle, style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13)),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: (max - min).toInt(),
                  label: value.round().toString(),
                  onChanged: onChanged,
                ),
              ),
              Text('${value.round()}px', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: GoogleFonts.inter(color: Colors.grey.shade600)),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFFF5A623),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Theme & Layout CMS',
              style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveTheme,
              icon: _isSaving
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save),
              label: Text(_isSaving ? 'Saving...' : 'Save Theme'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D3320),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Global Colors', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(height: 32),
                _buildColorTile('Primary Brand Color', 'Used for headers, footers, and main accents.', _primaryColorHex, (v) => setState(() => _primaryColorHex = v)),
                _buildColorTile('Accent Color (Gold)', 'Used for prominent buttons and highlights.', _accentColorHex, (v) => setState(() => _accentColorHex = v)),
                _buildColorTile('App Background Color', 'The main background behind sections.', _backgroundColorHex, (v) => setState(() => _backgroundColorHex = v)),
                _buildColorTile('Card Background Color', 'Background for all UI cards (Courses, Gallery, etc).', _cardBackgroundColorHex, (v) => setState(() => _cardBackgroundColorHex = v)),
                _buildColorTile('Dark Text Color', 'Main reading text color.', _textDarkHex, (v) => setState(() => _textDarkHex = v)),
                _buildColorTile('Light Text Color', 'Text on dark backgrounds.', _textLightHex, (v) => setState(() => _textLightHex = v)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Component Styling', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(height: 32),
                _buildSliderTile('Card Corner Radius', 'How rounded the corners of content cards should be.', _cardBorderRadius, 0, 40, (v) => setState(() => _cardBorderRadius = v)),
                _buildSliderTile('Button Corner Radius', 'How rounded the corners of buttons should be.', _buttonBorderRadius, 0, 40, (v) => setState(() => _buttonBorderRadius = v)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Layout Visibility & Toggles', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(height: 32),
                _buildSwitchTile('Show Courses Section', 'Toggle the main courses grid on the home page.', _showHomeCourses, (v) => setState(() => _showHomeCourses = v)),
                _buildSwitchTile('Show Features Section', 'Toggle the features/highlights section on the home page.', _showHomeFeatures, (v) => setState(() => _showHomeFeatures = v)),
                _buildSwitchTile('Show "Why Us" Section', 'Toggle the text explanation block on the home page.', _showHomeWhyUs, (v) => setState(() => _showHomeWhyUs = v)),
                _buildSwitchTile('Show Call to Action', 'Toggle the large green action banner on the home page.', _showHomeCta, (v) => setState(() => _showHomeCta = v)),
                _buildSwitchTile('Show Platform Stats', 'Toggle the numerical impact statistics on the home page.', _showHomeStats, (v) => setState(() => _showHomeStats = v)),
                _buildSwitchTile('Show Team Section', 'Toggle the leadership/mentors grid on the About page.', _showAboutTeam, (v) => setState(() => _showAboutTeam = v)),
                _buildSwitchTile('Show Icons in Cards', 'Display the emoji icons inside course and feature cards.', _showIconsInCards, (v) => setState(() => _showIconsInCards = v)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
