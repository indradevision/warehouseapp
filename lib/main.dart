// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'app/routes/app_pages.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(textTheme: GoogleFonts.openSansTextTheme()),
//       title: "Warehouse",
//       initialRoute: AppPages.INITIAL,
//       getPages: AppPages.routes,
//     );
//   }
// }

import 'package:Warehouse/app/module/login/controllers/login_controller.dart';
import 'package:Warehouse/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:get/get.dart';

import 'app/module/login/views/login_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LoginController(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(textTheme: GoogleFonts.openSansTextTheme()),
      title: "Warehouse",
      initialRoute: AppPages.INITIAL,
      // getPages: AppPages.routes,
      // title: 'Flutter Login Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginView(),
      routes: {
        // Tambahkan rute untuk halaman setelah login jika ada
        '/home': (ctx) => Scaffold(body: Center(child: Text('Home Screen'))),
      },
    );
  }
}
