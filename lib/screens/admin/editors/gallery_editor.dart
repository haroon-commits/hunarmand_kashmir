/// ═══════════════════════════════════════════════════════════════════════
/// FILE: gallery_editor.dart
/// PURPOSE: Admin interface for managing visual assets. Allows addition, 
///          labeling, and removal of images from the public gallery.
/// CONNECTIONS:
///   - USED BY: admin_dashboard_screen.dart
///   - MUTATES: AppContent via dynamic_content_provider.dart
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/dynamic_content_provider.dart';
import '../../../models/content_model.dart';


// ─── GALLERYEDITORUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to gallery_editor.dart.
class GalleryEditorUIConfig {
  // Brand Colors used locally
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color lightGrey = Color(0xFFF2F2F2);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF555555);

}


class GalleryEditor extends StatefulWidget {
  const GalleryEditor({super.key});

  @override
  State<GalleryEditor> createState() => _GalleryEditorState();
}

class _GalleryEditorState extends State<GalleryEditor> {
  final _heroTitleController = TextEditingController();
  final _heroDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final content = context.read<DynamicContentProvider>().content;
    _heroTitleController.text = content.galleryHeroTitle;
    _heroDescController.text = content.galleryHeroDescription;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gallery Screen Editor',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: GalleryEditorUIConfig.textDark,
            ),
          ),
          const SizedBox(height: 24),
          _buildSection('Hero Section', [
            _buildTextField('Hero Title', _heroTitleController),
            const SizedBox(height: 16),
            _buildTextField('Hero Description', _heroDescController, maxLines: 4),
          ]),
          const SizedBox(height: 24),
          _buildSection('Gallery Management', [
            _buildGalleryOrganizer(context),
          ]),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              context.read<DynamicContentProvider>().updateGalleryHero(
                    _heroTitleController.text,
                    _heroDescController.text,
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gallery updated!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GalleryEditorUIConfig.darkGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            child: const Text('Save Gallery Hero'),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryOrganizer(BuildContext context) {
    final provider = context.watch<DynamicContentProvider>();
    final images = provider.content.galleryImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gallery Images',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: GalleryEditorUIConfig.textDark,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showImageDialog(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Image'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (images.isEmpty)
          const Text('No images in gallery yet.')
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final img = images[index];
              return Stack(
                children: [
                   Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        img.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          color: GalleryEditorUIConfig.lightGrey,
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _circleAction(Icons.edit, () => _showImageDialog(context, image: img, index: index)),
                        const SizedBox(width: 4),
                        _circleAction(Icons.delete, () {
                          final updated = List<GalleryImage>.from(images)..removeAt(index);
                          provider.updateGalleryImages(updated);
                        }, color: Colors.red),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                      ),
                      child: Text(
                        img.label,
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }

  Widget _circleAction(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 14, color: color ?? GalleryEditorUIConfig.darkGreen),
      ),
    );
  }

  void _showImageDialog(BuildContext context, {GalleryImage? image, int? index}) {
    final urlController = TextEditingController(text: image?.imageUrl ?? '');
    final labelController = TextEditingController(text: image?.label ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(image == null ? 'Add Image' : 'Edit Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: labelController,
              decoration: const InputDecoration(labelText: 'Label/Description'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final provider = context.read<DynamicContentProvider>();
              final newImg = GalleryImage(
                imageUrl: urlController.text,
                label: labelController.text,
              );
              final updated = List<GalleryImage>.from(provider.content.galleryImages);
              if (index == null) {
                updated.add(newImg);
              } else {
                updated[index] = newImg;
              }
              provider.updateGalleryImages(updated);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: GalleryEditorUIConfig.darkGreen,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: GalleryEditorUIConfig.textMedium,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
