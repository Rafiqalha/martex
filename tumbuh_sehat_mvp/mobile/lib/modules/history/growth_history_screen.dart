import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/local_db.dart';
import '../../models/measurement.dart';

class GrowthHistoryScreen extends StatefulWidget {
  const GrowthHistoryScreen({super.key});

  @override
  State<GrowthHistoryScreen> createState() => _GrowthHistoryScreenState();
}

class _GrowthHistoryScreenState extends State<GrowthHistoryScreen> {
  List<Measurement> _data = [];
  bool _isLoading = true;
  bool _showWeight = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final results = await LocalDatabase.instance.getAllMeasurements();
    if (mounted) {
      setState(() {
        _data = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color darkGreen = Color(0xFF064E3B);
    const Color emerald = Color(0xFF10B981);
    const Color lightEmerald = Color(0xFF34D399);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [darkGreen, emerald, lightEmerald],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Grafik Tumbuh",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Pantau perkembangan si kecil secara akurat",
                            style: TextStyle(
                              color: Colors.white.withAlpha(180),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        children: [
                          _buildToggleBtn("Berat Badan", _showWeight, () => setState(() => _showWeight = true)),
                          const SizedBox(width: 15),
                          _buildToggleBtn("Tinggi Badan", !_showWeight, () => setState(() => _showWeight = false)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: _data.isEmpty
                          ? const Center(
                              child: Text(
                                "Belum ada data pertumbuhan",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 250,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 30, left: 10),
                                    child: LineChart(_mainData()),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Expanded(
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(horizontal: 25),
                                    itemCount: _data.length,
                                    itemBuilder: (context, i) => _buildLogTile(_data[i]),
                                  ),
                                )
                              ],
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildToggleBtn(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white.withAlpha(50),
            borderRadius: BorderRadius.circular(20),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(30),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: active ? const Color(0xFF065F46) : Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  LineChartData _mainData() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < _data.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "${_data[value.toInt()].age}B",
                    style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: _data.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), _showWeight ? e.value.weight : e.value.height);
          }).toList(),
          isCurved: true,
          color: Colors.white,
          barWidth: 6,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 6,
                color: Colors.white,
                strokeWidth: 3,
                strokeColor: const Color(0xFF10B981),
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.white.withAlpha(80),
                Colors.white.withAlpha(0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogTile(Measurement m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(40),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withAlpha(60), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Usia ${m.age} Bulan",
                    style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Z-Score: ${m.zScore.toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          Text(
            _showWeight ? "${m.weight} kg" : "${m.height} cm",
            style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}