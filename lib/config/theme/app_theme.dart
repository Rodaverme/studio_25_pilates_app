import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    fontFamily: 'Sculpin',
    colorSchemeSeed: Color.fromRGBO(137, 107, 90, 1),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 20,
        color: Colors.brown,
      ),
      bodyMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown,
        minimumSize: Size(140, 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15),
        ),
      ),
    ),
  );
}
