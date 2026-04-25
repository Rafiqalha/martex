import 'dart:convert';
import 'package:http/http.dart' as http;
import 'local_db.dart';

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<bool> syncData() async {
    try {
      final unsyncedData = await LocalDatabase.instance.getUnsyncedMeasurements();
      if (unsyncedData.isEmpty) return true;

      bool allSynced = true;

      for (var data in unsyncedData) {
        final response = await http.post(
          Uri.parse('$baseUrl/measurements'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'age': data.age,
            'weight': data.weight,
            'height': data.height,
            'lat': data.lat,
            'lng': data.lng,
            'z_score': data.zScore,
          }),
        );

        if (response.statusCode == 200) {
          await LocalDatabase.instance.markAsSynced(data.id!);
        } else {
          allSynced = false;
        }
      }
      return allSynced;
    } catch (e) {
      return false;
    }
  }
}