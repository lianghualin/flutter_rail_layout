import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'rail_tab.dart';
import 'floating_tab_bar.dart';

/// Default gradients for pages when not specified.
const List<Gradient> _defaultGradients = [
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE0F2FE), Color(0xFFF8FAFC)],
  ),
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD1FAE5), Color(0xFFF8FAFC)],
  ),
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF3E8FF), Color(0xFFF8FAFC)],
  ),
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFEF3C7), Color(0xFFF8FAFC)],
  ),
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFCE7F3), Color(0xFFF8FAFC)],
  ),
];

/// A horizontal rail layout with animated floating tab bar.
///
/// This widget provides a complete layout with:
/// - A floating tab bar centered at the top with anchored expansion animation
/// - Page title and subtitle in the top-left header
/// - Swipeable page content area with gradient backgrounds
///
/// Example usage:
/// ```dart
/// HorizontalRailLayout(
///   tabs: [
///     RailTab(
///       label: 'Home',
///       pageTitle: 'Dashboard',
///       subtitle: 'Welcome back',
///       icon: Icons.home,
///       page: HomePage(),
///     ),
///     RailTab(
///       label: 'Settings',
///       pageTitle: 'Settings',
///       subtitle: 'Configure your app',
///       icon: Icons.settings,
///       page: SettingsPage(),
///     ),
///   ],
/// )
/// ```
class HorizontalRailLayout extends StatefulWidget {
  /// The list of tabs to display.
  final List<RailTab> tabs;

  /// Initial page index. Defaults to 0.
  final int initialIndex;

  /// Callback when the page changes.
  final ValueChanged<int>? onPageChanged;

  /// Whether to enable keyboard navigation (arrow keys).
  final bool enableKeyboardNavigation;

  /// Duration for page transition animation.
  final Duration pageTransitionDuration;

  /// Curve for page transition animation.
  final Curve pageTransitionCurve;

  /// Padding for the header area.
  final EdgeInsets headerPadding;

  /// Padding for the page content area.
  final EdgeInsets contentPadding;

  /// Height of the header area.
  final double headerHeight;

  /// Whether to show the subtitle in the header.
  final bool showSubtitle;

  /// Style for the page title text.
  final TextStyle? pageTitleStyle;

  /// Style for the subtitle text.
  final TextStyle? subtitleStyle;

  /// Background color of the tab bar.
  final Color tabBarBackgroundColor;

  /// Border color of the tab bar.
  final Color tabBarBorderColor;

  /// Color of the active tab.
  final Color tabBarActiveColor;

  /// Text/icon color for inactive tabs.
  final Color tabBarInactiveColor;

  /// Text/icon color for active tab.
  final Color tabBarActiveTextColor;

  /// Creates a [HorizontalRailLayout].
  const HorizontalRailLayout({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onPageChanged,
    this.enableKeyboardNavigation = true,
    this.pageTransitionDuration = const Duration(milliseconds: 500),
    this.pageTransitionCurve = Curves.easeOutCubic,
    this.headerPadding = const EdgeInsets.fromLTRB(16, 8, 16, 8),
    this.contentPadding = const EdgeInsets.fromLTRB(16, 70, 16, 16),
    this.headerHeight = 70,
    this.showSubtitle = false,
    this.pageTitleStyle,
    this.subtitleStyle,
    this.tabBarBackgroundColor = const Color(0xFFFFFFFF),
    this.tabBarBorderColor = const Color(0xFFE2E8F0),
    this.tabBarActiveColor = const Color(0xFF3B82F6),
    this.tabBarInactiveColor = const Color(0xFF64748B),
    this.tabBarActiveTextColor = Colors.white,
  });

  @override
  State<HorizontalRailLayout> createState() => _HorizontalRailLayoutState();
}

class _HorizontalRailLayoutState extends State<HorizontalRailLayout> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: widget.pageTransitionDuration,
      curve: widget.pageTransitionCurve,
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (!widget.enableKeyboardNavigation) return;

    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft && _currentPage > 0) {
        _goToPage(_currentPage - 1);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
          _currentPage < widget.tabs.length - 1) {
        _goToPage(_currentPage + 1);
      }
    }
  }

  Gradient _getGradientForIndex(int index) {
    final tab = widget.tabs[index];
    if (tab.gradient != null) {
      return tab.gradient!;
    }
    return _defaultGradients[index % _defaultGradients.length];
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: _handleKeyEvent,
      child: Stack(
        children: [
          // Page View
          PageView.builder(
            controller: _pageController,
            itemCount: widget.tabs.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              widget.onPageChanged?.call(index);
            },
            itemBuilder: (context, index) {
              return _PageContainer(
                gradient: _getGradientForIndex(index),
                padding: widget.contentPadding,
                child: widget.tabs[index].page,
              );
            },
          ),

          // Header Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeaderBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBar() {
    final currentTab = widget.tabs[_currentPage];

    const defaultTitleStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1E293B),
    );

    const defaultSubtitleStyle = TextStyle(
      fontSize: 13,
      color: Color(0xFF64748B),
    );

    return Container(
      padding: widget.headerPadding,
      height: widget.headerHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left: Page Title (and optional Subtitle)
          Align(
            alignment: Alignment.centerLeft,
            child: widget.showSubtitle
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentTab.pageTitle,
                        style: widget.pageTitleStyle ?? defaultTitleStyle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentTab.subtitle,
                        style: widget.subtitleStyle ?? defaultSubtitleStyle,
                      ),
                    ],
                  )
                : Text(
                    currentTab.pageTitle,
                    style: widget.pageTitleStyle ?? defaultTitleStyle,
                  ),
          ),

          // Center: Tab Bar
          FloatingTabBar(
            tabs: widget.tabs
                .map((tab) => TabBarItem(title: tab.label, icon: tab.icon))
                .toList(),
            currentIndex: _currentPage,
            onTabSelected: _goToPage,
            backgroundColor: widget.tabBarBackgroundColor,
            borderColor: widget.tabBarBorderColor,
            activeColor: widget.tabBarActiveColor,
            inactiveColor: widget.tabBarInactiveColor,
            activeTextColor: widget.tabBarActiveTextColor,
          ),
        ],
      ),
    );
  }
}

/// Container for page content with gradient background.
class _PageContainer extends StatelessWidget {
  final Gradient gradient;
  final EdgeInsets padding;
  final Widget child;

  const _PageContainer({
    required this.gradient,
    required this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      padding: padding,
      child: child,
    );
  }
}
