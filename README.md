# Flutter Rail Layout

A Flutter package for creating horizontal rail layouts with animated floating tab bars featuring anchored expansion animation.

## Features

- **Floating Tab Bar**: A beautiful floating tab bar centered at the top of the screen
- **Anchored Expansion Animation**: When hovering, the tab bar expands with the hovered tab staying fixed in place
- **Page Title & Subtitle**: Automatic header with page title and subtitle that updates based on the current tab
- **Swipeable Pages**: Support for swipe gestures and keyboard navigation
- **Customizable**: Extensive customization options for colors, styles, and animations

## Demo

![Demo](screenshots/demo.gif)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_rail_layout: ^1.0.0
```

## Usage

### Basic Usage

```dart
import 'package:flutter_rail_layout/flutter_rail_layout.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HorizontalRailLayout(
        tabs: [
          RailTab(
            label: 'Home',
            pageTitle: 'Dashboard',
            subtitle: 'Welcome back',
            icon: Icons.home,
            page: HomePage(),
          ),
          RailTab(
            label: 'Settings',
            pageTitle: 'Settings',
            subtitle: 'Configure your app',
            icon: Icons.settings,
            page: SettingsPage(),
          ),
        ],
      ),
    );
  }
}
```

### With Custom Options

```dart
HorizontalRailLayout(
  tabs: myTabs,
  initialIndex: 0,
  onPageChanged: (index) {
    print('Page changed to: $index');
  },
  enableKeyboardNavigation: true,
  pageTransitionDuration: Duration(milliseconds: 500),
  pageTransitionCurve: Curves.easeOutCubic,
  headerPadding: EdgeInsets.fromLTRB(40, 20, 40, 20),
  contentPadding: EdgeInsets.fromLTRB(40, 100, 40, 40),
  tabBarActiveColor: Colors.blue,
  tabBarInactiveColor: Colors.grey,
)
```

### RailTab Properties

| Property | Type | Description |
|----------|------|-------------|
| `label` | `String` | Short label displayed in the tab bar |
| `pageTitle` | `String` | Title displayed in the top-left header |
| `subtitle` | `String` | Subtitle displayed below the page title |
| `icon` | `IconData` | Icon displayed in the tab bar |
| `page` | `Widget` | The widget to display as page content |
| `gradient` | `Gradient?` | Optional custom gradient for page background |

### HorizontalRailLayout Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `tabs` | `List<RailTab>` | required | List of tabs to display |
| `initialIndex` | `int` | `0` | Initial page index |
| `onPageChanged` | `ValueChanged<int>?` | `null` | Callback when page changes |
| `enableKeyboardNavigation` | `bool` | `true` | Enable arrow key navigation |
| `pageTransitionDuration` | `Duration` | `500ms` | Page transition duration |
| `pageTransitionCurve` | `Curve` | `easeOutCubic` | Page transition curve |
| `headerPadding` | `EdgeInsets` | `EdgeInsets.fromLTRB(40, 20, 40, 20)` | Header area padding |
| `contentPadding` | `EdgeInsets` | `EdgeInsets.fromLTRB(40, 100, 40, 40)` | Page content padding |
| `pageTitleStyle` | `TextStyle?` | `null` | Custom style for page title |
| `subtitleStyle` | `TextStyle?` | `null` | Custom style for subtitle |
| `tabBarBackgroundColor` | `Color` | `white` | Tab bar background |
| `tabBarBorderColor` | `Color` | `#E2E8F0` | Tab bar border |
| `tabBarActiveColor` | `Color` | `#3B82F6` | Active tab color |
| `tabBarInactiveColor` | `Color` | `#64748B` | Inactive tab color |
| `tabBarActiveTextColor` | `Color` | `white` | Active tab text color |

## Animation Behavior

### Anchored Expansion

The tab bar features a unique "anchored expansion" animation:

1. **Collapsed State**: When not hovered, the tab bar shows only icons
2. **Hover Detection**: When the cursor enters the tab bar, it detects which tab is being hovered
3. **Anchored Animation**: The hovered tab stays fixed in place while the others expand outward
4. **Smooth Transition**: Uses `easeOutCubic` curve for natural-feeling animations

This creates a visually pleasing effect where the user's focus point (the cursor) remains stable while the UI expands around it.

## License

MIT License - see the [LICENSE](LICENSE) file for details.
