import 'package:flutter/material.dart';

extension ImagePath on String {
  String get toPng => 'assets/images/$this.png';
  String get toSvg => 'assets/images/$this.svg';
  String get toJpg => 'assets/images/$this.jpg';
}

extension Emptypadding on num {
  SizedBox get ph => SizedBox(height: toDouble());
  SizedBox get pw => SizedBox(width: toDouble());
}

extension ThemeShortCuts on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  // ElevatedButtonThemeData get elevatedButtonTheme =>
  //     Theme.of(this).elevatedButtonTheme;
  // TextStyle? get headLinesmail => Theme.of(this).textTheme.headlineSmall;
  // Color? get prinmaryColor => Theme.of(this).primaryColor.;
}

extension MediaQueryValues on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  double get topPading => MediaQuery.of(this).padding.top;
}

//GoRouter.of(context).push('/openBookView');

