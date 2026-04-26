import 'dart:convert';
import 'package:flutter/foundation.dart'; // Wajib untuk fitur compute (Isolate)
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

// Fungsi terisolasi (Harus berada di luar kelas agar bisa berjalan di background thread)
Map<String, dynamic> decodeGeoJsonInBackground(String responseBody) {
  return jsonDecode(responseBody);
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isLoading = true;
  List<Polygon> _polygons = [];

  final Map<String, double> _stuntingData = {
    "ACEH": 28.6, "SUMATERA UTARA": 22.0, "SUMATERA BARAT": 24.9, "RIAU": 20.1,
    "JAMBI": 17.1, "SUMATERA SELATAN": 15.9, "BENGKULU": 18.8, "LAMPUNG": 15.9,
    "BANGKA BELITUNG": 20.1, "KEPULAUAN RIAU": 15.0, "DKI JAKARTA": 17.3,
    "JAWA BARAT": 15.9, "JAWA TENGAH": 17.1, "DI YOGYAKARTA": 17.4, "JAWA TIMUR": 14.7,
    "BANTEN": 21.1, "BALI": 8.7, "NUSA TENGGARA BARAT": 29.8, "NUSA TENGGARA TIMUR": 37.0,
    "KALIMANTAN BARAT": 26.8, "KALIMANTAN TENGAH": 22.1, "KALIMANTAN SELATAN": 22.9,
    "KALIMANTAN TIMUR": 22.2, "KALIMANTAN UTARA": 17.6, "SULAWESI UTARA": 21.3,
    "SULAWESI TENGAH": 27.2, "SULAWESI SELATAN": 27.4, "SULAWESI TENGGARA": 30.0,
    "GORONTALO": 26.9, "SULAWESI BARAT": 30.3, "MALUKU": 28.4, "MALUKU UTARA": 24.7,
    "PAPUA BARAT": 24.8, "PAPUA": 28.6, "PAPUA SELATAN": 24.9, "PAPUA TENGAH": 39.4,
    "PAPUA PEGUNGUNGAN": 36.9, "PAPUA BARAT DAYA": 31.4,
  };

  @override
  void initState() {
    super.initState();
    _fetchGeoJson();
  }

  Future<void> _fetchGeoJson() async {
    try {
      final response = await http.get(Uri.parse(
          'https://raw.githubusercontent.com/superpikar/indonesia-geojson/master/indonesia-prov.geojson'));
      
      if (response.statusCode == 200) {
        // MENGGUNAKAN ISOLATE: Membaca jutaan koordinat di luar UI Thread.
        // Loading indicator akan tetap berputar mulus tanpa lag.
        final data = await compute(decodeGeoJsonInBackground, response.body);
        _parseGeoJson(data);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _getColor(double prevalence) {
    if (prevalence >= 30.0) return const Color(0xFFEF4444);
    if (prevalence >= 20.0) return const Color(0xFFF59E0B);
    return const Color(0xFF10B981);
  }

  void _parseGeoJson(Map<String, dynamic> data) {
    List<Polygon> parsedPolygons = [];
    final features = data['features'] as List;

    for (var feature in features) {
      final properties = feature['properties'];
      String rawName = (properties['Propinsi'] ?? properties['NAME_1'] ?? "").toString().toUpperCase();
      
      double prevalence = 0.0;
      for (var entry in _stuntingData.entries) {
        if (rawName.contains(entry.key) || entry.key.contains(rawName)) {
          prevalence = entry.value;
          break;
        }
      }

      final Color fillColor = prevalence > 0 ? _getColor(prevalence) : const Color(0xFF475569);
      final geometry = feature['geometry'];
      final type = geometry['type'];
      final coordinates = geometry['coordinates'];

      if (type == 'Polygon') {
        parsedPolygons.add(_createPolygon(coordinates[0], fillColor));
      } else if (type == 'MultiPolygon') {
        for (var multi in coordinates) {
          for (var poly in multi) {
            parsedPolygons.add(_createPolygon(poly, fillColor));
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        _polygons = parsedPolygons;
        _isLoading = false;
      });
    }
  }

  Polygon _createPolygon(List coords, Color color) {
    List<LatLng> points = [];
    for (var coord in coords) {
      points.add(LatLng(coord[1].toDouble(), coord[0].toDouble()));
    }
    return Polygon(
      points: points,
      color: color.withValues(alpha: 0.85),
      // MENGHAPUS BORDER: Beban GPU turun drastis, peta menjadi sangat ringan digeser
      borderColor: Colors.transparent,
      borderStrokeWidth: 0,
      isFilled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)))
          : Stack(
              children: [
                FlutterMap(
                  options: const MapOptions(
                    initialCenter: LatLng(-0.7893, 113.9213),
                    initialZoom: 4.8,
                    minZoom: 4.0,
                    maxZoom: 8.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.tumbuhsehat.mobile',
                    ),
                    PolygonLayer(polygons: _polygons),
                  ],
                ),
                Positioned(
                  top: 60,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (Navigator.canPop(context))
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                              ),
                            if (Navigator.canPop(context))
                              const SizedBox(width: 15),
                            const Text(
                              "Choropleth SSGI 2024",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildLegendItem(const Color(0xFFEF4444), "Kritis (>30%)"),
                        _buildLegendItem(const Color(0xFFF59E0B), "Waspada (20-30%)"),
                        _buildLegendItem(const Color(0xFF10B981), "Aman (<20%)"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}