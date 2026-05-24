import 'package:flutter/material.dart';
import 'package:mechanic_app/core/constants/asset_paths.dart';
import 'package:mechanic_app/presentation/features/ticket/pages/ticket_dashboard_page.dart';
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
      const _HistoryPlaceholderPage(),
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

/// Widget dekorator untuk merender berkas ikon statis dengan skema jaminan safety fallback.
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
      // Jika pustaka SVG belum di-load atau berkas belum ada, render Icon dasar tanpa error crash
      errorBuilder: (context, error, stackTrace) {
        return Icon(fallbackIcon, color: isActive ? activeColor : inactiveColor);
      },
    );
  }
}

class _HistoryPlaceholderPage extends StatelessWidget {
  const _HistoryPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('RIWAYAT PENGERJAAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, size: 64, color: Colors.blueGrey.shade300),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Riwayat Selesai',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tiket yang Anda selesaikan akan muncul di sini.',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}