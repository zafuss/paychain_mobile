import 'package:flutter/material.dart';

class ColorPalette {
  static const Color primary1 = Color(0xFF281C9D);
  static const Color primary2 = Color(0xFF56558B);
  static const Color primary3 = Color(0xFFA8A3D7);
  static const Color primary4 = Color(0xFFF2F1F9);

  // Neutral Colors
  static const Color neutral1 = Color(0xFF343434);
  static const Color neutral2 = Color(0xFF898989);
  static const Color neutral3 = Color(0xFFCACACA);
  static const Color neutral4 = Color(0xFFE0E0E0);
  static const Color neutral5 = Color(0xFFFFFFFF);

  // Semantic Colors
  static const Color red = Color(0xFFFF4267);
  static const Color blue = Color(0xFF0809FE);
  static const Color yellow = Color(0xFFFFAF2A);
  static const Color green = Color(0xFF52D5BA);
  static const Color orange = Color(0xFFFB6B1B);

  // TextField border colors:
  static const Color tfBorder = Color.fromRGBO(203, 203, 203, 1);
}

class AppTextStyles {
  static TextStyle? title1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600, // SemiBold
    fontFamily: 'Poppins',
  );

  static TextStyle title2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600, // SemiBold
    fontFamily: 'Poppins',
  );

  static TextStyle title3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    fontFamily: 'Poppins',
  );

  static TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
    fontFamily: 'Poppins',
  );

  static TextStyle body2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    fontFamily: 'Poppins',
  );

  static TextStyle body3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    fontFamily: 'Poppins',
  );

  static TextStyle caption1 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600, // SemiBold
    fontFamily: 'Poppins',
  );

  static TextStyle caption2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    fontFamily: 'Poppins',
  );
}
