// ignore_for_file: constant_identifier_names

part of './app_pages.dart';

abstract class Routes {
  static const INITIAL = '/splash';

  static const LOGIN = '/login';
  static const SIGNUP = '/sign_up';
  static const FORGOTPASSWORD = '/forgot_password';

  static const HOME = '/home';
  static const SETTINGS = '/settings';
  static const BLUETOOTH = '/bluetooth';
  static const BLE_DEVICE = '/ble_device';

  static const DEVICE = '/device';
  static const IAQ_DEVICE = '/iaq_device';

  static const WEB_HOME = '/web_home';
}
