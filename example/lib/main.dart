import 'package:flutter/material.dart';
import 'package:flutter_rail_layout/flutter_rail_layout.dart';
import 'widgets/info_card.dart';
import 'widgets/placeholder_box.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Rail Layout Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'SF Pro Display',
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF3B82F6),
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xFF1E293B),
        ),
      ),
      home: const ExampleLayout(),
    );
  }
}

class ExampleLayout extends StatelessWidget {
  const ExampleLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return HorizontalRailLayout(
      tabs: const [
        RailTab(
          label: 'Home',
          pageTitle: 'Home',
          subtitle: 'Welcome to the app',
          icon: Icons.home_outlined,
          page: PlaceholderBox(text: 'Home Content'),
        ),
        RailTab(
          label: 'Dashboard',
          pageTitle: 'Dashboard',
          subtitle: 'Overview and statistics',
          icon: Icons.dashboard_outlined,
          page: DashboardPage(),
        ),
        RailTab(
          label: 'Projects',
          pageTitle: 'Projects',
          subtitle: 'Manage your projects',
          icon: Icons.folder_outlined,
          page: ProjectsPage(),
        ),
        RailTab(
          label: 'Messages',
          pageTitle: 'Messages',
          subtitle: 'Your conversations',
          icon: Icons.message_outlined,
          page: MessagesPage(),
        ),
        RailTab(
          label: 'Settings',
          pageTitle: 'Settings',
          subtitle: 'App configuration',
          icon: Icons.settings_outlined,
          page: SettingsPage(),
        ),
      ],
      onPageChanged: (index) {
        debugPrint('Page changed to: $index');
      },
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CardsGrid(
      cards: [
        InfoCard(
          title: 'Total Users',
          content: '1,234 active users this month',
        ),
        InfoCard(
          title: 'Revenue',
          content: '\$12,345 total revenue',
        ),
        InfoCard(
          title: 'Tasks',
          content: '42 tasks completed today',
        ),
        InfoCard(
          title: 'Performance',
          content: '99.9% uptime this month',
        ),
      ],
    );
  }
}

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CardsGrid(
      cards: [
        InfoCard(
          title: 'Active Projects',
          content: '8 projects in progress',
        ),
        InfoCard(
          title: 'Completed',
          content: '24 projects completed',
        ),
        InfoCard(
          title: 'Team Members',
          content: '12 members assigned',
        ),
        InfoCard(
          title: 'Deadlines',
          content: '3 deadlines this week',
        ),
      ],
    );
  }
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CardsGrid(
      cards: [
        InfoCard(
          title: 'Inbox',
          content: '5 unread messages',
        ),
        InfoCard(
          title: 'Sent',
          content: '12 messages sent today',
        ),
        InfoCard(
          title: 'Drafts',
          content: '3 drafts saved',
        ),
        InfoCard(
          title: 'Archived',
          content: '128 archived messages',
        ),
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CardsGrid(
      cards: [
        InfoCard(
          title: 'Profile',
          content: 'Manage your account settings',
        ),
        InfoCard(
          title: 'Notifications',
          content: 'Configure alert preferences',
        ),
        InfoCard(
          title: 'Privacy',
          content: 'Control your data sharing',
        ),
        InfoCard(
          title: 'Theme',
          content: 'Customize appearance',
        ),
      ],
    );
  }
}

class CardsGrid extends StatelessWidget {
  final List<Widget> cards;

  const CardsGrid({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = (constraints.maxWidth / 300).floor().clamp(1, 4);

        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.4,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) => cards[index],
        );
      },
    );
  }
}
