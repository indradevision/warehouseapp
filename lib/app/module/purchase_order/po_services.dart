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

class OrderService {
  Future<bool> approveOrder(String idOrder) async {
    try {
      final response = await http.post(
        Uri.parse("$backend_url/order/approveorder"),
        headers: {
          'Content-Type': 'application/json',
          'WAREHOUSEKEY': ApiKey.key,
        },
        body: jsonEncode({
          'id_order': idOrder,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to approve order: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error approving order: $e');
      return false;
    }
  }
}

class DownloadService {
  Future<String> downloadDoc(String idOrder, String nameVendor) async {
    try {
      final response = await http.post(
        Uri.parse("$backend_url/order/getlinkdownloadorder"),
        headers: {
          'Content-Type': 'application/json',
          'WAREHOUSEKEY': ApiKey.key,
        },
        body: jsonEncode({
          'id_order': idOrder,
          'vendor': nameVendor,
        }),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Failed to approve order: ${response.body}');
        throw Exception('Failed to download document: ${response.body}');
      }
    } catch (e) {
      print('Error approving order: $e');
      throw Exception('Error downloading document: $e');
    }
  }
}

class PoSingleService {
  static Future<Map<String, dynamic>> fetchSingleData(
      String id_order, String vendor) async {
    final response = await http.post(
      Uri.parse("$backend_url/order/getdetailorder"),
      headers: {
        'Content-Type': 'application/json',
        'WAREHOUSEKEY': ApiKey.key,
      },
      body: jsonEncode({
        'id_order': id_order,
        'vendor': vendor,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return responseData['data'];
    } else {
      throw Exception('Failed to load PO Single data');
    }
  }
}
