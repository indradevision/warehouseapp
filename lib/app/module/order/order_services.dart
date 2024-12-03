import 'dart:convert';
import 'package:Warehouse/app/data/api_config.dart';
import 'package:http/http.dart' as http;

class SpData {
  final String selectedEndpoint;

  SpData(this.selectedEndpoint);

  static Future<List<Map<String, dynamic>>> fetchAllData(
      String selectedEndpoint) async {
    final response = await http.post(
      Uri.parse("$backend_url/$selectedEndpoint"),
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

class RequestPo {
  Future<bool> postRequest(
    String selectedType,
    String id_user,
    String id_branch,
    List id_part,
    List name_part,
    List brand,
    List vendor,
    List type,
    List quantity,
    List unit,
    List desc,
    String createdby,
  ) async {
    final response = await http.post(
      Uri.parse("$backend_url/$selectedType"),
      headers: {
        'Content-Type': 'application/json',
        'WAREHOUSEKEY': ApiKey.key,
      },
      body: jsonEncode({
        "id_user": "1",
        "id_branch": id_branch,
        selectedType == "getalltire" ? "id_tires" : "id_part": id_part,
        selectedType == "getalltire" ? "name_tires" : "name_part": name_part,
        "brand": brand,
        "vendor": vendor,
        "type": type,
        "quantity": quantity,
        "unit": unit,
        "desc": desc,
        "createdby": createdby
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to make po request: ${response.body}');
      return false;
    }
  }
}
