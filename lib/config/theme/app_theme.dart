import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    fontFamily: 'Sculpin',
    colorSchemeSeed: Color.fromRGBO(0, 54, 41, 1),
    textTheme: TextTheme(
      titleLarge: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
      bodyMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
    ),
  );
}
