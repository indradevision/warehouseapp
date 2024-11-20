import 'package:Warehouse/app/data/api_config.dart';
import 'package:Warehouse/app/module/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:Warehouse/app/data/constants.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isDisabled = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<LoginController>(context, listen: false).login(
        _usernameController.text,
        _passwordController.text,
      );

      Navigator.of(context).pushReplacementNamed('/home'); // Navigasi ke Home
    } catch (error) {
      _showErrorDialog(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Login Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  void _checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    var response = await http.post(
      Uri.parse("${ApiChekVersion.url}"),
      headers: {'WAREHOUSEKEY': ApiKey.key},
      body: {"version": version},
    );

    if (response.statusCode != 200) {
      setState(() {
        _isDisabled = true;
      });

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Versi Baru Tersedia"),
            content: Text("Silakan melakukan update dengan klik tombol di bawah."),
            actions: [
              TextButton(
                onPressed: () {
                  launch('https://buzzit.co.id/getlatestapp');
                },
                child: Text("Update"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Image.asset(
                      'assets/images/logo-san-wider.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 40),
                  _buildTextField(
                    controller: _usernameController,
                    labelText: 'Username',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your username' : null,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your password' : null,
                  ),
                ],
              ),

              Column(
                children: [
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(baseColor),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: _isDisabled ? null : _login,
                        child: Text('Login'),
                      ),
                    ),
                  SizedBox(height: 20),
                  Text(
                    "Powered by SAN Technology",
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "V.1.1",
                    style: TextStyle(color: Colors.black38),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }
}
