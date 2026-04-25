import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryDark = Color(0xFF0F2C46);
    const Color accentColor = Color(0xFF10B981);
    const Color lightCard = Color(0xFFF8FAFC);
    const Color warningColor = Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: primaryDark,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Halo, Ayah Bunda!",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const Text(
                          "Pantau Si Kecil",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: accentColor, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E40AF), Color(0xFF1E3A8A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.child_care_rounded, color: Colors.white),
                          ),
                          const SizedBox(width: 15),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Budi Santoso", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              Text("2 Tahun 4 Bulan", style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildQuickStat("Tinggi", "85.4", "cm"),
                          _buildQuickStat("Berat", "12.2", "kg"),
                          _buildQuickStat("Status", "Normal", ""),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 35),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 35, left: 24, right: 24, bottom: 100),
                decoration: const BoxDecoration(
                  color: lightCard,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rangkuman Nutrisi",
                      style: TextStyle(color: primaryDark, fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildFeatureCard(
                      icon: Icons.analytics_rounded,
                      title: "Grafik Pertumbuhan",
                      subtitle: "Lihat tren Z-Score bulan ke bulan",
                      color: primaryDark,
                    ),
                    _buildFeatureCard(
                      icon: Icons.restaurant_menu_rounded,
                      title: "Rekomendasi MPASI",
                      subtitle: "Menu tinggi protein hewani hari ini",
                      color: accentColor,
                    ),
                    _buildFeatureCard(
                      icon: Icons.event_note_rounded,
                      title: "Jadwal Posyandu",
                      subtitle: "12 Mei 2026 di Balai Desa",
                      color: warningColor,
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 65,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryDark,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_rounded, color: Colors.white),
                            SizedBox(width: 12),
                            Text(
                              "Scan Nutrisi AI",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, String unit) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(width: 2),
            Text(unit, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({required IconData icon, required String title, required String subtitle, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Color(0xFF0F2C46), fontSize: 15, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.black45, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.black26),
        ],
      ),
    );
  }
}