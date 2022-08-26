import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
    primarySwatch: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(elevation: 0, centerTitle: false),
    platform: TargetPlatform.iOS,
    inputDecorationTheme: const InputDecorationTheme(
      isDense: true,
      contentPadding: EdgeInsets.all(12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
      ),
    ));
