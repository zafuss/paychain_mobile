import 'package:flutter/material.dart';
import 'package:paychain_mobile/config/color_const.dart';
import 'package:paychain_mobile/config/demension_const.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600, // SemiBold
          fontFamily: 'Poppins',
        ), // Thay thế cho headline1
        displayMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600, // SemiBold
          fontFamily: 'Poppins',
        ), // Thay thế cho headline2
        displaySmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600, // SemiBold
          fontFamily: 'Poppins',
        ), // Thay thế cho headline3
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500, // Medium
          fontFamily: 'Poppins',
        ), // Thay thế cho bodyText1
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400, // Regular
          fontFamily: 'Poppins',
        ), // Thay thế cho bodyText2
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600, // SemiBold
          color: Colors.black54,
          fontFamily: 'Poppins',
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500, // Medium
          color: Colors.black54,
          fontFamily: 'Poppins',
        ),
        labelMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500, // Medium
          color: Colors.black54,
          fontFamily: 'Poppins',
        ),
      ),
      colorSchemeSeed: ColorPalette.primary1,
      scaffoldBackgroundColor: Colors.white,
      // textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
      // colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.black),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        textStyle:
            WidgetStateProperty.all<TextStyle>(const TextStyle(fontSize: 16)),
        alignment: Alignment.center,
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStateProperty.all<TextStyle>(
            const TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            ColorPalette.primary1,
          ),
          minimumSize:
              WidgetStateProperty.all<Size>(const Size(double.infinity, 53.0)),
          foregroundColor: WidgetStateProperty.all<Color>(
            Colors.white,
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15.0), // Đặt borderRadius mặc định
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStateProperty.all<TextStyle>(
            const TextStyle(color: ColorPalette.primary1, fontSize: 16),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            Colors.white,
          ),
          minimumSize:
              WidgetStateProperty.all<Size>(const Size(double.infinity, 53.0)),
          foregroundColor: WidgetStateProperty.all<Color>(
            ColorPalette.primary1,
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15.0), // Đặt borderRadius mặc định
            ),
          ),
        ),
      ),
      // inputDecorationTheme: const InputDecorationTheme(
      //   focusedBorder:
      // ),

      buttonTheme: ButtonThemeData(
        height: 53,
        minWidth: 293,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
      ),
      // scaffoldBackgroundColor: ColorPalette.neutral5,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: ColorPalette.tfBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: ColorPalette.primary1, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.red, width: 2.5),
        ),
        hintStyle: TextStyle(color: ColorPalette.tfBorder),
        labelStyle: TextStyle(color: ColorPalette.tfBorder),
      ),
      useMaterial3: true,
    );
  }

  // static ThemeData darkTheme() {
  //   return ThemeData(
  //     // Define the primary color for your dark theme
  //     primaryColor: Colors.grey[800],
  //     // Define the accent color for your dark theme
  //     accentColor: Colors.tealAccent,
  //     // Define the text theme for your dark theme
  //     textTheme: TextTheme(
  //       headline1: TextStyle(
  //           fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
  //       bodyText1: TextStyle(fontSize: 16, color: Colors.white),
  //     ),
  //     // Define other properties of the theme as needed
  //     // For example, you can set the brightness, scaffoldBackgroundColor, etc.
  //   );
  // }
}
