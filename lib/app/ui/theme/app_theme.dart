import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
  primarySwatch: Colors.green,
  scaffoldBackgroundColor: Colors.white,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: const AppBarTheme(elevation: 0, centerTitle: false),
  platform: TargetPlatform.iOS,
  brightness: Brightness.light,
  // useMaterial3: true,
  // colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
);
