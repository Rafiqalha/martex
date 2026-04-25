import 'package:flutter/material.dart';
import '../../core/local_db.dart';
import '../../core/api_client.dart';
import '../../models/measurement.dart';
import '../nutrition/nutrition_screen.dart';
import '../history/growth_history_screen.dart';
import '../map/map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Measurement? _latestData;
  bool _isLoading = true;
  bool _isSyncing = false;
  int _unsyncedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await LocalDatabase.instance.getAllMeasurements();
      final unsynced = await LocalDatabase.instance.getUnsyncedMeasurements();
      if (mounted) {
        setState(() {
          _latestData = data.isNotEmpty ? data.first : null;
          _unsyncedCount = unsynced.length;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSync() async {
    if (_unsyncedCount == 0) return;
    
    setState(() => _isSyncing = true);
    final success = await ApiClient.syncData();
    
    if (mounted) {
      setState(() => _isSyncing = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil disinkronisasi ke Cloud ✓")),
        );
        _loadData(); // Reload to update unsynced count
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal sinkronisasi. Periksa koneksi internet."),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Selamat Pagi";
    if (hour < 15) return "Selamat Siang";
    if (hour < 18) return "Selamat Sore";
    return "Selamat Malam";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surface,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                          Text(
                            "${_getGreeting()}, Bunda!",
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),
                          ),
                          Text(
                            "Pantau Si Kecil",
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (_unsyncedCount > 0)
                            GestureDetector(
                              onTap: _handleSync,
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary.withAlpha(20),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: theme.colorScheme.secondary),
                                ),
                                child: Row(
                                  children: [
                                    _isSyncing 
                                      ? SizedBox(
                                          width: 12, height: 12, 
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2, 
                                            color: theme.colorScheme.secondary
                                          )
                                        )
                                      : Icon(Icons.cloud_upload_rounded, 
                                          size: 14, color: theme.colorScheme.secondary),
                                    const SizedBox(width: 6),
                                    Text("$_unsyncedCount", 
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary, 
                                        fontWeight: FontWeight.bold, fontSize: 12
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: theme.colorScheme.primary, width: 2),
                            ),
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : _latestData == null 
                      ? _buildEmptyCard(theme)
                      : _buildDataCard(theme),
                ),
                const SizedBox(height: 35),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 35, left: 24, right: 24, bottom: 100),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rangkuman Medis",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFeatureCard(
                        theme: theme,
                        icon: Icons.analytics_rounded,
                        title: "Grafik Pertumbuhan",
                        subtitle: "Lihat tren Z-Score",
                        color: theme.colorScheme.primary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const GrowthHistoryScreen()),
                          );
                        },
                      ),
                      _buildFeatureCard(
                        theme: theme,
                        icon: Icons.auto_awesome_rounded,
                        title: "Rekomendasi Nutrisi AI",
                        subtitle: "Menu mingguan personal",
                        color: theme.colorScheme.tertiary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NutritionRecommendationScreen()),
                          );
                        },
                      ),
                      _buildFeatureCard(
                        theme: theme,
                        icon: Icons.map_rounded,
                        title: "Peta Stunting 2024",
                        subtitle: "Sebaran SSGI Nasional",
                        color: theme.colorScheme.secondary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MapScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(Icons.child_friendly_rounded, size: 50, color: theme.colorScheme.primary.withAlpha(100)),
          const SizedBox(height: 16),
          Text(
            "Belum ada data",
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Mulai pantau pertumbuhan si kecil\ndengan menekan tombol + di bawah.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard(ThemeData theme) {
    final statusText = _latestData!.zScore >= -2.0 ? "Normal" : "Perlu Perhatian";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withAlpha(200),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(80),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _latestData!.gender == 'L' ? Icons.boy_rounded : Icons.girl_rounded, 
                  color: Colors.white
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Si Kecil",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("${_latestData!.age} Bulan",
                      style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
              const Spacer(),
              if (_latestData!.isSynced == 1)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.cloud_done_rounded, color: Colors.white, size: 16),
                )
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickStat("Tinggi", _latestData!.height.toStringAsFixed(1), "cm"),
              _buildQuickStat("Berat", _latestData!.weight.toStringAsFixed(1), "kg"),
              _buildQuickStat("Status", statusText, "", colorOverride: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, String unit, {Color? colorOverride}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value,
                style: TextStyle(
                  color: colorOverride ?? Colors.white, 
                  fontSize: 20, 
                  fontWeight: FontWeight.w900
                )
            ),
            if (unit.isNotEmpty) const SizedBox(width: 2),
            if (unit.isNotEmpty) Text(unit, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: theme.colorScheme.outline),
          ],
        ),
      ),
    );
  }
}