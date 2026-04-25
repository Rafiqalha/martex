import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../history/growth_history_screen.dart';
import '../input/input_screen.dart';
import '../nutrition/nutrition_screen.dart';
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
    const GrowthHistoryScreen(),
    const InputScreen(),
    const NutritionRecommendationScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15), 
              blurRadius: 20, 
              offset: const Offset(0, -5),
            )
          ],
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
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: active ? const Color(0xFF10B981).withAlpha(30) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon, 
              color: active ? const Color(0xFF10B981) : const Color(0xFF94A3B8), 
              size: 26,
            ),
          ),
          Text(
            label, 
            style: TextStyle(
              fontSize: 10, 
              fontWeight: FontWeight.bold, 
              color: active ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainFab() {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Transform.translate(
        offset: const Offset(0, -15),
        child: Container(
          height: 60, 
          width: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withAlpha(80), 
                blurRadius: 15, 
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 35),
        ),
      ),
    );
  }
}