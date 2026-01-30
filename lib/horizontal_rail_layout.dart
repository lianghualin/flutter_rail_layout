import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/floating_tab_bar.dart';
import 'widgets/info_card.dart';
import 'widgets/placeholder_box.dart';

class HorizontalRailLayout extends StatefulWidget {
  const HorizontalRailLayout({super.key});

  @override
  State<HorizontalRailLayout> createState() => _HorizontalRailLayoutState();
}

class _HorizontalRailLayoutState extends State<HorizontalRailLayout> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<TabItem> _tabs = const [
    TabItem(
      title: 'Topology',
      pageTitle: 'Network Topology',
      subtitle: 'Industrial control network visualization',
      icon: Icons.hub_outlined,
    ),
    TabItem(
      title: 'Monitoring',
      pageTitle: 'Real-time Monitoring',
      subtitle: 'Device status and traffic monitoring',
      icon: Icons.monitor_heart_outlined,
    ),
    TabItem(
      title: 'Settings',
      pageTitle: 'System Settings',
      subtitle: 'Security policies and system configuration',
      icon: Icons.settings_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic, // Similar to cubic-bezier(0.4, 0, 0.2, 1)
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft && _currentPage > 0) {
        _goToPage(_currentPage - 1);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight && _currentPage < 2) {
        _goToPage(_currentPage + 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        body: Stack(
          children: [
            // Page View (Rail)
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              children: [
                _buildPage1(),
                _buildPage2(),
                _buildPage3(),
              ],
            ),

            // Header Bar with Title and Tabs
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildHeaderBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBar() {
    final currentTab = _tabs[_currentPage];

    return Container(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left: Page Title and Subtitle
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentTab.pageTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentTab.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          // Center: Tab Bar
          FloatingTabBar(
            tabs: _tabs,
            currentIndex: _currentPage,
            onTabSelected: _goToPage,
          ),
        ],
      ),
    );
  }

  // Page 1: Network Topology
  Widget _buildPage1() {
    return _PageContainer(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE0F2FE), Color(0xFFF8FAFC)],
      ),
      child: const PlaceholderBox(text: 'Topology Chart Area'),
    );
  }

  // Page 2: Real-time Monitoring
  Widget _buildPage2() {
    return _PageContainer(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFD1FAE5), Color(0xFFF8FAFC)],
      ),
      child: _buildCardsGrid([
        const InfoCard(
          title: 'Device Status',
          content: '128 devices online, 3 offline',
        ),
        const InfoCard(
          title: 'Network Traffic',
          content: 'Inbound 2.4 GB/s, Outbound 1.8 GB/s',
        ),
        const InfoCard(
          title: 'Alert Statistics',
          content: '12 alerts today, 9 resolved',
        ),
        const InfoCard(
          title: 'System Load',
          content: 'CPU 45%, Memory 62%, Disk 38%',
        ),
      ]),
    );
  }

  // Page 3: System Settings
  Widget _buildPage3() {
    return _PageContainer(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF3E8FF), Color(0xFFF8FAFC)],
      ),
      child: _buildCardsGrid([
        const InfoCard(
          title: 'Access Control',
          content: 'Configure network access rules and whitelist policies',
        ),
        const InfoCard(
          title: 'Alert Rules',
          content: 'Set alert thresholds and notification methods',
        ),
        const InfoCard(
          title: 'Data Backup',
          content: 'Configure automatic backup schedules and storage',
        ),
        const InfoCard(
          title: 'User Management',
          content: 'Manage user accounts and permissions',
        ),
      ]),
    );
  }

  Widget _buildCardsGrid(List<Widget> cards) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate columns based on available width
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

// Page Container with gradient background
class _PageContainer extends StatelessWidget {
  final Gradient gradient;
  final Widget child;

  const _PageContainer({
    required this.gradient,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      padding: const EdgeInsets.fromLTRB(40, 100, 40, 40),
      child: child,
    );
  }
}
