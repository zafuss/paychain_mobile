import 'package:flutter/material.dart';
import 'package:paychain_mobile/utils/constants/color_const.dart';
import 'package:paychain_mobile/utils/constants/demension_const.dart';

extension ExtBoxDecoration on ThemeData {
  BoxDecoration get defaultBoxDecoration {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(defaultBorderRadius),
      boxShadow: [
        BoxShadow(
          color: ColorPalette.primary1.withOpacity(0.1), // Shadow color
          offset: Offset(0, 4), // x: 0, y: 4
          blurRadius: 30, // Blur radius
          spreadRadius: 0, // Spread radius
        ),
      ],
    );
  }
}
