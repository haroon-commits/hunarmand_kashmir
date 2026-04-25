/// ═══════════════════════════════════════════════════════════════════════
/// FILE: gallery_screen.dart
/// PURPOSE: A visual showcase of platform events, workshops, and facilities.
///          Displays an interactive, responsive grid of image assets.
/// CONNECTIONS:
///   - USED BY: main.dart (MainNavigator)
///   - DEPENDS ON: models/content_model.dart (GalleryImage)
///   - SYNCED WITH: admin/editors/gallery_editor.dart
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/layout/page_header.dart';
import '../widgets/layout/app_footer.dart';
import '../utils/responsive.dart';
import '../providers/dynamic_content_provider.dart';
import '../models/content_model.dart';


// ─── GALLERYUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to gallery_screen.dart.
class GalleryUIConfig {
  // Brand Colors used locally
  static const Color accentGold = Color(0xFFF5A623);
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color mediumGreen = Color(0xFF1A4A2E);
  static const Color textMedium = Color(0xFF555555);
  static const Color white = Color(0xFFFFFFFF);

  // Dimensions, Spacing & Typography
  static const double cardIconSize = 60.0;
  static const double fontBodyLarge = 26.0;
  static const double fontLabelSmall = 12.0;
  static const double gridSpacing = 16.0;
  static const double iconSizeLarge = 38.0;
  static const double paddingSectionVertical = 64.0;
  static const double radiusSmall = 12.0;
  static const double spacerExtraLarge = 48.0;
  static const double spacerMedium = 16.0;
  static const double spacerSmall = 8.0;
}


/// A visually rich gallery page displaying a masonry-style journey of the mission's impact.
/// Uses a Pinterest-inspired staggered 3-column layout that mirrors the reference design.
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DynamicContentProvider>(
      builder: (context, provider, _) {
        final content = provider.content;
        final hPad = Responsive.contentPaddingH(context);

        return CustomScrollView(
          slivers: [
            // Hero header
            SliverGreenPageHeader(
              title: content.galleryHeroTitle,
              subtitle: content.galleryHeroDescription,
            ),

            // Masonry gallery grid
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: hPad,
                  vertical: GalleryUIConfig.paddingSectionVertical,
                ),
                child: _MasonryGallery(images: content.galleryImages),
              ),
            ),

            // Gold divider accent before footer
            const SliverToBoxAdapter(
              child: _GoldDividerBar(),
            ),

            // Global site footer
            const SliverToBoxAdapter(child: AppFooter()),
          ],
        );
      },
    );
  }
}

// ─── Gold Divider Bar ─────────────────────────────────────────────────────────

/// A thin horizontal gold accent bar that visually separates the gallery content
/// from the dark footer, matching the reference design's amber/gold top border.
class _GoldDividerBar extends StatelessWidget {
  const _GoldDividerBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      width: double.infinity,
      color: GalleryUIConfig.accentGold,
    );
  }
}

// ─── Masonry Gallery ──────────────────────────────────────────────────────────

/// _MasonryGallery - A Pinterest-style staggered 3-column grid.
/// Distributes images across 3 columns with varying aspect ratios to create
/// an organic, editorial look matching the reference screenshots.
class _MasonryGallery extends StatelessWidget {
  final List<GalleryImage> images;

  const _MasonryGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    if (images.isEmpty) {
      return _buildEmptyState();
    }

    if (!isDesktop && !isTablet) {
      // Mobile: simple 2-column uniform grid
      return _buildTwoColumnGrid(images);
    }

    // Desktop / Tablet: 3-column masonry
    return _buildMasonryGrid(images);
  }

  /// Distributes images into 3 columns with staggered heights for the masonry effect.
  Widget _buildMasonryGrid(List<GalleryImage> images) {
    // Assign images to 3 columns in a round-robin fashion.
    // The aspect ratios alternate to create visual rhythm.
    final List<GalleryImage> col1 = [];
    final List<GalleryImage> col2 = [];
    final List<GalleryImage> col3 = [];

    for (int i = 0; i < images.length; i++) {
      if (i % 3 == 0) col1.add(images[i]);
      else if (i % 3 == 1) col2.add(images[i]);
      else col3.add(images[i]);
    }

    // Alternating aspect ratios per column to create height variation
    final col1Ratios  = [1.1, 1.1, 1.1];   // Left: squat/medium
    final col2Ratios  = [1.6, 1.0, 1.0];   // Middle: tall on top, medium below
    final col3Ratios  = [1.1, 1.4, 1.0];   // Right: varied

    const spacing = GalleryUIConfig.gridSpacing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildColumn(col1, col1Ratios, spacing)),
        const SizedBox(width: spacing),
        Expanded(child: _buildColumn(col2, col2Ratios, spacing)),
        const SizedBox(width: spacing),
        Expanded(child: _buildColumn(col3, col3Ratios, spacing)),
      ],
    );
  }

  /// Builds a single masonry column with optional staggered aspect ratios.
  Widget _buildColumn(
    List<GalleryImage> items,
    List<double> aspectRatios,
    double spacing,
  ) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(height: spacing),
          AspectRatio(
            aspectRatio: i < aspectRatios.length ? aspectRatios[i] : 1.1,
            child: GalleryCardWidget(item: items[i]),
          ),
        ],
      ],
    );
  }

  /// Simple 2-column grid for mobile screens.
  Widget _buildTwoColumnGrid(List<GalleryImage> images) {
    final List<Widget> col1 = [];
    final List<Widget> col2 = [];
    const spacing = GalleryUIConfig.gridSpacing - 2.0;

    for (int i = 0; i < images.length; i++) {
      final card = Padding(
        padding: EdgeInsets.only(bottom: spacing),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: GalleryCardWidget(item: images[i]),
        ),
      );
      if (i.isEven) col1.add(card);
      else col2.add(card);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Column(children: col1)),
        const SizedBox(width: GalleryUIConfig.gridSpacing - 2),
        Expanded(child: Column(children: col2)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: GalleryUIConfig.spacerExtraLarge),
        child: Column(
          children: [
            const Icon(Icons.photo_library_outlined,
                color: GalleryUIConfig.darkGreen,
                size: GalleryUIConfig.cardIconSize),
            const SizedBox(height: GalleryUIConfig.spacerMedium),
            Text(
              'Gallery coming soon',
              style: GoogleFonts.inter(
                color: GalleryUIConfig.textMedium,
                fontSize: GalleryUIConfig.fontBodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Gallery Card ─────────────────────────────────────────────────────────────

/// GalleryCardWidget - An individual image tile with hover overlay.
class GalleryCardWidget extends StatefulWidget {
  final GalleryImage item;
  const GalleryCardWidget({super.key, required this.item});

  @override
  State<GalleryCardWidget> createState() => _GalleryCardWidgetState();
}

class _GalleryCardWidgetState extends State<GalleryCardWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: GalleryUIConfig.mediumGreen,
            borderRadius: BorderRadius.circular(GalleryUIConfig.radiusSmall + 2),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: GalleryUIConfig.darkGreen.withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                )
              else
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(GalleryUIConfig.radiusSmall + 2),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Main image
                Image.network(
                  widget.item.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: GalleryUIConfig.darkGreen,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined,
                            color: Colors.grey.shade400,
                            size: GalleryUIConfig.iconSizeLarge),
                        const SizedBox(height: GalleryUIConfig.spacerSmall),
                        Text(
                          'Image unavailable',
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade400,
                            fontSize: GalleryUIConfig.fontLabelSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom label gradient overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Text(
                      widget.item.label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: GalleryUIConfig.white,
                        fontSize: GalleryUIConfig.fontLabelSmall - 1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Hover overlay
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: _isHovered ? 1.0 : 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: GalleryUIConfig.darkGreen.withOpacity(0.82),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.zoom_in_rounded,
                            color: GalleryUIConfig.accentGold,
                            size: GalleryUIConfig.iconSizeLarge,
                          ),
                          const SizedBox(height: GalleryUIConfig.spacerSmall),
                          Text(
                            'View',
                            style: GoogleFonts.inter(
                              color: GalleryUIConfig.accentGold,
                              fontWeight: FontWeight.w700,
                              fontSize: GalleryUIConfig.fontLabelSmall + 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
