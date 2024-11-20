import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Warehouse/app/module/login/views/login_view.dart';
import 'package:Warehouse/app/module/home/views/home_view.dart';

class SplashView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashView> {
  Future<Widget> _determineNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    return isLoggedIn ? HomeView() : LoginView();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: FutureBuilder<Widget>(
        future: _determineNextScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AnimatedSplashScreen(
              duration: 2000,
              splashTransition: SplashTransition.fadeTransition,
              nextScreen: snapshot.data!,
              splash: Image.asset(
                "assets/images/logo-san-wider.png",
                width: MediaQuery.of(context).size.width * 0.50,
                height: MediaQuery.of(context).size.height * 0.10,
                fit: BoxFit.contain,
              ),
              backgroundColor: Colors.white,
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
