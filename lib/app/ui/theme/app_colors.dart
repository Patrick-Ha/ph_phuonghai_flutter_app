import 'package:flutter/material.dart';

const kGradient = LinearGradient(
  colors: <Color>[
    Colors.green,
    Colors.indigo,
  ],
  begin: FractionalOffset(0.0, 0.0),
  end: FractionalOffset(1.0, 1.0),
  stops: <double>[0.0, 1.0],
  tileMode: TileMode.clamp,
);
