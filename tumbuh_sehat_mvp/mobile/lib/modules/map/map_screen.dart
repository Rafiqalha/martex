import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isLoading = true;
  List<Polygon> _polygons = [];

  final Map<String, double> _ssgi2024 = {
    "ACEH": 28.6, "SUMATERA UTARA": 22.0, "SUMATERA BARAT": 24.9, "RIAU": 20.1,
    "JAMBI": 17.1, "SUMATERA SELATAN": 15.9, "BENGKULU": 18.8, "LAMPUNG": 15.9,
    "BANGKA BELITUNG": 20.1, "KEPULAUAN RIAU": 15.0, "DKI JAKARTA": 17.3,
    "JAWA BARAT": 15.9, "JAWA TENGAH": 17.1, "DI YOGYAKARTA": 17.4, "JAWA TIMUR": 14.7,
    "BANTEN": 21.1, "BALI": 8.7, "NUSA TENGGARA BARAT": 29.8, "NUSA TENGGARA TIMUR": 37.0,
    "KALIMANTAN BARAT": 26.8, "KALIMANTAN TENGAH": 22.1, "KALIMANTAN SELATAN": 22.9,
    "KALIMANTAN TIMUR": 22.2, "KALIMANTAN UTARA": 17.6, "SULAWESI UTARA": 21.3,
    "SULAWESI TENGAH": 27.2, "SULAWESI SELATAN": 27.4, "SULAWESI TENGGARA": 30.0,
    "GORONTALO": 26.9, "SULAWESI BARAT": 30.3, "MALUKU": 28.4, "MALUKU UTARA": 24.7,
    "PAPUA BARAT": 24.8, "PAPUA": 28.6
  };

  @override
  void initState() {
    super.initState();
    _fetchGeoJson();
  }

  Future<void> _fetchGeoJson() async {
    try {
      final response = await http.get(Uri.parse('https://raw.githubusercontent.com/ans-4175/peta-indonesia-geojson/master/indonesia-prov.geojson'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
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
      final String provName = properties['Propinsi'].toString().toUpperCase();
      final geometry = feature['geometry'];
      final type = geometry['type'];
      final coordinates = geometry['coordinates'];

      double prevalence = 0.0;
      for (var key in _ssgi2024.keys) {
        if (provName.contains(key) || key.contains(provName)) {
          prevalence = _ssgi2024[key]!;
          break;
        }
      }

      final Color fillColor = prevalence > 0 ? _getColor(prevalence) : const Color(0xFFE5E7EB);

      if (type == 'Polygon') {
        parsedPolygons.add(_createPolygon(coordinates[0], fillColor));
      } else if (type == 'MultiPolygon') {
        for (var polygonCoords in coordinates) {
          parsedPolygons.add(_createPolygon(polygonCoords[0], fillColor));
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
      color: color.withAlpha(178),
      borderColor: Colors.white,
      borderStrokeWidth: 1,
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
                    initialZoom: 5.0,
                    minZoom: 4.0,
                    maxZoom: 10.0,
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
                  top: 50,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withAlpha(230),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Peta Komando SSGI 2024",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Prevalensi Stunting per Provinsi",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}