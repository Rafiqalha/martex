import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 70, left: 24, right: 24, bottom: 50),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF065F46), Color(0xFF10B981), Color(0xFF34D399)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withAlpha(80),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              image: const DecorationImage(
                                image: NetworkImage('https://i.pravatar.cc/150?img=47'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Selamat Bertugas,",
                                style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Kader Utama",
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(50),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.notifications_rounded, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    "Target Stunting Nasional",
                    style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Turunkan hingga 14%",
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withAlpha(80), width: 1),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Data Terkumpul", style: TextStyle(color: Colors.white, fontSize: 12)),
                            SizedBox(height: 4),
                            Text("142 Balita", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Status Wilayah", style: TextStyle(color: Colors.white, fontSize: 12)),
                            SizedBox(height: 4),
                            Text("Aman Terkendali", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Modul Sistem",
                style: TextStyle(color: Color(0xFF0F172A), fontSize: 20, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
                _buildMenuCard(
                  context,
                  "Smart AI\nNutrisi",
                  Icons.auto_awesome_rounded,
                  const Color(0xFF059669),
                ),
                _buildMenuCard(
                  context,
                  "Pemetaan\nSpasial",
                  Icons.map_rounded,
                  const Color(0xFF10B981),
                ),
                _buildMenuCard(
                  context,
                  "Sinkronisasi\nCloud",
                  Icons.cloud_sync_rounded,
                  const Color(0xFF34D399),
                ),
                _buildMenuCard(
                  context,
                  "Edukasi\nMasyarakat",
                  Icons.menu_book_rounded,
                  const Color(0xFF065F46),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Wawasan Cepat",
                style: TextStyle(color: Color(0xFF0F172A), fontSize: 20, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withAlpha(25),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(Icons.lightbulb_rounded, color: Color(0xFF10B981), size: 30),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Fokus 1000 Hari Pertama",
                            style: TextStyle(color: Color(0xFF0F172A), fontSize: 14, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Intervensi gizi sangat krusial pada masa kehamilan hingga anak berusia 2 tahun.",
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Akses modul $title dari Bottom Navigation Bar"),
            backgroundColor: const Color(0xFF0F172A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(20),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: color.withAlpha(50), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 15,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}