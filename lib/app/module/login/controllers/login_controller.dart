// import 'package:get/get.dart';
// import 'package:flutter/cupertino.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// class LoginController extends GetxController {
//   TextEditingController username = TextEditingController();
//   TextEditingController password = TextEditingController();
//   // late SharedPreferences logindata;

//   late bool newuser;
//   bool disable = false;
//   var formKey = GlobalKey<FormState>();
//   bool hidepass = true;
//   bool btnLoading = false;

// }

import 'dart:convert';
import 'package:Warehouse/app/data/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LoginController with ChangeNotifier {
  String _token = '';

  String get token => _token;

  Future<void> login(String username, String password) async {
    final url = Uri.parse("${ApiLogin.url}"); // Ganti dengan URL API Anda

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _token = responseData['token']; // Ganti dengan field token yang sesuai
        notifyListeners();
      } else {
        throw Exception('Failed to login');
      }
    } catch (error) {
      throw error;
    }
  }
}
