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
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (Navigator.canPop(context))
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.onSurface),
                            ),
                          ),
                        Text(
                          "Grafik Tumbuh",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Pantau perkembangan si kecil secara akurat",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        _buildToggleBtn("Berat Badan", _showWeight, () => setState(() => _showWeight = true), theme),
                        const SizedBox(width: 15),
                        _buildToggleBtn("Tinggi Badan", !_showWeight, () => setState(() => _showWeight = false), theme),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: _data.isEmpty
                        ? Center(
                            child: Text(
                              "Belum ada data pertumbuhan",
                              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 250,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 30, left: 10),
                                  child: LineChart(_mainData(theme)),
                                ),
                              ),
                              const SizedBox(height: 40),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                                    border: Border(
                                      top: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(20),
                                        blurRadius: 20,
                                        offset: const Offset(0, -5),
                                      ),
                                    ],
                                  ),
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.only(top: 30, left: 25, right: 25, bottom: 100),
                                    itemCount: _data.length,
                                    itemBuilder: (context, i) => _buildLogTile(_data[i], theme),
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildToggleBtn(String label, bool active, VoidCallback onTap, ThemeData theme) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? theme.colorScheme.primary : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? Colors.transparent : theme.colorScheme.outlineVariant,
              width: 1
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(80),
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
                color: active ? Colors.white : theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  LineChartData _mainData(ThemeData theme) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: _showWeight ? 5 : 20,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: theme.colorScheme.outlineVariant,
            strokeWidth: 1,
            dashArray: [5, 5],
          );
        },
      ),
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
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
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
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
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
          color: theme.colorScheme.primary,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 6,
                color: theme.colorScheme.primary,
                strokeWidth: 3,
                strokeColor: theme.colorScheme.surface,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withAlpha(80),
                theme.colorScheme.primary.withAlpha(0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogTile(Measurement m, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.calendar_today_rounded, color: theme.colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Usia ${m.age} Bulan",
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "Z-Score: ${m.zScore.toStringAsFixed(2)}",
                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (m.isSynced == 1) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.cloud_done_rounded, size: 12, color: theme.colorScheme.secondary),
                      ]
                    ],
                  ),
                ],
              ),
            ],
          ),
          Text(
            _showWeight ? "${m.weight} kg" : "${m.height} cm",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900, 
              color: theme.colorScheme.primary
            ),
          ),
        ],
      ),
    );
  }
}