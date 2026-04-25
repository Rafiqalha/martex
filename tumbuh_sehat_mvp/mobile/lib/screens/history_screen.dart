import 'package:flutter/material.dart';
import '../core/local_db.dart';
import '../models/measurement.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Measurement> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await LocalDatabase.instance.getAllMeasurements();
    setState(() {
      _history = data;
      _isLoading = false;
    });
  }

  Widget _buildTreeCard() {
    if (_history.isEmpty) {
      return _build3DCard(
        color: Colors.white,
        child: const Center(
          child: Text(
            "Belum ada data.\nUkur balita untuk menanam pohon!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final latestData = _history.first;
    bool isHealthy = latestData.zScore >= -2.0;

    return _build3DCard(
      color: isHealthy ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isHealthy ? Icons.park_rounded : Icons.nature_rounded,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHealthy ? "Pohon Tumbuh Lebat!" : "Pohon Butuh Nutrisi",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  isHealthy 
                      ? "Pertumbuhan sangat baik. Lanjutkan MPASI yang sehat." 
                      : "Deteksi risiko stunting. Segera temui kader posyandu.",
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBadges() {
    int count = _history.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _build3DBadge("Perunggu", count >= 1, Colors.brown[400]!),
        _build3DBadge("Perak", count >= 3, Colors.blueGrey[300]!),
        _build3DBadge("Emas", count >= 5, Colors.amber[400]!),
      ],
    );
  }

  Widget _build3DBadge(String title, bool isUnlocked, Color badgeColor) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: isUnlocked ? badgeColor : Colors.grey[200],
            shape: BoxShape.circle,
            boxShadow: isUnlocked
                ? [
                    BoxShadow(
                      color: badgeColor.withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                    const BoxShadow(
                      color: Colors.white54,
                      blurRadius: 2,
                      offset: Offset(0, -3),
                      spreadRadius: -1,
                    )
                  ]
                : [],
          ),
          child: Icon(
            isUnlocked ? Icons.star_rounded : Icons.lock_rounded,
            color: isUnlocked ? Colors.white : Colors.grey[400],
            size: 35,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isUnlocked ? const Color(0xFF0F172A) : Colors.grey,
          ),
        ),
      ],
    );
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
            color: color.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final data = _history[index];
        final isHealthy = data.zScore >= -2.0;
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isHealthy ? const Color(0xFF10B981).withOpacity(0.1) : const Color(0xFFEF4444).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                isHealthy ? Icons.arrow_upward_rounded : Icons.warning_rounded,
                color: isHealthy ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              ),
            ),
            title: Text(
              "Usia: ${data.age} Bulan",
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
            subtitle: Text(
              "BB: ${data.weight} kg | TB: ${data.height} cm",
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            trailing: Text(
              data.zScore.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: isHealthy ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Rapor Tumbuh",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: _loadHistory,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTreeCard(),
              const SizedBox(height: 35),
              const Text(
                "Lencana Pencapaian",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 20),
              _buildBadges(),
              const SizedBox(height: 35),
              const Text(
                "Riwayat Pengukuran",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 15),
              _buildHistoryList(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}