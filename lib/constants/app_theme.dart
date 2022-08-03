import 'package:flutter/material.dart';
// import 'package:phuonghai/constants/colors.dart';

ThemeData appThemes(BuildContext context) {
  return ThemeData(
    appBarTheme: appBarTheme(),

    // scaffoldBackgroundColor: AppColors.kBgLightColor,
    primarySwatch: Colors.green,
    //inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    elevation: 1,
    centerTitle: false,
  ); // 2);
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(22),
    borderSide: const BorderSide(color: Colors.white),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}
