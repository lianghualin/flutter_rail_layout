import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Internal tab item for the floating tab bar.
class TabBarItem {
  final String title;
  final IconData icon;

  const TabBarItem({
    required this.title,
    required this.icon,
  });
}

/// A floating tab bar with anchored expansion animation.
///
/// When hovered, the tab bar expands to show labels alongside icons.
/// The expansion is anchored to the tab where the cursor enters,
/// keeping that tab visually fixed while others expand outward.
class FloatingTabBar extends StatefulWidget {
  final List<TabBarItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  /// Background color of the tab bar.
  final Color backgroundColor;

  /// Border color of the tab bar.
  final Color borderColor;

  /// Color of the active tab background.
  final Color activeColor;

  /// Text/icon color for inactive tabs.
  final Color inactiveColor;

  /// Text/icon color for active tab.
  final Color activeTextColor;

  /// Duration of the expand/collapse animation.
  final Duration animationDuration;

  const FloatingTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabSelected,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.borderColor = const Color(0xFFE2E8F0),
    this.activeColor = const Color(0xFF3B82F6),
    this.inactiveColor = const Color(0xFF64748B),
    this.activeTextColor = Colors.white,
    this.animationDuration = const Duration(milliseconds: 250),
  });

  @override
  State<FloatingTabBar> createState() => _FloatingTabBarState();
}

class _FloatingTabBarState extends State<FloatingTabBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _anchorIndex = 1;

  static const double _collapsedTabWidth = 44.0;
  static const double _expandedTabWidth = 106.0;
  static const double _containerPadding = 6.0;

  @override
  void initState() {
    super.initState();
    _anchorIndex = (widget.tabs.length - 1) ~/ 2;
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(PointerEnterEvent event) {
    final x = event.localPosition.dx - _containerPadding;
    final tabIndex =
        (x / _collapsedTabWidth).floor().clamp(0, widget.tabs.length - 1);

    setState(() {
      _anchorIndex = tabIndex;
    });
    _controller.forward();
  }

  void _onExit(PointerExitEvent event) {
    _controller.reverse();
  }

  double _calculateShift(double t) {
    const delta = _expandedTabWidth - _collapsedTabWidth;
    final centerIndex = (widget.tabs.length - 1) / 2;
    return delta * (centerIndex - _anchorIndex) * t;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final t = _animation.value;
        final shift = _calculateShift(t);

        return Transform.translate(
          offset: Offset(shift, 0),
          child: MouseRegion(
            onEnter: _onEnter,
            onExit: _onExit,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.all(lerpDouble(6, 8, t)!),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: widget.borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(widget.tabs.length, (index) {
                      return _TabButton(
                        title: widget.tabs[index].title,
                        icon: widget.tabs[index].icon,
                        isActive: index == widget.currentIndex,
                        expandProgress: t,
                        onTap: () => widget.onTabSelected(index),
                        activeColor: widget.activeColor,
                        inactiveColor: widget.inactiveColor,
                        activeTextColor: widget.activeTextColor,
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TabButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final double expandProgress;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeTextColor;

  const _TabButton({
    required this.title,
    required this.icon,
    required this.isActive,
    required this.expandProgress,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.activeTextColor,
  });

  @override
  State<_TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends State<_TabButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.expandProgress;
    final color = widget.isActive
        ? widget.activeTextColor
        : _isHovered
            ? const Color(0xFF1E293B)
            : widget.inactiveColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: lerpDouble(12, 20, t)!,
            vertical: lerpDouble(8, 10, t)!,
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? widget.activeColor
                : _isHovered
                    ? const Color(0xFFF1F5F9)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: lerpDouble(20, 18, t),
                color: color,
              ),
              ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: t,
                  child: Opacity(
                    opacity: t,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: color,
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
    );
  }
}
