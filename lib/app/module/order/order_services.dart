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
    int id_user,
    String id_branch,
    List id_part,
    List name_part,
    List brand,
    List vendor,
    List type,
    List quantity,
    List unit,
    List desc,
    List size,
    String createdby,
  ) async {
    Map<String, dynamic> body = {
      "id_user": "$id_user",
      "id_branch": "$id_branch",
      "brand": brand,
      "vendor": vendor,
      "type": type,
      "quantity": quantity,
      "unit": unit,
      "desc": desc,
      "createdby": createdby,
    };

    // Conditionally add "size" if selectedType is "getalltire"
    if (selectedType == "getalltire") {
      body["size"] = size;
      body["id_tires"] = id_part;
      body["name_tires"] = name_part;
    } else {
      body["id_part"] = id_part;
      body["name_part"] = name_part;
    }

    // Send the request
    final response = await http.post(
      Uri.parse(
          "$backend_url/order/${selectedType == "getalltire" ? "createordertires" : "createorderparts"}"),
      headers: {
        'Content-Type': 'application/json',
        'WAREHOUSEKEY': ApiKey.key,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to make PO request: ${response.body}');
      return false;
    }
  }
}
