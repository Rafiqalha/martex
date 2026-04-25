import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../history/growth_history_screen.dart'; // Pengganti Map Nasional
import '../input/input_screen.dart';
import '../nutrition/smart_nutrition_screen.dart';
import '../profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const GrowthHistoryScreen(), // Melihat grafik pertumbuhan anak
    const InputScreen(),
    const SmartNutritionScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_rounded, "Beranda", 0),
            _navItem(Icons.auto_graph_rounded, "Grafik", 1),
            _mainFab(),
            _navItem(Icons.restaurant_menu_rounded, "Nutrisi", 3),
            _navItem(Icons.person_rounded, "Profil", 4),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool active = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: active ? const Color(0xFF10B981).withAlpha(25) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: active ? const Color(0xFF10B981) : Colors.grey[400], size: 26),
          ),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: active ? const Color(0xFF10B981) : Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _mainFab() {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Container(
        height: 60, width: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF10B981),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: const Color(0xFF10B981).withAlpha(100), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 35),
      ),
    );
  }
}