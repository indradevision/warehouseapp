import 'package:Warehouse/app/module/home/views/home_view.dart';
import 'package:Warehouse/app/module/login/controllers/login_controller.dart';
import 'package:Warehouse/app/module/splash/views/splash_view.dart';
import 'package:Warehouse/app/routes/app_pages.dart';
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
      // theme: ThemeData(textTheme: GoogleFonts.openSansTextTheme()),
      title: "Warehouse",
      initialRoute: AppPages.INITIAL,
      // getPages: AppPages.routes,
      // title: 'Flutter Login Example',
      theme: ThemeData(
        primaryColor: baseColor, // Set the primary color
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo, // Set primary swatch color
        ).copyWith(
          secondary: Colors.orange, // Set accent color
        ),
        // inputDecorationTheme: InputDecorationTheme(
        //   enabledBorder: OutlineInputBorder(
        //     borderSide: BorderSide(color: Colors.grey), // Default border color
        //   ),
        //   focusedBorder: OutlineInputBorder(
        //     borderSide:
        //         BorderSide(color: Colors.blue), // Border color when focused
        //   ),
        // ),
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: SplashView(),
      routes: {
        '/login': (context) => LoginView(), // Default route
        '/home': (context) => HomeView(),
      },
    );
  }
}
