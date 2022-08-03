import 'package:flutter/material.dart';
import 'package:phuonghai/ui/auth/forgot_password.dart';
import 'package:phuonghai/ui/auth/sign_up_page.dart';
import 'package:phuonghai/ui/home/web/dashboard_page_web.dart';
import 'package:phuonghai/ui/settings/setting_page.dart';

import 'ui/auth/log_in_page.dart';
import 'ui/home/home_page.dart';
import 'ui/splash/splash_page.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiate this object

  static const String splash = '/splash';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String home = '/home';
  static const String homeWeb = '/homeWeb';
  static const String settings = '/settings';
  static const String forgotPassword = '/forgotPassword';

  static final routes = <String, WidgetBuilder>{
    splash: (_) => const SplashPage(),
    login: (_) => const LogInPage(),
    signUp: (_) => const SignUpPage(),
    home: (_) => const HomePage(),
    settings: (_) => const SettingsPage(),
    homeWeb: (_) => const DashboardPageWeb(),
    forgotPassword: (_) => const ForgotPassword(),
  };
}
