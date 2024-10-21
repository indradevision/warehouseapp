import 'dart:convert';
import 'package:Warehouse/app/data/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LoginController with ChangeNotifier {
  // String _token = '';
  // String get token => _token;
  Future<void> login(String username, String password) async {

  try {
    var response = await http.post(Uri.parse("${ApiLogin.url}"), 
    headers: {'WAREHOUSEKEY': ApiKey.key,},
    body: {
      "username": username,
      "password": password
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // _token = responseData['token']; // Ganti dengan field token yang sesuai
      notifyListeners();
    } else {
      throw Exception('Failed to login');
    }
  } catch (error) {
    throw error;
  }
}

}
