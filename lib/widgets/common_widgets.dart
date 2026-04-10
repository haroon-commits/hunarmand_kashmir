import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../providers/dynamic_content_provider.dart';

// ─── CUSTOM APP BAR ───────────────────────────────────────────────────────────
/// A premium, responsive top navigation bar designed for desktop and large tablets.
/// Centrally manages the site's logo, navigation links, and primary call-to-action buttons.
class HunarmandAppBar extends StatelessWidget implements PreferredSizeWidget {
  // The identifier of the screen currently being viewed to highlight the active link
  final String currentPage;

  // Constructor for the app bar
  const HunarmandAppBar({
    super.key,
    required this.currentPage,
  });

  @override
  // Defines the standard height for the application bar (64 pixels)
  Size get preferredSize => const Size.fromHeight(64);

  @override
  // Builds the visual structure of the app bar
  Widget build(BuildContext context) {
    // Checking device class for responsive sizing
    final isDesktop = Responsive.isDesktop(context);
    // Returning the core AppBar component
    return AppBar(
      // Signature dark green brand background
      backgroundColor: AppColors.darkGreen,
      // Flat design without shadows
      elevation: 0,
      // Removing default spacing to allow for manual title alignment
      titleSpacing: 0,
      // Centering the navigation content within the max width constraint
      title: Center(
        child: ConstrainedBox(
          // Enforcing the global standard content width for large screens
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          // Adding horizontal margin for content
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            // Organizing items in a single horizontal row
            child: Row(
              children: [
                // Branding/Logo Section
                Consumer<DynamicContentProvider>(
                  builder: (context, provider, _) => MouseRegion(
                    // Changing cursor to pointer to signify navigation capability
                    cursor: SystemMouseCursors.click,
                    // Handling logo click event
                    child: GestureDetector(
                      // Redirecting to home screen on logo tap
                      onTap: () => context.read<AppState>().navigate('home'),
                      // Urdu branding with professional calligraphy font
                      child: provider.content.logoPath != null &&
                              provider.content.logoPath!.isNotEmpty
                          ? Image.network(
                              provider.content.logoPath!,
                              height: isDesktop ? 40 : 32,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Text(
                                provider.content.logoText,
                                style: GoogleFonts.amiriQuran(
                                  color: AppColors.accentGold,
                                  fontSize: isDesktop ? 24 : 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Text(
                              provider.content.logoText,
                              style: GoogleFonts.amiriQuran(
                                color: AppColors.accentGold,
                                fontSize: isDesktop ? 24 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                // Pushing navigation items to the right side of the bar
                const Spacer(),
                // Navigation Link Section
                if (isDesktop) ...[
                  // Full navigation menu for desktop users
                  _navItem(context, 'Home', 'home'),
                  _navItem(context, 'About', 'about'),
                  _navItem(context, 'Courses', 'courses'),
                  _navItem(context, 'Gallery', 'gallery'),
                  _navItem(context, 'Contact', 'contact'),
                  // Adding extra spacing between links and buttons
                  const SizedBox(width: 16),
                ] else ...[
                  // Condensed navigation for smaller tablet screens
                  _navItem(context, 'Courses', 'courses'),
                  _navItem(context, 'About', 'about'),
                  const SizedBox(width: 8),
                ],
                // Primary Action: Support the initiative
                _donateButton(context),
                // Separating action buttons
                const SizedBox(width: 8),
                // Secondary Action: Enroll in courses
                _joinNowButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper to build a single navigation link with hoverable properties.
  /// [label] is the text shown, [page] is the navigation identifier.
  Widget _navItem(BuildContext context, String label, String page) {
    // Checking if this link points to the current active screen
    final isActive = currentPage == page;
    // Interactive mouse context
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      // Navigation handler
      child: GestureDetector(
        onTap: () => context.read<AppState>().navigate(page),
        // Visual container for the link
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          // Underline indicator for active pages
          decoration: isActive
              ? const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.accentGold, width: 2),
                  ),
                )
              : null,
          // Textual representation of the link
          child: Text(
            label,
            style: GoogleFonts.poppins(
              // Using lighter white for inactive links to reduce visual noise
              color: isActive ? AppColors.white : Colors.white70,
              fontSize: 13, // Standard readable size
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the stylized 'Donate' button for the navigation bar.
  Widget _donateButton(BuildContext context) {
    // Interactive mouse context
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      // Navigation handler to the donation page
      child: GestureDetector(
        onTap: () => context.read<AppState>().navigate('donate'),
        // Outlined button container
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            // Outlined style using brand gold
            border: Border.all(color: AppColors.accentGold),
            // Smooth rounded corners
            borderRadius: BorderRadius.circular(20),
          ),
          // Organization of icon and text
          child: Row(
            children: [
              // Heart icon symbolizing charitable giving
              const Icon(Icons.favorite, color: AppColors.accentGold, size: 14),
              // Small gap between icon and label
              const SizedBox(width: 4),
              // Button label
              Text(
                'Donate',
                style: GoogleFonts.poppins(
                  color: AppColors.accentGold,
                  fontSize: 12,
                  fontWeight: FontWeight.w600, // Medium heavy for legibility
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the high-contrast 'Join Now' button for the navigation bar.
  Widget _joinNowButton(BuildContext context) {
    // Interactive mouse context
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      // Navigation handler to the contact/registration page
      child: GestureDetector(
        onTap: () => context.read<AppState>().navigate('contact'),
        // Solid white container for maximum pop against dark header
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          // Bold CTA text
          child: Text(
            'Join Now',
            style: GoogleFonts.poppins(
              color: AppColors.darkGreen, // Contrasting brand color
              fontSize: 12,
              fontWeight: FontWeight.w700, // Extra bold for call-to-action
            ),
          ),
        ),
      ),
    );
  }
}

// ─── MOBILE DRAWER ────────────────────────────────────────────────────────────
/// A stylized slide-out menu designed for mobile and small tablet viewports.
/// Provides access to all major site sections and key actions in a space-efficient manner.
class HunarmandDrawer extends StatelessWidget {
  // Constructor for the drawer
  const HunarmandDrawer({super.key});

  @override
  // Builds the vertical list of navigation items
  Widget build(BuildContext context) {
    // Returning the drawer component
    return Drawer(
      // Matching core brand background color
      backgroundColor: AppColors.darkGreen,
      // Main organization container
      child: Column(
        children: [
          // Branding section at the top of the drawer
          DrawerHeader(
            // Slightly brighter green to differentiate the header
            decoration: const BoxDecoration(color: AppColors.mediumGreen),
            child: Center(
              // Centered branding stack
              child: Consumer<DynamicContentProvider>(
                builder: (context, provider, _) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Signature Urdu logo
                    provider.content.logoPath != null &&
                            provider.content.logoPath!.isNotEmpty
                        ? Image.network(
                            provider.content.logoPath!,
                            height: 50,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Text(
                              provider.content.logoText,
                              style: GoogleFonts.amiriQuran(
                                color: AppColors.accentGold,
                                fontSize: 28,
                              ),
                            ),
                          )
                        : Text(
                            provider.content.logoText,
                            style: GoogleFonts.amiriQuran(
                              color: AppColors.accentGold,
                              fontSize: 28,
                            ),
                          ),
                    // Visual gap
                    const SizedBox(height: 8),
                    // English secondary branding
                    Text(
                      provider.content.appTitle,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 13, // Subtitle size
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Navigating to internal pages via menu items
          _drawerItem(context, Icons.home_outlined, 'Home', 'home'),
          _drawerItem(context, Icons.info_outline, 'About Us', 'about'),
          _drawerItem(context, Icons.school_outlined, 'Courses', 'courses'),
          _drawerItem(
              context, Icons.photo_library_outlined, 'Gallery', 'gallery'),
          _drawerItem(
              context, Icons.contact_mail_outlined, 'Contact', 'contact'),
          _drawerItem(context, Icons.favorite_outline, 'Donate', 'donate'),
          // Pushes the footer button to the very bottom
          const Spacer(),
          // Persistent high-visibility CTA for mobile users
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity, // Full width button for easier tapping
              child: ElevatedButton(
                // Action: close drawer and go to contact/enrollment
                onPressed: () {
                  Navigator.pop(context); // Close the drawer first
                  context.read<AppState>().navigate('contact'); // Then navigate
                },
                style: ElevatedButton.styleFrom(
                  // Accent gold for immediate visual priority
                  backgroundColor: AppColors.accentGold,
                  foregroundColor: AppColors.darkGreen, // Dark text for contrast
                  // High rounded corners (pill button)
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                // Bold label text
                child: Text('Join Now',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to build a consistent navigation list tile within the drawer.
  /// [icon] is the leading symbol, [label] is the link text, [page] is destiny.
  Widget _drawerItem(
      BuildContext context, IconData icon, String label, String page) {
    return ListTile(
      // Clear visual symbol representing the page
      leading: Icon(icon, color: Colors.white70, size: 20),
      // Clean typography for the link label
      title: Text(label,
          style: GoogleFonts.poppins(color: AppColors.white, fontSize: 14)),
      // Handling the navigation event
      onTap: () {
        // Cleaning up the UI by closing the drawer
        Navigator.pop(context);
        // Updating the global application state to track the new page
        context.read<AppState>().navigate(page);
      },
    );
  }
}

// ─── GREEN HERO HEADER ────────────────────────────────────────────────────────
/// A majestic section header with a dark brand background.
/// Used at the top of interior pages to provide immediate context and aesthetic appeal.
class GreenPageHeader extends StatelessWidget {
  // Large bold title for the section
  final String title;
  // Explanatory text shown beneath the title
  final String subtitle;

  // Constructor for the header
  const GreenPageHeader(
      {super.key, required this.title, required this.subtitle});

  @override
  // Builds the visual column of header content
  Widget build(BuildContext context) {
    // Checking current viewport constraints for adaptive typography
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    
    // Determining optimal font size for the large headline
    final titleSize = isDesktop
        ? 42.0 // Heroic size for monitors
        : isTablet
            ? 34.0 // Balanced size for tablets
            : 28.0; // Clear but compact for mobile
            
    // Determining optimal font size for the explanatory text
    final subSize = isDesktop
        ? 16.0
        : isTablet
            ? 15.0
            : 14.0;
            
    // Context-aware vertical spacing
    final vPad = isDesktop
        ? 72.0 // Deep majestic padding for desktop
        : isTablet
            ? 56.0
            : 44.0; // Tight spacing for mobile

    // Wrapping everything in a full-width dark container
    return Container(
      width: double.infinity,
      color: AppColors.darkGreen,
      child: Center(
        // Constraining content width within the global design system bound
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            // Applying the calculated adaptive padding
            padding: EdgeInsets.symmetric(
              vertical: vPad,
              horizontal: Responsive.contentPaddingH(context),
            ),
            // Organizing the layout components vertically
            child: Column(
              children: [
                // Displaying the primary page headline
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: AppColors.white,
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold, // Commanding presence
                  ),
                ),
                // Visual separation between title and body
                const SizedBox(height: 14),
                // Restricting description length to ensure ideal line length (readability)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white70, // Slightly muted for hierarchy
                      fontSize: subSize,
                      height: 1.6, // Generous line spacing for readability
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

// ─── SLIVER GREEN PAGE HEADER ───────────────────────────────────────────────
/// An adapter that wraps [GreenPageHeader] for use within a [CustomScrollView].
/// Facilitates the creation of high-performance scrolling pages with sliver effects.
class SliverGreenPageHeader extends StatelessWidget {
  // Main title of the page
  final String title;
  // Supporting subtitle text
  final String subtitle;

  // Constructor mapping the required props to the child widget
  const SliverGreenPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  // Returning the sliver-ready adapter
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      // Embedding the standard non-sliver header inside the adapter
      child: GreenPageHeader(title: title, subtitle: subtitle),
    );
  }
}

// ─── SECTION LABEL ────────────────────────────────────────────────────────────
/// A hierarchical text block used as a header for various content sections.
/// Organizes content into an uppercase label, a main title, and an optional description.
class SectionLabel extends StatelessWidget {
  // The small, uppercase category tag (e.g., 'OUR MISSION')
  final String label;
  // The primary headline for the section
  final String title;
  // Optional detailed explanation text
  final String? subtitle;

  // Constructor with optional subtitle support
  const SectionLabel(
      {super.key, required this.label, required this.title, this.subtitle});

  @override
  // Builds the vertical typographic stack
  Widget build(BuildContext context) {
    return Column(
      // Left-aligning all textual elements
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The stylistic category marker
        Text(
          label.toUpperCase(), // Forcing uppercase for standard brand style
          style: GoogleFonts.poppins(
            color: AppColors.accentGold, // Highlighted with primary gold
            fontSize: 11, // Small and discrete
            fontWeight: FontWeight.w700, // Extra bold for categorical authority
            letterSpacing: 1.5, // Expanded tracking for a premium feel
          ),
        ),
        // Visual spacing
        const SizedBox(height: 6),
        // The main section headline using globally defined theme styles
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        // Conditional build of the subtitle paragraph
        if (subtitle != null) ...[
          // Gap before subtitle
          const SizedBox(height: 8),
          // Descriptive text using standard body style
          Text(subtitle!, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ],
    );
  }
}

// ─── GOLD DIVIDER ────────────────────────────────────────────────────────────
/// A simple typographic ornament used to separate headers from content.
/// Features the brand's accent gold color and a rounded, subtle appearance.
class GoldDivider extends StatelessWidget {
  // Constructor for the divider
  const GoldDivider({super.key});

  @override
  // Builds a small horizontal bar
  Widget build(BuildContext context) {
    return Container(
      width: 48, // Fixed width for consistent visual weight
      height: 3, // Slightly thick for presence
      margin: const EdgeInsets.symmetric(vertical: 12), // Vertical breathing room
      decoration: BoxDecoration(
        color: AppColors.accentGold, // Highlight color
        borderRadius: BorderRadius.circular(2), // Smooth edges
      ),
    );
  }
}

// ─── FEATURE CARD ─────────────────────────────────────────────────────────────
/// An interactive card used to showcase platform features or core values.
/// Features a lift animation, border highlight, and a dynamic 'Learn more' indicator on hover.
class FeatureCard extends StatefulWidget {
  // Icon representing the feature as String (emoji or URL)
  final String icon;
  // Short headline for the feature
  final String title;
  // Detailed description text
  final String description;

  // Constructor with required props
  const FeatureCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.description});

  @override
  // Creating the mutable state for hover effects
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  // Internal state tracking whether the mouse pointer is over the card
  bool _isHovered = false;

  @override
  // Builds the layered visual structure with animations
  Widget build(BuildContext context) {
    // Isolating the card for better performance during animations
    return RepaintBoundary(
      child: MouseRegion(
        // Indicating interactivity to the user
        cursor: SystemMouseCursors.click,
        // Updating state when mouse enters the hit area
        onEnter: (_) => setState(() => _isHovered = true),
        // Updating state when mouse leaves the hit area
        onExit: (_) => setState(() => _isHovered = false),
        // The core animated container handling the physical properties
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250), // Smooth transition speed
          curve: Curves.easeOutCubic, // Natural feeling easing curve

          // Vertical lift effect to simulate physical elevation
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -6.0 : 0.0),

          padding: const EdgeInsets.all(24), // Internal spacing for content
          decoration: BoxDecoration(
            color: AppColors.white, // Neutral background
            borderRadius: BorderRadius.circular(20), // Modern rounded corners

            // Dynamic border color that glows soft gold on hover
            border: Border.all(
              color: _isHovered
                  ? AppColors.accentGold.withOpacity(0.5)
                  : Colors.grey.shade100,
              width: 1.5,
            ),

            // Responsive shadow that deepens when the card "lifts"
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.darkGreen.withOpacity(0.08)
                    : Colors.black.withOpacity(0.04),
                blurRadius: _isHovered ? 20 : 12, // Softer shadow on hover
                offset: Offset(0, _isHovered ? 12 : 4), // Pushing shadow down
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Visual Icon Container
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  // Robust brand green background
                  color: AppColors.darkGreen,
                  borderRadius: BorderRadius.circular(16),

                  // Subtle glow effect beneath the icon container on hover
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: AppColors.darkGreen.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Center(
                  // Displaying the dynamic icon
                  child: _renderDynamicIcon(widget.icon,
                      color: Colors.white, size: 28),
                ),
              ),

              // Gap after icon
              const SizedBox(height: 20),

              // Primary Feature Title
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),

              // Gap before description
              const SizedBox(height: 10),

              // Feature Description paragraph
              Text(
                widget.description,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textMedium,
                  height: 1.6, // Readable line height
                ),
              ),

              // Gap before CTA
              const SizedBox(height: 16),

              // Learn More indicator - only visible on hover
              AnimatedOpacity(
                opacity: _isHovered ? 1.0 : 0.0, // Fading effect
                duration: const Duration(milliseconds: 250),
                child: Row(
                  children: [
                    // CTA text
                    Text(
                      'Learn more',
                      style: GoogleFonts.poppins(
                        color: AppColors.accentGold,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Small gap
                    const SizedBox(width: 4),
                    // Directional arrow
                    const Icon(
                      Icons.arrow_forward,
                      color: AppColors.accentGold,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── SLIVER RESPONSIVE CARD GRID ──────────────────────────────────────────────
/// A responsive grid layout optimized for sliver-based scrolling views.
/// Automatically adjusts column counts based on the device's screen width.
class SliverResponsiveCardGrid extends StatelessWidget {
  // Collection of widgets to be displayed in the grid
  final List<Widget> children;
  // Desired column count for mobile devices
  final int mobileCols;
  // Desired column count for tablets
  final int tabletCols;
  // Desired column count for desktop monitors
  final int desktopCols;
  // Unified spacing between grid items
  final double spacing;

  // Constructor with defaults for a typical 3-column layout
  const SliverResponsiveCardGrid({
    super.key,
    required this.children,
    this.mobileCols = 1,
    this.tabletCols = 2,
    this.desktopCols = 3,
    this.spacing = 16,
  });

  @override
  // Builds the SliverGrid based on the calculated responsive state
  Widget build(BuildContext context) {
    // Determining the final column count using the responsive utility
    final cols = Responsive.gridCols(
      context,
      mobileCols: mobileCols,
      tabletCols: tabletCols,
      desktopCols: desktopCols,
    );

    // Returning the grid sliver
    return SliverGrid(
      // Configuring the grid delegate for fixed column count
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        // Fluid aspect ratio: cards are taller on desktop/tablet to fit more info
        childAspectRatio: cols == 1 ? 2.8 : (cols == 2 ? 1.0 : 0.85),
      ),
      // Efficiently building children only when they enter the viewport
      delegate: SliverChildBuilderDelegate(
        (context, index) => children[index],
        childCount: children.length,
      ),
    );
  }
}

// ─── RESPONSIVE CARD GRID ─────────────────────────────────────────────────────
/// A standard responsive grid layout for non-sliver context.
/// Manages vertical column-to-row transformation based on device size.
class ResponsiveCardGrid extends StatelessWidget {
  // Collection of widgets (usually cards) to display
  final List<Widget> children;
  // Specific column overrides
  final int mobileCols;
  final int tabletCols;
  final int desktopCols;
  // Spacing between items
  final double spacing;

  // Constructor with typical responsive defaults
  const ResponsiveCardGrid({
    super.key,
    required this.children,
    this.mobileCols = 1,
    this.tabletCols = 2,
    this.desktopCols = 3,
    this.spacing = 16,
  });

  @override
  // Builds the grid using standard Rows and Columns
  Widget build(BuildContext context) {
    // Determining layout parameters
    final cols = Responsive.gridCols(
      context,
      mobileCols: mobileCols,
      tabletCols: tabletCols,
      desktopCols: desktopCols,
    );

    // Standard column stack for mobile users
    if (cols == 1) {
      return Column(
        children: children
            .map((child) => Padding(
                  padding: EdgeInsets.only(bottom: spacing),
                  child: child,
                ))
            .toList(),
      );
    }

    // Advanced row builder for multi-column layouts
    final rows = <Widget>[];
    // Iterating through children in chunks defined by the current column count
    for (var i = 0; i < children.length; i += cols) {
      // Slicing the correct number of children for this row
      final List<Widget> rowChildren = <Widget>[...children.skip(i).take(cols)];
      // Padding the final row with empty boxes if it's incomplete
      while (rowChildren.length < cols) {
        rowChildren.add(const SizedBox.shrink());
      }
      // Constructing the visual horizontal row
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowChildren.asMap().entries.map((e) {
              // Distributing items evenly across the row width
              return Expanded(
                child: Padding(
                  // Balanced margins to ensure spacing between items
                  padding: EdgeInsets.only(
                    left: e.key == 0 ? 0 : spacing / 2,
                    right: e.key == cols - 1 ? 0 : spacing / 2,
                  ),
                  child: e.value,
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
    // Final vertical assembly of all processed rows
    return Column(children: rows);
  }
}

// ─── COURSE CARD ──────────────────────────────────────────────────────────────
class CourseCard extends StatefulWidget {
  final String icon;
  final String title;
  final String description;
  final String duration;
  final String fee;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.duration,
    required this.fee,
    required this.onTap,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),

              // Hover border effect (kept)
              border: Border.all(
                color: _isHovered
                    ? AppColors.darkGreen.withOpacity(0.3)
                    : Colors.grey.shade100,
              ),

              // Hover shadow effect (kept)
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? AppColors.darkGreen.withOpacity(0.08)
                      : Colors.black.withOpacity(0.04),
                  blurRadius: _isHovered ? 15 : 8,
                  offset: Offset(0, _isHovered ? 8 : 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // ================= ICON CONTAINER =================
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        // ✅ FIXED COLOR (no hover change)
                        color: AppColors.darkGreen,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        // ❌ Removed AnimatedScale (no icon animation)
                      child: Center(
                        child: _renderDynamicIcon(widget.icon,
                            color: Colors.white, size: 24),
                      ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            widget.duration,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.accentGold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ================= DESCRIPTION =================
                Text(
                  widget.description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textMedium,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 18),

                // ================= BOTTOM SECTION =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.fee,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkGreen,
                      ),
                    ),

                    // ================= APPLY BUTTON =================
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isHovered
                            ? AppColors.accentGold
                            : AppColors.darkGreen,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: _isHovered
                            ? [
                                BoxShadow(
                                  color: AppColors.accentGold.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Apply',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _isHovered
                                  ? AppColors.darkGreen
                                  : AppColors.white,
                            ),
                          ),

                          // Arrow still appears on hover (kept)
                          if (_isHovered) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward,
                              color: AppColors.darkGreen,
                              size: 14,
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── CONTACT INFO TILE ───────────────────────────────────────────────────────
/// A horizontal layout block displaying an icon alongside contact metadata.
/// Used for phone numbers, email addresses, and physical locations.
class ContactInfoTile extends StatelessWidget {
  // Visual symbol for the type of contact information
  final IconData icon;
  // Categorical label (e.g., 'Email')
  final String label;
  // Actual contact value (e.g., 'hello@world.com')
  final String value;

  // Constructor with required descriptive fields
  const ContactInfoTile(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  // Builds the tile structure
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Decorative icon circular background
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.lightTeal, // Soft secondary brand color
            shape: BoxShape.circle,
          ),
          // Centered symbol using primary brand green
          child: Icon(icon, color: AppColors.darkGreen, size: 20),
        ),
        // Visual gap
        const SizedBox(width: 14),
        // Textual data stack
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bold informative label
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            // Readable secondary contact data
            Text(
              value,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textMedium),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── APP FOOTER ───────────────────────────────────────────────────────────────
/// A comprehensive site footer containing branding, quick links, and contact information.
/// Adapts its layout for desktop, tablet, and mobile displays to ensure readability.
class AppFooter extends StatelessWidget {
  // Constructor for the footer
  const AppFooter({super.key});

  @override
  // Builds the multi-column footer structure
  Widget build(BuildContext context) {
    // Checking device class for responsive organization
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    // Retrieving global standard padding
    final hPad = Responsive.contentPaddingH(context);

    // Wrapping everything in a dark green container that spans the full width
    return Container(
      color: AppColors.darkGreen,
      child: Center(
        child: ConstrainedBox(
          // Respecting the maximum content width for readability on large screens
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            // Applying symmetrical padding with a deeper top margin
            padding: EdgeInsets.fromLTRB(hPad, 48, hPad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top content region - chooses between horizontal and vertical layouts
                if (isDesktop || isTablet)
                  _buildWideFooter(context) // Multi-column for wide screens
                else
                  _buildNarrowFooter(context), // Stacked for narrow screens

                // Visual separation before the bottom bar
                const SizedBox(height: 28),
                const Divider(color: Colors.white12),
                const SizedBox(height: 14),
                // Bottom bar containing copyright and social links
                _buildBottomBar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Organizes footer content into a single horizontal row with specific proportions.
  Widget _buildWideFooter(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Branding and mission statement (takes up double the space of other columns)
        Expanded(
          flex: 2,
          child: _buildLogoColumn(context),
        ),
        // Spacer for better column breathing room
        const SizedBox(width: 40),
        // Secondary site navigation links
        Expanded(
          child: _buildQuickLinks(context),
        ),
        // Spacer
        const SizedBox(width: 24),
        // Vital contact and location data
        Expanded(
          child: _buildContactColumn(context),
        ),
      ],
    );
  }

  /// Organizes footer content into a vertical stack for mobile viewing.
  Widget _buildNarrowFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primary branding always at the top
        _buildLogoColumn(context),
        // Gap before secondary columns
        const SizedBox(height: 28),
        // Side-by-side secondary links for efficient vertical space usage
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildQuickLinks(context)),
            const SizedBox(width: 20),
            Expanded(child: _buildContactColumn(context)),
          ],
        ),
      ],
    );
  }

  /// Builds the primary branding column including the Urdu logo and description.
  Widget _buildLogoColumn(BuildContext context) {
    return Consumer<DynamicContentProvider>(
      builder: (context, provider, _) {
        final content = provider.content;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Elegant Urdu branding
            Text(
              content.logoText,
              style: GoogleFonts.amiriQuran(
                color: AppColors.accentGold,
                fontSize: 28,
              ),
            ),
            // Small gap
            const SizedBox(height: 10),
            // Passionate platform mission statement
            Text(
              content.footerDescription,
              style: GoogleFonts.poppins(
                color: Colors.white54,
                fontSize: 12,
                height: 1.7, // Airy line height for body text on dark BG
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds the 'Quick Links' navigation column.
  Widget _buildQuickLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section headline
        Text(
          'Quick Links',
          style: GoogleFonts.poppins(
            color: AppColors.accentGold,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        // Gap before links
        const SizedBox(height: 12),
        // Collection of secondary navigation points
        _footerLink(context, 'Our Story', 'about'),
        _footerLink(context, 'All Courses', 'courses'),
        _footerLink(context, 'Donate', 'donate'),
        _footerLink(context, 'Impact Gallery', 'gallery'),
        _footerLink(context, 'Admissions', 'contact'),
      ],
    );
  }

  /// Builds the 'Get in Touch' contact column.
  Widget _buildContactColumn(BuildContext context) {
    return Consumer<DynamicContentProvider>(
      builder: (context, provider, _) {
        final content = provider.content;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section headline
            Text(
              'Get in Touch',
              style: GoogleFonts.poppins(
                color: AppColors.accentGold,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            // Gap before contacts
            const SizedBox(height: 12),
            // Specific contact entry points
            _footerContact(Icons.location_on_outlined, content.contactAddress),
            const SizedBox(height: 8),
            _footerContact(Icons.phone_outlined, content.contactPhone),
            const SizedBox(height: 8),
            _footerContact(Icons.email_outlined, content.contactEmail),
          ],
        );
      },
    );
  }

  /// Builds the final bottom bar containing copyright notice and social icons.
  Widget _buildBottomBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Copyright text - flexible to avoid overflow on small screens
        Flexible(
          child: Text(
            '© 2026 Hunarmand Kashmir. All rights reserved.',
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11),
          ),
        ),
        // Collection of social interaction points
        Row(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => context.read<AppState>().navigate('admin'),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    'Admin Portal',
                    style: GoogleFonts.poppins(
                      color: Colors.white24,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            _socialIcon(Icons.camera_alt_outlined),
            const SizedBox(width: 12),
            _socialIcon(Icons.facebook_outlined),
            const SizedBox(width: 12),
            _socialIcon(Icons.alternate_email),
          ],
        ),
      ],
    );
  }

  /// Helper to build a single footer link with navigation logic.
  Widget _footerLink(BuildContext context, String label, String page) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.read<AppState>().navigate(page),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
          ),
        ),
      ),
    );
  }

  /// Helper to build a contact entry with an icon and multi-line text support.
  Widget _footerContact(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Descriptive icon
        Icon(icon, color: Colors.white54, size: 13),
        // Visual gap
        const SizedBox(width: 6),
        // Contact data text
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
                color: Colors.white70, fontSize: 11, height: 1.4),
          ),
        ),
      ],
    );
  }

  /// Builds a small circular icon button for social media profiles.
  Widget _socialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        // Subtle outlined border to define the shape
        border: Border.all(color: Colors.white24),
        shape: BoxShape.circle,
      ),
      // Muted white icon for secondary visibility
      child: Icon(icon, color: Colors.white54, size: 14),
    );
  }
}

// ─── DONATION TIER CARD ───────────────────────────────────────────────────────
/// A specialized card for displaying various donation tiers with distinct visual importance.
/// Highlights 'Popular' choices and provides interactive scaling effects on hover.
class DonationTierCard extends StatefulWidget {
  // Symbol representing the donation purpose as String (emoji or URL)
  final String icon;
  // Label for the tier (e.g., 'Learning Kit')
  final String title;
  // Cost level for this tier
  final String amount;
  // Explanation of the donation's direct impact
  final String description;
  // Boolean flag to trigger enhanced styling for high-priority tiers
  final bool isPopular;
  // Callback handle for the donation action
  final VoidCallback onTap;

  // Constructor with required descriptive properties
  const DonationTierCard({
    super.key,
    required this.icon,
    required this.title,
    required this.amount,
    required this.description,
    required this.isPopular,
    required this.onTap,
  });

  @override
  // Creating mutable state for rich interaction
  State<DonationTierCard> createState() => _DonationTierCardState();
}

class _DonationTierCardState extends State<DonationTierCard> {
  // Tracking mouse pointer presence for visual feedback
  bool _isHovered = false;

  @override
  // Builds the layered card structure including popular badges and buttons
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Core interactive region
        MouseRegion(
          cursor: SystemMouseCursors.click,
          // Updating interactive state
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          // Handling primary click event
          child: GestureDetector(
            onTap: widget.onTap,
            // Main animated container for the card body
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              // Simulating card lift upon hover
              transform: Matrix4.identity()
                ..translate(0.0, _isHovered ? -6.0 : 0.0),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                // Emphasizing the popular tier with a thicker golden border
                border: Border.all(
                  color: widget.isPopular
                      ? AppColors.accentGold
                      : (_isHovered
                          ? AppColors.darkGreen.withOpacity(0.5)
                          : Colors.grey.shade200),
                  width: widget.isPopular ? 2 : 1,
                ),
                // Deep dynamic shadow to amplify the lift effect
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? AppColors.darkGreen.withOpacity(0.12)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: _isHovered ? 20 : 10,
                    offset: Offset(0, _isHovered ? 8 : 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                   // Animated icon representation with magnification on hover
                  AnimatedScale(
                    scale: _isHovered ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        // Color switching for high contrast visual response
                        color: _isHovered
                            ? AppColors.darkGreen
                            : AppColors.lightTeal,
                        shape: BoxShape.circle,
                      ),
                      // Dynamic icon rendering
                      child: _renderDynamicIcon(
                        widget.icon,
                        size: 32,
                        color: _isHovered ? AppColors.white : AppColors.darkGreen,
                        circle: true,
                      ),
                    ),
                  ),
                  // Gap after icon
                  const SizedBox(height: 12),
                  // Bold tier title
                  Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  // Gap before monetary value
                  const SizedBox(height: 6),
                  // Striking amount text using focal gold color
                  Text(
                    widget.amount,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accentGold,
                    ),
                  ),
                  // Gap before narrative description
                  const SizedBox(height: 10),
                  // Impact description paragraph
                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textMedium,
                      height: 1.5,
                    ),
                  ),
                  // Gap before persistent button
                  const SizedBox(height: 16),
                  // Full-width call to action
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onTap,
                      style: ElevatedButton.styleFrom(
                        // Gold for popular choices, dark green for standard choices
                        backgroundColor: widget.isPopular
                            ? AppColors.accentGold
                            : AppColors.darkGreen,
                        // High-contrast foreground switching
                        foregroundColor: widget.isPopular
                            ? AppColors.darkGreen
                            : AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        // Pill-shaped button design
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      // Strong directive label
                      child: Text(
                        'Donate Now',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Stylistic 'Most Popular' badge positioned at the card corner
        if (widget.isPopular)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.accentGold, // Using brand accent for urgency
                borderRadius: BorderRadius.circular(10),
              ),
              // Compact badge text
              child: Text(
                'MOST POPULAR',
                style: GoogleFonts.poppins(
                  color: AppColors.darkGreen, // Contrasting text color
                  fontSize: 9, // Small print for badge
                  fontWeight: FontWeight.w800, // Extra weight for visibility
                ),
              ),
            ),
          ),
      ],
    );
  }
}
Widget _renderDynamicIcon(String icon,
    {Color? color, double size = 24, bool circle = false}) {
  bool isUrl = icon.startsWith('http');

  if (isUrl) {
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
  } else {
    return Text(
      icon,
      style: TextStyle(fontSize: size),
    );
  }
}

// ─── PREMIUM SPLASH SCREEN ──────────────────────────────────────────────────
/// A high-fidelity, branded loading screen displayed while the application fetches data.
class HunarmandSplash extends StatelessWidget {
  const HunarmandSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Urdu Branded Logo Text
            Text(
              'ہنرمند',
              style: GoogleFonts.amiriQuran(
                color: AppColors.accentGold,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // English Tagline
            Text(
              'Hunarmand Kashmir',
              style: GoogleFonts.poppins(
                color: AppColors.white.withOpacity(0.7),
                fontSize: 14,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 48),
            // Themed circular progress indicator
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: AppColors.accentGold,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
