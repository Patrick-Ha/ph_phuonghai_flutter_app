import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // For light theme
  static const kPrimaryColor = Colors.green;
  static const kBgLightColor = Colors.white;
  static const kBgCardLightColor = Color(0xFFcfd8dc);
  static const kDisconnectedColor = Color(0xffe0e0e0);
  // static const kSecondaryLightColor = Color(0xFF979797);
  static const kSecondaryLightColor = Color(0xFF757575);
  // static const kSecondaryLightColor = Color(0xff68737d);

  static const kActiveIconColor = Color(0xffff9f43);
  static const kBorderIconColor = Color(0xffdcdde1);

  static const kGradient = LinearGradient(
      colors: <Color>[
        Colors.green,
        Colors.indigo,
      ],
      begin: FractionalOffset(0.0, 0.0),
      end: FractionalOffset(1.0, 1.0),
      stops: <double>[0.0, 1.0],
      tileMode: TileMode.clamp);
}
