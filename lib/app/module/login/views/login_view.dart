import 'package:Warehouse/app/module/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Warehouse/app/data/constants.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<LoginController>(context, listen: false).login(
        _usernameController.text,
        _passwordController.text,
      );
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occurred!'),
          content: Text(error.toString()),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Image.asset(
                        'assets/images/logo-san-wider.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400, // Warna border
                            width: 1.5, // Ketebalan border
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color:
                                Colors.grey.shade300, // Warna border saat fokus
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color:
                                Colors.red, // Warna border saat ada kesalahan
                            width: 1.5,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors
                                .red, // Warna border saat fokus dan ada kesalahan
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400, // Warna border
                            width: 1.5, // Ketebalan border
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color:
                                Colors.grey.shade300, // Warna border saat fokus
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color:
                                Colors.red, // Warna border saat ada kesalahan
                            width: 1.5,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors
                                .red, // Warna border saat fokus dan ada kesalahan
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    if (_isLoading) CircularProgressIndicator(),
                    if (!_isLoading)
                      SizedBox(
                        height: 50,
                        width: double.infinity, // Mengatur lebar penuh
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(baseColor),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10), // Border radius
                              ),
                            ),
                          ),
                          onPressed: _login,
                          child: Text('Login'),
                        ),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Powered by SAN Technology",
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "V.1.1",
                      style: TextStyle(color: Colors.black38),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
