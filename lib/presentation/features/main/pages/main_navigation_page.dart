// lib/presentation/features/main/pages/main_navigation_page.dart
import 'package:flutter/material.dart';
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
      const _HistoryPlaceholderPage(), // Menu Riwayat Kerja
      const ProfilePage(),             // Menu Profil & Keluar Aplikasi
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
            selectedIcon: Icon(Icons.assignment_rounded, color: Colors.blue),
            icon: Icon(Icons.assignment_outlined),
            label: 'Tugas Aktif',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.history_toggle_off_rounded, color: Colors.blue),
            icon: Icon(Icons.history_rounded),
            label: 'Riwayat',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle_rounded, color: Colors.blue),
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

/// Placeholder halaman Riwayat Kerja untuk menjaga kelengkapan arsitektur sistem
class _HistoryPlaceholderPage extends StatelessWidget {
  const _HistoryPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
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
            Text(
              'Belum Ada Riwayat Selesai',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              'Tiket yang Anda selesaikan akan muncul di sini.',
              style: TextStyle(fontSize: 13, color: const Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}