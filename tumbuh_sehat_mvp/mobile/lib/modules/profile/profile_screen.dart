import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _build3DMenuCard({required IconData icon, required String title, required String subtitle, Color? iconColor, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10), // Efek 3D shadow lembut
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (iconColor ?? const Color(0xFF10B981)).withAlpha(25),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: iconColor ?? const Color(0xFF10B981), size: 26),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: title == "Keluar Akun" ? const Color(0xFFEF4444) : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[300], size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(50), // Efek Glassmorphism
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withAlpha(100), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header Eksklusif dengan Gradien 3D
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 70, left: 25, right: 25, bottom: 40),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withAlpha(100),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar 3D
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFFE2E8F0),
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=47'), // Gambar dummy eksklusif
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Siti Aminah",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "⭐ Kader Posyandu Utama",
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Statistik Kader
                  Row(
                    children: [
                      _buildStatBadge("142", "Data Balita", Icons.child_care_rounded),
                      const SizedBox(width: 15),
                      _buildStatBadge("Level 4", "Reputasi", Icons.military_tech_rounded),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Menu Interaktif
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pusat Komando",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 15),
                  _build3DMenuCard(
                    icon: Icons.download_rounded,
                    title: "Ekspor Laporan (PDF)",
                    subtitle: "Unduh data bulan ini untuk Dinas",
                    iconColor: const Color(0xFF3B82F6), // Biru Profesional
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mempersiapkan dokumen PDF...")));
                    },
                  ),
                  _build3DMenuCard(
                    icon: Icons.bluetooth_connected_rounded,
                    title: "Hubungkan Timbangan",
                    subtitle: "Integrasi IoT Bluetooth",
                    iconColor: const Color(0xFF8B5CF6), // Ungu Teknologi
                    onTap: () {},
                  ),
                  _build3DMenuCard(
                    icon: Icons.shield_rounded,
                    title: "Privasi & Keamanan",
                    subtitle: "Atur PIN dan enkripsi data lokal",
                    iconColor: const Color(0xFFF59E0B), // Oranye Keamanan
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Sistem",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 15),
                  _build3DMenuCard(
                    icon: Icons.support_agent_rounded,
                    title: "Bantuan & Panduan",
                    subtitle: "Hubungi tim support TumbuhSehat",
                    iconColor: const Color(0xFF64748B),
                    onTap: () {},
                  ),
                  _build3DMenuCard(
                    icon: Icons.logout_rounded,
                    title: "Keluar Akun",
                    subtitle: "Hapus sesi perangkat ini",
                    iconColor: const Color(0xFFEF4444), // Merah Bahaya
                    onTap: () {},
                  ),
                  const SizedBox(height: 40),
                  // Watermark versi
                  Center(
                    child: Text(
                      "TumbuhSehat v1.0.0 (MVP)\nSistem Cerdas Gizi Nasional",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 100), // Spasi untuk Bottom Navbar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}