import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phuonghai/constants/app_theme.dart';
import 'package:phuonghai/firebase_options.dart';
import 'package:phuonghai/providers/auth_provider.dart';
import 'package:phuonghai/providers/device_http.dart';
import 'package:phuonghai/routes.dart';
// import 'package:phuonghai/service/notification_service.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';
import 'package:provider/provider.dart';

import 'providers/language_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  // ));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  // await NotificationService().init();
  if (!kIsWeb) {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }

  HttpOverrides.global = MyHttpOverrides();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider()),
        ChangeNotifierProvider<LanguageProvider>(
            create: (context) => LanguageProvider()),
        ChangeNotifierProvider<DeviceHttp>(create: (context) => DeviceHttp()),
      ],
      child: const MyApp(
        key: Key("MyApp"),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (_, languageProviderRef, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: languageProviderRef.appLocale,
          supportedLocales: const [
            Locale('vi', 'VN'),
            Locale('en', 'US'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode ||
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          theme: appThemes(context),
          routes: Routes.routes,
          initialRoute: Routes.splash,
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
