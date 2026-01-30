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
      title: 'Flutter Rail Layout Example',
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
          label: 'Topology',
          pageTitle: 'Network Topology',
          subtitle: 'Industrial control network visualization',
          icon: Icons.hub_outlined,
          page: PlaceholderBox(text: 'Topology Chart Area'),
        ),
        RailTab(
          label: 'Monitoring',
          pageTitle: 'Real-time Monitoring',
          subtitle: 'Device status and traffic monitoring',
          icon: Icons.monitor_heart_outlined,
          page: MonitoringPage(),
        ),
        RailTab(
          label: 'Analytics',
          pageTitle: 'Data Analytics',
          subtitle: 'Traffic analysis and trend insights',
          icon: Icons.analytics_outlined,
          page: AnalyticsPage(),
        ),
        RailTab(
          label: 'Reports',
          pageTitle: 'System Reports',
          subtitle: 'Generate and export detailed reports',
          icon: Icons.assessment_outlined,
          page: ReportsPage(),
        ),
        RailTab(
          label: 'Settings',
          pageTitle: 'System Settings',
          subtitle: 'Security policies and system configuration',
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

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CardsGrid(
      cards: [
        InfoCard(
          title: 'Device Status',
          content: '128 devices online, 3 offline',
        ),
        InfoCard(
          title: 'Network Traffic',
          content: 'Inbound 2.4 GB/s, Outbound 1.8 GB/s',
        ),
        InfoCard(
          title: 'Alert Statistics',
          content: '12 alerts today, 9 resolved',
        ),
        InfoCard(
          title: 'System Load',
          content: 'CPU 45%, Memory 62%, Disk 38%',
        ),
      ],
    );
  }
}

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CardsGrid(
      cards: [
        InfoCard(
          title: 'Traffic Trends',
          content: 'Weekly traffic up 15%, peak hours 9AM-11AM',
        ),
        InfoCard(
          title: 'Protocol Distribution',
          content: 'HTTP 45%, HTTPS 38%, MQTT 12%, Other 5%',
        ),
        InfoCard(
          title: 'Anomaly Detection',
          content: '3 anomalies detected this week, all resolved',
        ),
        InfoCard(
          title: 'Performance Metrics',
          content: 'Avg latency 12ms, 99.9% uptime this month',
        ),
      ],
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CardsGrid(
      cards: [
        InfoCard(
          title: 'Daily Summary',
          content: 'Automated daily reports sent at 6:00 AM',
        ),
        InfoCard(
          title: 'Security Audit',
          content: 'Last audit: Jan 28, 2026. Next: Feb 28, 2026',
        ),
        InfoCard(
          title: 'Compliance Report',
          content: 'ISO 27001 compliant, certificate valid until 2027',
        ),
        InfoCard(
          title: 'Export Options',
          content: 'PDF, CSV, and Excel formats available',
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
          title: 'Access Control',
          content: 'Configure network access rules and whitelist policies',
        ),
        InfoCard(
          title: 'Alert Rules',
          content: 'Set alert thresholds and notification methods',
        ),
        InfoCard(
          title: 'Data Backup',
          content: 'Configure automatic backup schedules and storage',
        ),
        InfoCard(
          title: 'User Management',
          content: 'Manage user accounts and permissions',
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
