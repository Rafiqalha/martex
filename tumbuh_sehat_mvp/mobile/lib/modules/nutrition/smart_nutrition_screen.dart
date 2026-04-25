import 'package:flutter/material.dart';

// PERHATIKAN: Import telah diubah menjadi ../../ untuk naik 2 folder
import '../../core/local_db.dart';
import '../../models/measurement.dart';

class SmartNutritionScreen extends StatefulWidget {
  const SmartNutritionScreen({super.key});

  @override
  State<SmartNutritionScreen> createState() => _SmartNutritionScreenState();
}

class _SmartNutritionScreenState extends State<SmartNutritionScreen> {
  Measurement? _latestData;
  bool _isLoading = true;
  final List<bool> _checklist = [false, false, false]; // Ditambahkan 'final'

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await LocalDatabase.instance.getAllMeasurements();
    setState(() {
      if (data.isNotEmpty) {
        _latestData = data.first;
      }
      _isLoading = false;
    });
  }

  Map<String, dynamic> _getAIRecommendation(double zScore) {
    if (zScore >= -2.0) {
      return {
        "status": "Sehat Terkendali",
        "color": const Color(0xFF10B981),
        "icon": Icons.verified_rounded,
        "budget": "Rp 7.000 / Hari",
        "foods": [
          {"name": "1 Butir Telur Rebus", "benefit": "Protein dasar otak"},
          {"name": "Tahu/Tempe Goreng", "benefit": "Protein nabati tambahan"},
          {"name": "Sayur Bayam", "benefit": "Zat besi ringan"}
        ]
      };
    } else if (zScore >= -3.0) {
      return {
        "status": "Berisiko Stunting",
        "color": const Color(0xFFF59E0B),
        "icon": Icons.warning_rounded,
        "budget": "Rp 12.000 / Hari",
        "foods": [
          {"name": "2 Butir Telur (Pagi & Malam)", "benefit": "Booster protein hewani"},
          {"name": "Ati Ayam (1 Porsi)", "benefit": "Tinggi zat besi & cegah anemia"},
          {"name": "Nasi & Kuah Kaldu", "benefit": "Kalori padat"}
        ]
      };
    } else {
      return {
        "status": "Fase Stunting Kritis",
        "color": const Color(0xFFEF4444),
        "icon": Icons.emergency_rounded,
        "budget": "Rp 15.000 / Hari + PKM",
        "foods": [
          {"name": "Ikan Lele / Kembung", "benefit": "Omega 3 & Protein Tinggi"},
          {"name": "2 Butir Telur & Susu", "benefit": "Recovery massa otot"},
          {"name": "Puskesmas", "benefit": "Wajib ambil PMT (Roti Biskuit Kemenkes)"}
        ]
      };
    }
  }

  Widget _build3DCard({required Widget child, required Color color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(100), // Mengganti .withOpacity(0.4)
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withAlpha(50), // Mengganti .withOpacity(0.2)
            blurRadius: 2,
            offset: const Offset(0, -2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildChecklistItem(Map<String, String> food, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10), // Mengganti .withOpacity(0.04)
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _checklist[index] ? const Color(0xFF10B981) : Colors.transparent,
          width: 2,
        ),
      ),
      child: CheckboxListTile(
        value: _checklist[index],
        onChanged: (val) {
          setState(() {
            _checklist[index] = val ?? false;
          });
        },
        activeColor: const Color(0xFF10B981),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          food["name"]!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
            decoration: _checklist[index] ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(food["benefit"]!, style: const TextStyle(fontSize: 12)),
        secondary: const Icon(Icons.restaurant_rounded, color: Color(0xFF64748B)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_latestData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(title: const Text("AI Nutrisi")),
        body: const Center(child: Text("Data belum tersedia. Silakan ukur balita terlebih dahulu.", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
      );
    }

    final aiPlan = _getAIRecommendation(_latestData!.zScore);
    final foods = aiPlan["foods"] as List<Map<String, String>>;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Smart Nutrition AI", style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w900, fontSize: 22)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _build3DCard(
              color: aiPlan["color"],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white.withAlpha(50), borderRadius: BorderRadius.circular(12)), // Mengganti .withOpacity(0.2)
                        child: Icon(aiPlan["icon"], color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Status Medis", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                          Text(aiPlan["status"], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(color: Colors.black.withAlpha(38), borderRadius: BorderRadius.circular(10)), // Mengganti .withOpacity(0.15)
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Estimasi Budget Belanja", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text(aiPlan["budget"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tugas Nutrisi Hari Ini", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                Text("${_checklist.where((e) => e).length}/3 Selesai", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
              ],
            ),
            const SizedBox(height: 15),
            ...List.generate(foods.length, (index) => _buildChecklistItem(foods[index], index)),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  if (_checklist.where((e) => e).length == 3) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Luar biasa! Nutrisi harian terpenuhi.")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Selesaikan checklist nutrisi terlebih dahulu!")));
                  }
                },
                child: const Text("Kunci Jurnal Hari Ini", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}