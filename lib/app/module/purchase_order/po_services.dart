import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Warehouse/app/data/api_config.dart';

class PoService {
  static Future<List<Map<String, dynamic>>> fetchPoData(
      String from, String to, String branch) async {
    final response = await http.post(
      Uri.parse("$backend_url/order/getorderbybranch"),
      headers: {
        'Content-Type': 'application/json',
        'WAREHOUSEKEY': ApiKey.key,
      },
      body: jsonEncode({
        'from': from,
        'to': to,
        'branch': branch,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(responseData['data']);
    } else {
      throw Exception('Failed to load PO data');
    }
  }
}
