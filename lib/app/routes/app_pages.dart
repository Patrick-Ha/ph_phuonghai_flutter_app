import 'package:get/route_manager.dart';
import 'package:phuonghai/app/controllers/bindings/auth_binding.dart';
import 'package:phuonghai/app/controllers/bindings/home_binding.dart';
import 'package:phuonghai/app/ui/common/login/login_page.dart';
import 'package:phuonghai/app/ui/common/sign_up/sign_up_page.dart';
import 'package:phuonghai/app/ui/common/splash/splash_page.dart';
import 'package:phuonghai/app/ui/desktop/dashboard/wed_home_page.dart';
import 'package:phuonghai/app/ui/mobile/device/iaq_page.dart';
import 'package:phuonghai/app/ui/mobile/home_page.dart';
import 'package:phuonghai/app/ui/mobile/settings/settings_page.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.INITIAL,
      page: () => const SplashPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LogInPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => const SignUpPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    // GetPage(
    //   name: Routes.DEVICE,
    //   page: () => const DevicePage(),
    //   binding: HomeBinding(),
    // ),
    GetPage(
      name: Routes.IAQ_DEVICE,
      page: () => const IaqPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.WEB_HOME,
      page: () => const WebHomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsPage(),
      // binding: HomeBinding(),
    ),
  ];
}
