// import 'dart:async';
// import 'dart:convert';

// import 'package:Warehouse/app/data/api_config.dart';
// import 'package:Warehouse/app/data/tampungdata.dart';
// import 'package:Warehouse/app/module/login/controllers/login_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginView extends StatefulWidget {
//   const LoginView({Key? key}) : super(key: key);

//   @override
//   State<LoginView> createState() => _LoginViewState();
// }

// class _LoginViewState extends State<LoginView> {
//   LoginController c = LoginController();
//   late SharedPreferences logindata;

//   void _showLoginResultDialog(BuildContext context, bool success) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(success ? 'Login Berhasil' : 'Login Gagal'),
//           content: Text(success
//               ? 'Anda telah berhasil login.'
//               : 'Nama pengguna atau kata sandi salah.'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Tutup'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Menutup dialog
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }


// login(String username, String pass) async {
//   logindata = await SharedPreferences.getInstance();

//   var response = await http.post(
//         Uri.parse("${ApiLogin.url}"),
//         headers: {"WAREHOUSEKEY": ApiKey.key},
//         body: {
//           "username": User.username,
//           "password": User.password,
//         },
//       );
//   print(response.body);
//   if (response.statusCode == 200) {
//       User.name = json.decode(response.body)['data']['name'];
//       User.role = json.decode(response.body)['data']['role'];
//       User.username = json.decode(response.body)['data']['username'];
//       String pass = c.password.text;
//       if (c.username != 'username' && c.password != 'password') {
//         logindata.setBool('login', false);
//         logindata.setString('username', User.username);
//         logindata.setString('password', pass);
//         logindata.setString('name', User.name);
//         logindata.setString('role', User.role);
//         logindata.getString('name');
//         print(response.body);
//       }
//       _showLoginResultDialog(context, true);
//       Get.offNamed('/home');
//     } else {
//       _showLoginResultDialog(context, false);
//     }
// }

// @override
//   void dispose() {
//     c.username.dispose();
//     c.password.dispose();
//     super.dispose();
//   }

// @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ListView(
//                 shrinkWrap: true,
//                 children: [
//                   Column(
//                     children: [
//                       Text(
//                         "Login",
//                         style: TextStyle(
//                             fontSize: 28,
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w700),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "Masukan akun anda",
//                         style: TextStyle(color: Colors.black45),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Form(
//                     key: c.formKey,
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     child: Column(
//                       children: [
//                         TextFormField(
//                           onChanged: (value) {
//                             User.username = value;
//                           },
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Masukan username yang benar!';
//                             }
//                             return null;
//                           },
//                           controller: c.username,
//                           decoration: InputDecoration(
//                               errorStyle: TextStyle(fontSize: 10),
//                               labelText: "Username",
//                               floatingLabelStyle: TextStyle(color: Colors.blue),
//                               filled: true,
//                               isDense: true,
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide.none),
//                               focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(color: Colors.blue))),
//                         ),
//                         SizedBox(
//                           height: 15,
//                         ),
//                         TextFormField(
//                           onChanged: (value) {
//                             User.password = value;
//                           },
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Masukan password yang benar!';
//                             }
//                             return null;
//                           },
//                           obscureText: c.hidepass,
//                           controller: c.password,
//                           decoration: InputDecoration(
//                               errorStyle: TextStyle(fontSize: 10),
//                               suffixIcon: IconButton(
//                                 color: Colors.grey,
//                                 iconSize: 20,
//                                 splashRadius: 2,
//                                 onPressed: () {
//                                   setState(() {
//                                     c.hidepass = !c.hidepass;
//                                   });
//                                 },
//                                 icon: Icon(c.hidepass
//                                     ? Icons.visibility
//                                     : Icons.visibility_off),
//                               ),
//                               labelText: "Password",
//                               floatingLabelStyle: TextStyle(color: Colors.blue),
//                               filled: true,
//                               isDense: true,
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide.none),
//                               focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(color: Colors.blue))),
//                         ),
//                         SizedBox(
//                           height: 15,
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: MediaQuery.of(context).size.height * 00.06,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: c.disable ? Colors.grey : Colors.blue,
//                           ),
//                           child: MaterialButton(
//                             onPressed: () {
//                               // setState(() {
//                               //   isLoading = true;
//                               // });
//                               // c.formKey.currentState!.validate();
//                               // if (!isValid) {}
//                               // c.formKey.currentState!.save();
//                               if (c.disable == true) {
//                                 // checkver();
//                               } else {
//                                 Timer(Duration(seconds: 2), () {
//                                   login(c.username.text, c.password.text);
//                                 });
//                               }
//                             },
//                             child: Text(
//                               'Login',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:Warehouse/app/module/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (_isLoading) CircularProgressIndicator(),
              if (!_isLoading)
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
