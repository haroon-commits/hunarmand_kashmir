/// ═══════════════════════════════════════════════════════════════════════
/// FILE: gallery_editor.dart
/// PURPOSE: Admin interface for managing visual assets. Allows addition,
///          labeling, and removal of images from the public gallery.
///          Responsive grid adapts column count based on available width.
/// CONNECTIONS:
///   - USED BY: admin_dashboard_screen.dart
///   - MUTATES: AppContent via dynamic_content_provider.dart
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/dynamic_content_provider.dart';
import '../../models/content_model.dart';

// ─── GALLERYEDITORUICONFIG ──────────────────────────────
class GalleryEditorUIConfig {
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color accentGold = Color(0xFFF5A623);
  static const Color lightGrey = Color(0xFFF2F2F2);
  static const Color lightTeal = Color(0xFFE8F5F3);
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
  void dispose() {
    _heroTitleController.dispose();
    _heroDescController.dispose();
    super.dispose();
  }

  // ─── Resolves responsive column count from available width ───────────
  int _columnCount(double width) {
    if (width >= 1100) return 5;
    if (width >= 860) return 4;
    if (width >= 580) return 3;
    return 2;
  }

  // ─── Shows snackbar with result message ──────────────────────────────
  void _snack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor:
          error ? Colors.red.shade700 : GalleryEditorUIConfig.darkGreen,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Page heading ──────────────────────────────────────────────
          Text(
            'Gallery Screen Editor',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: GalleryEditorUIConfig.textDark,
            ),
          ),
          const SizedBox(height: 24),

          // ── Hero section ──────────────────────────────────────────────
          _buildSection('Hero Section', [
            _buildTextField('Hero Title', _heroTitleController),
            const SizedBox(height: 16),
            _buildTextField('Hero Description', _heroDescController,
                maxLines: 3),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await context
                      .read<DynamicContentProvider>()
                      .updateGalleryHero(
                        _heroTitleController.text,
                        _heroDescController.text,
                      );
                  _snack('✅ Hero section saved!');
                } catch (e) {
                  _snack('❌ Save failed: $e', error: true);
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Hero'),
              style: ElevatedButton.styleFrom(
                backgroundColor: GalleryEditorUIConfig.darkGreen,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
            ),
          ]),

          const SizedBox(height: 24),

          // ── Gallery grid ──────────────────────────────────────────────
          _buildSection('Gallery Images', [
            _buildGalleryOrganizer(),
          ]),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ─── Gallery grid organizer ───────────────────────────────────────────
  Widget _buildGalleryOrganizer() {
    final provider = context.watch<DynamicContentProvider>();
    final images = provider.content.galleryImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row: count badge + Add button
        Row(
          children: [
            Text(
              'Images',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: GalleryEditorUIConfig.textDark,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: GalleryEditorUIConfig.lightTeal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${images.length}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: GalleryEditorUIConfig.darkGreen,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => _showImageDialog(context),
              icon: const Icon(Icons.add_photo_alternate, size: 18),
              label: const Text('Add Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: GalleryEditorUIConfig.accentGold,
                foregroundColor: GalleryEditorUIConfig.darkGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Empty state
        if (images.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: GalleryEditorUIConfig.lightGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Colors.grey.shade300, style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                Icon(Icons.photo_library_outlined,
                    size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(
                  'No images yet. Add your first image above.',
                  style: GoogleFonts.inter(
                      color: GalleryEditorUIConfig.textMedium, fontSize: 14),
                ),
              ],
            ),
          )
        else
          // Responsive grid using LayoutBuilder
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = _columnCount(constraints.maxWidth);
              const spacing = 12.0;
              final itemW =
                  (constraints.maxWidth - spacing * (cols - 1)) / cols;
              // 16:10 aspect → height = width * 0.625
              final itemH = itemW * 0.625;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: images.asMap().entries.map((entry) {
                  final index = entry.key;
                  final img = entry.value;
                  return SizedBox(
                    width: itemW,
                    height: itemH,
                    child:
                        _buildImageCard(context, img, index, images, provider),
                  );
                }).toList(),
              );
            },
          ),
      ],
    );
  }

  // ─── Single image card with overlay actions ───────────────────────────
  Widget _buildImageCard(
    BuildContext context,
    GalleryImage img,
    int index,
    List<GalleryImage> images,
    DynamicContentProvider provider,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            img.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              color: GalleryEditorUIConfig.lightGrey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image,
                      color: Colors.grey.shade400, size: 32),
                  const SizedBox(height: 6),
                  Text('Invalid URL',
                      style: GoogleFonts.inter(
                          fontSize: 10, color: Colors.grey.shade500)),
                ],
              ),
            ),
            loadingBuilder: (c, child, progress) => progress == null
                ? child
                : Container(
                    color: GalleryEditorUIConfig.lightGrey,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
          ),
        ),

        // Dark gradient overlay at bottom for label
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(10)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      img.label.isEmpty ? '(no label)' : img.label,
                      style: GoogleFonts.inter(
                        color:
                            img.label.isEmpty ? Colors.white38 : Colors.white,
                        fontSize: 10,
                        fontStyle: img.label.isEmpty
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Index badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '#${index + 1}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Action buttons top-right
        Positioned(
          top: 6,
          right: 6,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit
              _actionButton(
                icon: Icons.edit,
                color: Colors.white,
                bgColor: GalleryEditorUIConfig.darkGreen,
                tooltip: 'Edit',
                onTap: () =>
                    _showImageDialog(context, image: img, index: index),
              ),
              const SizedBox(width: 5),
              // Delete
              _actionButton(
                icon: Icons.delete,
                color: Colors.white,
                bgColor: Colors.red.shade600,
                tooltip: 'Delete',
                onTap: () => _confirmDelete(context, index, images, provider),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Circular action button ───────────────────────────────────────────
  Widget _actionButton({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Icon(icon, size: 14, color: color),
        ),
      ),
    );
  }

  // ─── Delete confirm dialog ────────────────────────────────────────────
  void _confirmDelete(
    BuildContext context,
    int index,
    List<GalleryImage> images,
    DynamicContentProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Image?'),
        content: Text(
          'Remove "${images[index].label.isEmpty ? "Image #${index + 1}" : images[index].label}" from the gallery?\n\nThis cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                final updated = List<GalleryImage>.from(images)
                  ..removeAt(index);
                await provider.updateGalleryImages(updated);
                _snack('🗑️ Image deleted.');
              } catch (e) {
                _snack('❌ Delete failed: $e', error: true);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ─── Add / Edit image dialog ──────────────────────────────────────────
  void _showImageDialog(BuildContext context,
      {GalleryImage? image, int? index}) {
    final urlController = TextEditingController(text: image?.imageUrl ?? '');
    final labelController = TextEditingController(text: image?.label ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(image == null ? 'Add Image' : 'Edit Image'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'https://example.com/photo.jpg',
                  prefixIcon: Icon(Icons.link),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: labelController,
                decoration: const InputDecoration(
                  labelText: 'Label / Caption',
                  hintText: 'e.g. Web Development Lab',
                  prefixIcon: Icon(Icons.label_outline),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: GalleryEditorUIConfig.darkGreen,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (urlController.text.trim().isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Image URL cannot be empty.')),
                );
                return;
              }
              final provider = context.read<DynamicContentProvider>();
              final newImg = GalleryImage(
                imageUrl: urlController.text.trim(),
                label: labelController.text.trim(),
              );
              final updated =
                  List<GalleryImage>.from(provider.content.galleryImages);
              if (index == null) {
                updated.add(newImg);
              } else {
                updated[index] = newImg;
              }
              try {
                await provider.updateGalleryImages(updated);
                if (ctx.mounted) Navigator.pop(ctx);
                _snack(index == null ? '✅ Image added!' : '✅ Image updated!');
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text('❌ Save failed: $e'),
                      backgroundColor: Colors.red.shade700,
                    ),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ─── Reusable section card ────────────────────────────────────────────
  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: GalleryEditorUIConfig.darkGreen,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: GalleryEditorUIConfig.darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  // ─── Reusable labelled text field ─────────────────────────────────────
  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
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
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
      ],
    );
  }
}
