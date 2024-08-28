import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  late SharedPreferences logindata;

  late bool newuser;
  bool disable = false;
  var formKey = GlobalKey<FormState>();
  bool hidepass = true;
  bool btnLoading = false;

}

