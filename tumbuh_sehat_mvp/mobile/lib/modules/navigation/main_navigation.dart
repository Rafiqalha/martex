import 'package:flutter/material.dart';

// Pastikan file-file ini benar-benar ada di dalam folder tersebut!
import '../home/home_screen.dart';
import '../map/map_screen.dart';
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
    const MapScreen(),
    const InputScreen(),
    const SmartNutritionScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15), // Mengganti .withOpacity(0.05)
              blurRadius: 20, 
              offset: const Offset(0, -5)
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.dashboard_rounded, 0),
            _navItem(Icons.map_rounded, 1),
            _mainFab(),
            _navItem(Icons.energy_savings_leaf_rounded, 3),
            _navItem(Icons.person_rounded, 4),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    bool active = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF10B981).withAlpha(25) : Colors.transparent, // .withOpacity(0.1)
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon, 
          color: active ? const Color(0xFF10B981) : Colors.grey[400], 
          size: 28
        ),
      ),
    );
  }

  Widget _mainFab() {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          color: const Color(0xFF10B981),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withAlpha(100), // .withOpacity(0.4)
              blurRadius: 15, 
              offset: const Offset(0, 8)
            ),
            const BoxShadow(
              color: Colors.white24, 
              blurRadius: 2, 
              offset: Offset(0, -3), 
              spreadRadius: -1
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 35),
      ),
    );
  }
}