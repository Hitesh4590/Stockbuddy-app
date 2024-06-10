import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/theme/color_constants.dart';

class TextStyles {
  TextStyles._();

  static const String poppins = 'Poppins';

  static TextStyle button = regular(color: ColorConstants.white);
  static TextStyle regularBlack({
    double fontSize = 12,
    Color color = Colors.black,
    TextDecoration? textDecoration,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w400,
        fontFamily: poppins,
        decoration: textDecoration,
        letterSpacing: letterSpacing,
        fontStyle: fontStyle,
      );
  static TextStyle smallBlack({
    double fontSize = 10,
    Color color = Colors.black,
    TextDecoration? textDecoration,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w400,
        fontFamily: poppins,
        decoration: textDecoration,
        letterSpacing: letterSpacing,
        fontStyle: fontStyle,
      );
  static TextStyle regular({
    double fontSize = 12,
    Color color = ColorConstants.lightGrey,
    TextDecoration? textDecoration,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w400,
        fontFamily: poppins,
        decoration: textDecoration,
        letterSpacing: letterSpacing,
        fontStyle: fontStyle,
      );
  static TextStyle small({
    double fontSize = 10,
    Color color = ColorConstants.lightGrey,
    TextDecoration? textDecoration,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w400,
        fontFamily: poppins,
        decoration: textDecoration,
        letterSpacing: letterSpacing,
        fontStyle: fontStyle,
      );

  static TextStyle medium({
    double fontSize = 14,
    Color color = ColorConstants.darkGrey,
    TextDecoration? textDecoration,
    double? height,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w500,
        fontFamily: poppins,
        decoration: textDecoration,
        height: height,
        letterSpacing: letterSpacing,
        fontStyle: fontStyle,
      );

  static TextStyle bold({
    double fontSize = 12,
    Color color = ColorConstants.darkGrey,
    TextDecoration? textDecoration,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w600,
        fontFamily: poppins,
        decoration: textDecoration,
        letterSpacing: letterSpacing,
        fontStyle: fontStyle,
      );
}
