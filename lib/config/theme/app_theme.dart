import 'package:flutter/material.dart';

/// 🎨 Paleta de colores principal
class AppColors {
  static const Color piedra = Color(0xFFF5F3eB); // Amarillo piedra
  static const Color arena = Color(0xFFD9C9AE); // Beige arena
  static const Color almendra = Color(0xFF896B5A); // Marrón almendra
  static const Color cafeNoir = Color(0xFF51382A); // Azul oscuro afe noir
}

class AppTheme {
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    fontFamily: 'Sculpin',

    /// 🌈 Definir el esquema de color con almendra como semilla base
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.almendra,
      primary: AppColors.almendra,
      secondary: AppColors.piedra,
      surface: AppColors.piedra,
      background: AppColors.piedra,
      tertiary: AppColors.cafeNoir,
      brightness: Brightness.light,
    ),

    /// 📝 Estilos de texto
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 20,
        color: AppColors.cafeNoir,
      ),
      bodyMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: AppColors.cafeNoir,
      ),
      bodySmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: AppColors.cafeNoir,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: AppColors.cafeNoir,
      ),
    ),

    /// 🔘 Botones elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.almendra,
        foregroundColor: Colors.white,
        minimumSize: const Size(140, 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    ),

    /// 🟨 Estilo general de AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.piedra,
      foregroundColor: AppColors.cafeNoir,
      titleTextStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: AppColors.cafeNoir,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.piedra,
        foregroundColor: AppColors.piedra,
        textStyle: TextStyle(color: AppColors.cafeNoir),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.piedra,
        side: BorderSide(color:  AppColors.arena) ,
        textStyle: TextStyle(color: AppColors.cafeNoir),
      ),
    ),
  );
}
