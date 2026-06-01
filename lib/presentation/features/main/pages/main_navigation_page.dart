// lib/presentation/features/main/pages/main_navigation_page.dart
import 'package:flutter/material.dart';
import 'package:mechanic_app/core/constants/asset_paths.dart';
import 'package:mechanic_app/presentation/features/ticket/pages/ticket_dashboard_page.dart';
import 'package:mechanic_app/presentation/features/ticket/pages/ticket_history_page.dart'; // <-- Baris Impor Baru
import 'package:mechanic_app/presentation/features/profile/pages/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  final String mechanicId;

  const MainNavigationPage({super.key, required this.mechanicId});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      TicketDashboardPage(mechanicId: widget.mechanicId),
      TicketHistoryPage(mechanicId: widget.mechanicId), // <-- Mengganti placeholder dengan halaman riwayat asli
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        indicatorColor: Colors.blue.shade100,
        backgroundColor: Colors.white,
        elevation: 8,
        destinations: const [
          NavigationDestination(
            selectedIcon: _SafeNavigationIcon(assetPath: AssetPaths.icTicket, fallbackIcon: Icons.assignment_rounded, isActive: true),
            icon: _SafeNavigationIcon(assetPath: AssetPaths.icTicket, fallbackIcon: Icons.assignment_outlined, isActive: false),
            label: 'Tugas Aktif',
          ),
          NavigationDestination(
            selectedIcon: _SafeNavigationIcon(assetPath: AssetPaths.icCalendar, fallbackIcon: Icons.history_toggle_off_rounded, isActive: true),
            icon: _SafeNavigationIcon(assetPath: AssetPaths.icCalendar, fallbackIcon: Icons.history_rounded, isActive: false),
            label: 'Riwayat',
          ),
          NavigationDestination(
            selectedIcon: _SafeNavigationIcon(assetPath: AssetPaths.icPerson, fallbackIcon: Icons.account_circle_rounded, isActive: true),
            icon: _SafeNavigationIcon(assetPath: AssetPaths.icPerson, fallbackIcon: Icons.account_circle_outlined, isActive: false),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _SafeNavigationIcon extends StatelessWidget {
  final String assetPath;
  final IconData fallbackIcon;
  final bool isActive;

  const _SafeNavigationIcon({
    required this.assetPath,
    required this.fallbackIcon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = Colors.blue.shade800;
    final inactiveColor = Colors.blueGrey.shade600;
    
    return Image.asset(
      assetPath,
      height: 24,
      width: 24,
      color: isActive ? activeColor : inactiveColor,
      errorBuilder: (context, error, stackTrace) {
        return Icon(fallbackIcon, color: isActive ? activeColor : inactiveColor);
      },
    );
  }
}