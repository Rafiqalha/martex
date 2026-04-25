import 'dart:convert';
import 'package:http/http.dart' as http;
import 'local_db.dart';

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

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
      return false;
    }
  }
}