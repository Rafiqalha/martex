import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
  bool _isGenerating = false;
  String _aiResponse = "";

  final String _apiKey = 'API_KEY_ANDA_DISINI';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await LocalDatabase.instance.getAllMeasurements();
    if (mounted) {
      setState(() {
        if (data.isNotEmpty) {
          _latestData = data.last;
        }
        _isLoading = false;
      });
    }
  }

  String _getFactualStatus(double zScore) {
    if (zScore < -3) return "Gizi Buruk / Kritis";
    if (zScore < -2) return "Risiko Stunting";
    if (zScore > 2) return "Risiko Obesitas";
    return "Tumbuh Normal & Sehat";
  }

  Future<void> _generateNutritionPlan() async {
    if (_latestData == null) return;
    
    setState(() {
      _isGenerating = true;
      _aiResponse = "";
    });

    try {
      final model = GenerativeModel(model: 'gemini-3-flash-preview', apiKey: _apiKey);
      
      final prompt = '''
Anda adalah Ahli Gizi Anak terkemuka di Indonesia.
Klien Anda adalah seorang ibu yang memiliki balita dengan data berikut:
- Usia: ${_latestData!.age} Bulan
- Berat Badan: ${_latestData!.weight} kg
- Tinggi Badan: ${_latestData!.height} cm
- Z-Score (Status Medis): ${_latestData!.zScore.toStringAsFixed(2)}

Berikan rekomendasi nutrisi harian yang spesifik untuk kondisi anak ini. 
Gunakan pengetahuan luas Anda tentang pangan lokal Indonesia. Sertakan rekomendasi menu makanan, sumber protein hewani terbaik, dan estimasi harga pasar saat ini (dalam Rupiah) agar terjangkau bagi ibu rumah tangga.
Gunakan format Markdown agar rapi (gunakan heading, bold, dan bullet points). Jangan gunakan sapaan pembuka yang bertele-tele, langsung ke intinya.
''';

      final response = await model.generateContent([Content.text(prompt)]);
      
      if (mounted) {
        setState(() {
          _aiResponse = response.text ?? "Gagal mendapatkan rekomendasi.";
          _isGenerating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _aiResponse = "Terjadi kesalahan pada koneksi AI: $e";
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Nutrisi Cerdas",
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w900),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)))
          : _latestData == null
              ? const Center(
                  child: Text(
                    "Belum ada data anak.\nSilakan input data di menu utama.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF065F46), Color(0xFF10B981), Color(0xFF34D399)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981).withAlpha(80),
                              blurRadius: 20,
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
                                const Text(
                                  "Rapor Gizi Faktual",
                                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(50),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Usia ${_latestData!.age} Bln",
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              _getFactualStatus(_latestData!.zScore),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildMetricItem("Berat", "${_latestData!.weight} kg"),
                                _buildMetricItem("Tinggi", "${_latestData!.height} cm"),
                                _buildMetricItem("Z-Score", _latestData!.zScore.toStringAsFixed(2)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (_aiResponse.isEmpty && !_isGenerating)
                        SizedBox(
                          width: double.infinity,
                          height: 65,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F172A),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 10,
                              shadowColor: const Color(0xFF0F172A).withAlpha(50),
                            ),
                            onPressed: _generateNutritionPlan,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.auto_awesome_rounded, color: Color(0xFFFFD602)),
                                SizedBox(width: 10),
                                Text(
                                  "Minta Resep & Anggaran AI",
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (_isGenerating)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
                          ),
                          child: const Column(
                            children: [
                              CircularProgressIndicator(color: Color(0xFF10B981)),
                              SizedBox(height: 20),
                              Text(
                                "Menganalisis nutrisi & harga pasar...",
                                style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      if (_aiResponse.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(5),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              )
                            ],
                            border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.restaurant_menu_rounded, color: Color(0xFF10B981)),
                                  SizedBox(width: 10),
                                  Text(
                                    "Saran Ahli Gizi AI",
                                    style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              MarkdownBody(
                                data: _aiResponse,
                                styleSheet: MarkdownStyleSheet(
                                  h1: const TextStyle(color: Color(0xFF0F172A), fontSize: 20, fontWeight: FontWeight.w900),
                                  h2: const TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.w900),
                                  h3: const TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
                                  p: const TextStyle(color: Color(0xFF334155), fontSize: 14, height: 1.6),
                                  listBullet: const TextStyle(color: Color(0xFF10B981), fontSize: 16),
                                  strong: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w900),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}