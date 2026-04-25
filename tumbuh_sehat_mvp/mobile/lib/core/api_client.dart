import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'local_db.dart';

class ApiClient {
  // Ganti alamat ini sesuai dengan IPv4 laptop Anda di jaringan WiFi
  static const String baseUrl = 'http://10.167.70.233:8000/api';

  static Future<bool> syncData() async {
    try {
      final unsyncedData = await LocalDatabase.instance.getUnsyncedMeasurements();
      if (unsyncedData.isEmpty) return true;

      final payload = unsyncedData.map((e) => {
        'age': e.age,
        'weight': e.weight,
        'height': e.height,
        'gender': e.gender,
        'lat': e.lat,
        'lng': e.lng,
        'z_score': e.zScore,
      }).toList();

      final response = await http.post(
        Uri.parse('$baseUrl/measurements/sync'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'data': payload}),
      );

      if (response.statusCode == 200) {
        for (var data in unsyncedData) {
          await LocalDatabase.instance.markAsSynced(data.id!);
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Sync Error: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getNutritionRecommendation({
    required int age,
    required String statusGizi,
    required String budget,
    int? childId,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "age": age,
        "status_gizi": statusGizi,
        "budget": budget,
      };
      
      if (childId != null) {
        requestBody["child_id"] = childId;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/nutrition/recommendation'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint("API Error: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Connection Error: $e");
      return null;
    }
  }
}