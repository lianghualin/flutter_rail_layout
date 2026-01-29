import 'dart:ui';
import 'package:flutter/material.dart';

class TabItem {
  final String title;
  final String pageTitle;
  final String subtitle;

  const TabItem({
    required this.title,
    required this.pageTitle,
    required this.subtitle,
  });
}

class FloatingTabBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(8),
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
            children: List.generate(tabs.length, (index) {
              return _TabButton(
                title: tabs[index].title,
                isActive: index == currentIndex,
                onTap: () => onTabSelected(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatefulWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends State<_TabButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isActive
                ? const Color(0xFF3B82F6)
                : _isHovered
                    ? const Color(0xFFF1F5F9)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: widget.isActive
                  ? Colors.white
                  : _isHovered
                      ? const Color(0xFF1E293B)
                      : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }
}
