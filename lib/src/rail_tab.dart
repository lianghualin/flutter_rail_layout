import 'package:flutter/material.dart';

/// Represents a tab in the [HorizontalRailLayout].
///
/// Each tab contains metadata for both the tab bar display and the page header.
class RailTab {
  /// The short label displayed in the tab bar.
  final String label;

  /// The title displayed in the top-left header when this tab is active.
  final String pageTitle;

  /// The subtitle displayed below the page title.
  final String subtitle;

  /// The icon displayed in the tab bar.
  final IconData icon;

  /// The widget to display as the page content.
  final Widget page;

  /// Optional gradient for the page background.
  /// If not provided, a default gradient will be used.
  final Gradient? gradient;

  /// Creates a [RailTab] with the specified properties.
  const RailTab({
    required this.label,
    required this.pageTitle,
    required this.subtitle,
    required this.icon,
    required this.page,
    this.gradient,
  });
}
