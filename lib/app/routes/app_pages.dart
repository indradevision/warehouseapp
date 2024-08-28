import 'package:Warehouse/app/module/home/bindings/home_binding.dart';
import 'package:Warehouse/app/module/home/views/home_view.dart';
import 'package:Warehouse/app/module/maintenance/bindings/maintenance_binding.dart';
import 'package:Warehouse/app/module/maintenance/views/maintenance_view.dart';
import 'package:get/get.dart';
import 'package:Warehouse/app/module/login/bindings/login_binding.dart';
import 'package:Warehouse/app/module/login/views/login_view.dart';
import 'package:Warehouse/app/module/splash/bindings/splash_binding.dart';
import 'package:Warehouse/app/module/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MAINTENANCE,
      page: () => MaintenanceView(),
      binding: MaintenanceBinding(),
    ),
  ];
}
