import 'package:Warehouse/app/module/home/views/home_view.dart';
import 'package:Warehouse/app/module/login/controllers/login_controller.dart';
import 'package:Warehouse/app/module/splash/views/splash_view.dart';
import 'package:Warehouse/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          // scaffoldBackgroundColor: Color.fromARGB(255, 240, 240, 240),
          ),
      home: SplashView(),
      routes: {
        '/login': (context) => LoginView(), // Default route
        '/home': (context) => HomeView(),
      },
    );
  }
}
