import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/dynamic_content_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../models/content_model.dart';

class GalleryEditor extends StatefulWidget {
  const GalleryEditor({super.key});

  @override
  State<GalleryEditor> createState() => _GalleryEditorState();
}

class _GalleryEditorState extends State<GalleryEditor> {
  final _heroTitleController = TextEditingController();
  final _heroDescController = TextEditingController();
  late List<GalleryImage> _tempGallery;

  @override
  void initState() {
    super.initState();
    final content = context.read<DynamicContentProvider>().content;
    _heroTitleController.text = content.galleryHeroTitle;
    _heroDescController.text = content.galleryHeroDescription;
    _tempGallery = List.from(content.galleryImages);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gallery Screen Editor',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          _buildSection('Hero Section', [
            _buildTextField('Hero Title', _heroTitleController),
            const SizedBox(height: 16),
            _buildTextField('Hero Description', _heroDescController, maxLines: 4),
          ]),
          const SizedBox(height: 24),
          _buildSection('Gallery Items', [
            ..._tempGallery.asMap().entries.map((entry) {
              int idx = entry.key;
              GalleryImage item = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        onChanged: (val) => _tempGallery[idx] =
                            GalleryImage(imageUrl: val, label: item.label),
                        decoration: const InputDecoration(
                          labelText: 'Image URL',
                          hintText: 'https://...',
                        ),
                        controller: TextEditingController(text: item.imageUrl),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        onChanged: (val) => _tempGallery[idx] =
                            GalleryImage(imageUrl: item.imageUrl, label: val),
                        decoration: const InputDecoration(labelText: 'Label'),
                        controller: TextEditingController(text: item.label),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => _tempGallery.removeAt(idx)),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => setState(() => _tempGallery.add(GalleryImage(
                  imageUrl: 'https://via.placeholder.com/400x300',
                  label: 'New Item'))),
              icon: const Icon(Icons.add),
              label: const Text('Add Gallery Item'),
            ),
          ]),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              context.read<DynamicContentProvider>().updateGalleryHero(
                    _heroTitleController.text,
                    _heroDescController.text,
                  );
              context.read<DynamicContentProvider>().updateGalleryImages(_tempGallery);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gallery updated!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            child: const Text('Save Gallery Changes'),
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
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGreen,
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
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textMedium,
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
