import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const fontFamily = 'Changa';
const primaryColor = Color(0xFF1ca094);
const primaryColorLight = Color(0xFF4fac9f);
const cardColor = Color.fromARGB(255, 235, 255, 254);
const secondaryColor = Color(0xFFF9F871);
const whiteColor = Color(0xFFFFFFFF);
final themeLight = ThemeData(
  appBarTheme: const AppBarTheme(
    
      backgroundColor: primaryColor,
      iconTheme: IconThemeData(color: whiteColor),
      titleTextStyle: TextStyle(
          fontFamily: fontFamily, fontWeight: FontWeight.w900, fontSize: 20)),
  brightness: Brightness.light,
  primaryColor: primaryColor,
  primaryColorLight: primaryColorLight,
  cardColor: cardColor,
  fontFamily: fontFamily,
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor).copyWith(
    secondary: secondaryColor,
    brightness: Brightness.light,
  ),
);

// final themeDark = ThemeData(
//   brightness: Brightness.dark,
//   fontFamily: fontFamily,
//   appBarTheme: const AppBarTheme(
//       backgroundColor: primaryColor,
//       titleTextStyle: TextStyle(fontFamily: fontFamily)),
//   primaryColor: primaryColor,
//   primaryColorLight: primaryColorLight,
//   primaryColorDark: primaryColorDark,
//   cardColor: cardColorDark,
//   colorScheme: ColorScheme.fromSeed(seedColor: primaryColor).copyWith(
//     secondary: secondaryColorDark,
//     brightness: Brightness.dark,
//   ),
// );

// const cupTheme = CupertinoThemeData(
//     applyThemeToAll: true,
//     brightness: Brightness.light,
//     textTheme: CupertinoTextThemeData(primaryColor: primaryColor),
//     primaryColor: primaryColor);
// const cupThemeDark = CupertinoThemeData(
//     applyThemeToAll: true,
//     brightness: Brightness.dark,
//     primaryColor: primaryColor,
//     textTheme: CupertinoTextThemeData(primaryColor: primaryColor));
