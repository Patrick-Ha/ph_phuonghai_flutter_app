import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phuonghai/app/routes/app_pages.dart';
import 'package:phuonghai/app/translations/app_translations.dart';
import 'package:phuonghai/app/ui/theme/app_theme.dart';
import 'package:timeago/timeago.dart';

import 'package:url_strategy/url_strategy.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  timeago.setLocaleMessages('vi', MyCustomMessages());

  if (!GetPlatform.isWeb) {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  } else {
    setPathUrlStrategy();
  }

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.INITIAL,
      getPages: AppPages.pages,
      theme: appThemeData,
      locale: await AppTranslations.locale,
      fallbackLocale: AppTranslations.fallbackLocale,
      defaultTransition: Transition.fade,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('vi', 'VN'),
      ],
      translations: AppTranslations(),
      builder: EasyLoading.init(),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// my_custom_messages.dart
class MyCustomMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'trước';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'gần 1 phút';
  @override
  String aboutAMinute(int minutes) => '$minutes phút';
  @override
  String minutes(int minutes) => '$minutes phút';
  @override
  String aboutAnHour(int minutes) => '$minutes phút';
  @override
  String hours(int hours) => '$hours giờ';
  @override
  String aDay(int hours) => '$hours giờ';
  @override
  String days(int days) => '$days ngày';
  @override
  String aboutAMonth(int days) => '$days ngày';
  @override
  String months(int months) => '$months tháng';
  @override
  String aboutAYear(int year) => '$year năm';
  @override
  String years(int years) => '$years năm';
  @override
  String wordSeparator() => ' ';
}
