import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TabItem {
  final String title;
  final String pageTitle;
  final String subtitle;
  final IconData icon;

  const TabItem({
    required this.title,
    required this.pageTitle,
    required this.subtitle,
    required this.icon,
  });
}

class FloatingTabBar extends StatefulWidget {
  final List<TabItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const FloatingTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  State<FloatingTabBar> createState() => _FloatingTabBarState();
}

class _FloatingTabBarState extends State<FloatingTabBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _anchorIndex = 1; // Default to middle tab

  // Approximate tab widths (used for anchor calculation)
  static const double _collapsedTabWidth = 44.0;
  static const double _expandedTabWidth = 106.0;
  static const double _containerPadding = 6.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
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
    // Calculate which tab the cursor is over based on x position
    // Subtract container padding to get position within tab row
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

  // Calculate horizontal shift to keep anchor tab in place
  // Formula: shift = delta * ((numTabs - 1) / 2 - anchorIndex)
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
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
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
  final double expandProgress; // 0.0 = collapsed, 1.0 = expanded
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.icon,
    required this.isActive,
    required this.expandProgress,
    required this.onTap,
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
        ? Colors.white
        : _isHovered
            ? const Color(0xFF1E293B)
            : const Color(0xFF64748B);

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
                ? const Color(0xFF3B82F6)
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
              // Animate text width using ClipRect + SizeTransition-like approach
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
