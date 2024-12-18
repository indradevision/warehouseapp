import 'dart:convert';
import 'package:Warehouse/app/data/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController with ChangeNotifier {
  Future<void> login(String username, String password) async {
    try {
      var response = await http.post(
        Uri.parse("${ApiLogin.url}"),
        headers: {
          'WAREHOUSEKEY': ApiKey.key,
        },
        body: {
          "username": username,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final name = responseData['data']['name'];
        final idU = responseData['data']['id'];

        print("Login success $idU");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', name);
        await prefs.setInt('idUser', idU);
        await prefs.setBool('isLoggedIn', true);

        notifyListeners();
      } else {
        final errorResponse = json.decode(response.body);
        final errorMessage = errorResponse['error'] ?? 'Unknown error occurred';

        throw Exception('Failed to login: $errorMessage');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    notifyListeners();
  }

  Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
