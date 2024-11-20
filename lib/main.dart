import 'package:Warehouse/app/module/home/views/home_view.dart';
import 'package:Warehouse/app/module/login/controllers/login_controller.dart';
import 'package:Warehouse/app/module/splash/views/splash_view.dart';
import 'package:Warehouse/app/data/constants.dart';
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
      title: "Warehouse",
      theme: ThemeData(
        primaryColor: baseColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
        ).copyWith(
          secondary: Colors.orange,
        ),
        scaffoldBackgroundColor: Colors.grey.shade200,
      ),
      home: SplashView(),
      routes: {
        '/login': (context) => LoginView(),
        '/home': (context) => HomeView(),
      },
    );
  }
}
