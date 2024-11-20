import 'dart:convert';
import 'package:Warehouse/app/data/api_config.dart';
import 'package:http/http.dart' as http;

class SpData {
  static Future<List<Map<String, dynamic>>> fetchAllData() async {
    final response = await http.post(
      Uri.parse("$backend_url/getallpart"),
      headers: {
        'Content-Type': 'application/json',
        'WAREHOUSEKEY': ApiKey.key,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(responseData['data']);
    } else {
      throw Exception('Failed to load PO data');
    }
  }
}

class VData {
  static Future<List<Map<String, dynamic>>> fetchAllData() async {
    final response = await http.post(
      Uri.parse("$backend_url/getvendor"),
      headers: {
        'Content-Type': 'application/json',
        'WAREHOUSEKEY': ApiKey.key,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(responseData['data']);
    } else {
      throw Exception('Failed to load PO data');
    }
  }
}
