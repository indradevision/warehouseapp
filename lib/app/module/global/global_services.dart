import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Warehouse/app/data/api_config.dart';

class GetBranch {
  static Future<List<Map<String, dynamic>>> fetchBranch() async {
    final response =
        await http.post(Uri.parse("$backend_url/getallbranch"), headers: {
      'Content-Type': 'application/json',
      'WAREHOUSEKEY': ApiKey.key,
    });

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(responseData['data']);
    } else {
      throw Exception('Failed to load Branch Data');
    }
  }
}
