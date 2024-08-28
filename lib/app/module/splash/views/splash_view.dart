import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Warehouse/app/module/login/views/login_view.dart';

  class SplashView extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => StartState();
  }

  class StartState extends State<SplashView> {
    // LoginController ca = LoginController();
    // late SharedPreferences logindata;

    // void autoLogIn() async {
    //   logindata = await SharedPreferences.getInstance();
    //   User.username = logindata.getString('user');
    //   User.emailuser = logindata.getString('username');
    //   ca.newuser = (logindata.getBool('login') ?? true);

    //   if (ca.newuser == false) {
    //     setState(
    //       () {
    //         Get.offAll(() => HomeLoginView());
    //       },
    //     );
    //   } else {
    //     setState(
    //       () {
    //         Get.offAll(() => HomeNoLoginView());
    //       },
    //     );
    //   }
    // }

    // @override
    // void initState() {
    //   super.initState();
    //   Timer(Duration(seconds: 2), () {
    //     autoLogIn();
    //   });
    // }

    // @override
    // void dispose() {
    //   super.dispose();
    // }

    @override
    Widget build(BuildContext context) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          child: initWidget(context));
    }
    Widget initWidget(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: AnimatedSplashScreen(
                duration: 2000,
                splashTransition: SplashTransition.fadeTransition,
                nextScreen: LoginView(),
                splash: Image.asset(
                  width: MediaQuery.of(context).size.width * 00.50,
                  height: MediaQuery.of(context).size.height * 00.10,
                  "assets/images/logo-san-wider.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
