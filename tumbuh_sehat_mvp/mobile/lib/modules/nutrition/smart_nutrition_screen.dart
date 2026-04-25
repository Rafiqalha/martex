import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../core/local_db.dart';
import '../../core/api_client.dart';
import '../../models/measurement.dart';

class SmartNutritionScreen extends StatefulWidget {
  const SmartNutritionScreen({super.key});

  @override
  State<SmartNutritionScreen> createState() => _SmartNutritionScreenState();
}

class _SmartNutritionScreenState extends State<SmartNutritionScreen> {
  List<Measurement> _measurements = [];
  bool _isLoading = true;
  bool _isSyncing = false;
  bool _isGenerating = false;
  final String _apiKey = 'AIzaSyDL4NqxqWWnU8-piYwsFX1Uoyl2ytizE64';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await LocalDatabase.instance.getAllMeasurements();
    setState(() {
      _measurements = data;
      _isLoading = false;
    });
  }

  Future<void> _syncData() async {
    setState(() => _isSyncing = true);
    final success = await ApiClient.syncData();
    await _loadData();
    setState(() => _isSyncing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Sinkronisasi berhasil' : 'Gagal terhubung ke server'),
          backgroundColor: success ? const Color(0xFF10B981) : const Color(0xFFEF4444),
        ),
      );
    }
  }

  Future<void> _getAIReco(Measurement m) async {
    setState(() => _isGenerating = true);
    try {
      final model = GenerativeModel(model: 'gemini-3-flash-preview', apiKey: _apiKey);
      final prompt = 'Balita ${m.age} bln, BB ${m.weight}kg, TB ${m.height}cm, Z-Score ${m.zScore.toStringAsFixed(2)}. Berikan 3 makanan protein hewani lokal murah. Jawab hanya JSON: {"status": "...", "budget": "...", "foods": [{"name": "...", "benefit": "..."}]}';
      final response = await model.generateContent([Content.text(prompt)]);
      final parsed = jsonDecode(response.text!.replaceAll('```json', '').replaceAll('```', ''));
      
      if (mounted) {
        _showNutritionSheet(m, parsed);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal memuat AI: $e")));
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  void _showNutritionSheet(Measurement m, Map<String, dynamic> ai) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            Text(ai['status'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
            const SizedBox(height: 20),
            ...List.generate(ai['foods'].length, (i) => ListTile(
              leading: const Icon(Icons.restaurant_rounded, color: Color(0xFF10B981)),
              title: Text(ai['foods'][i]['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              subtitle: Text(ai['foods'][i]['benefit'], style: const TextStyle(color: Color(0xFF64748B))),
            )),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Estimasi Budget:", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  Text(ai['budget'], style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF10B981), fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int unsynced = _measurements.where((m) => m.isSynced == 0).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Nutrisi & Sinkronisasi", style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF10B981))) 
        : RefreshIndicator(
            onRefresh: _loadData,
            color: const Color(0xFF10B981),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 15, offset: const Offset(0, 10))
                    ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Data Lokal", style: TextStyle(color: Colors.white70)),
                          Text("$unsynced Tertunda", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0F172A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                        ),
                        onPressed: unsynced == 0 || _isSyncing ? null : _syncData,
                        child: _isSyncing 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0F172A))) 
                            : const Text("Kirim", style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text("Klik Riwayat untuk Analisis AI", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF0F172A))),
                const SizedBox(height: 15),
                if (_isGenerating) const LinearProgressIndicator(color: Color(0xFF10B981), backgroundColor: Color(0xFFE2E8F0)),
                if (_isGenerating) const SizedBox(height: 15),
                ..._measurements.map((m) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 4))
                    ]
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    onTap: _isGenerating ? null : () => _getAIReco(m),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: m.zScore < -2 ? Colors.orange.withAlpha(30) : Colors.green.withAlpha(30),
                        shape: BoxShape.circle
                      ),
                      child: Icon(m.zScore < -2 ? Icons.warning_rounded : Icons.check_circle_rounded, color: m.zScore < -2 ? Colors.orange : Colors.green),
                    ),
                    title: Text("Usia ${m.age} Bln", style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                    subtitle: Text("Z-Score: ${m.zScore.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    trailing: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF10B981)),
                  ),
                )),
                const SizedBox(height: 80),
              ],
            ),
          ),
    );
  }
}