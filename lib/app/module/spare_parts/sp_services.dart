import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Warehouse/app/data/api_config.dart';

class SpSummary {
  static Future<List<Map<String, dynamic>>> loadSummary(
      String branch, String batch_sel) async {
    final response = await http.post(
      Uri.parse("$backend_url/getpart"),
      headers: {
        'Content-Type': 'application/json',
        'WAREHOUSEKEY': ApiKey.key,
      },
      body: jsonEncode({
        'branch': branch,
        'batch_sel': batch_sel,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(responseData['data']['detail']);
    } else {
      throw Exception('Failed to load SP data');
    }
  }
}

class SpBrand {
  static Future<List<Map<String, dynamic>>> loadBrand() async {
    final response = await http.post(
      Uri.parse("$backend_url/getalltype"),
      headers: {
        'Content-Type': 'application/json',
        'WAREHOUSEKEY': ApiKey.key,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(responseData['data']);
    } else {
      throw Exception('Failed to load br data');
    }
  }
}

class SpGrand {
  static Future<int> loadGrandTotal(String branch, String batch_sel) async {
    final response = await http.post(
      Uri.parse("$backend_url/getpart"),
      headers: {
        'Content-Type': 'application/json',
        'WAREHOUSEKEY': ApiKey.key,
      },
      body: jsonEncode({
        'branch': branch,
        'batch_sel': batch_sel,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return responseData['data']['grandtotal'] as int;
    } else {
      throw Exception('Failed to load SP data');
    }
  }
}
