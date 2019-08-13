import 'package:flutter/material.dart';

import '../theme_color.dart';

const String fontFamily = ""; //"Ekkamai"; //Supermarket//Ekkamai

class TextStyleCustom {
  static const TextStyle STYLE_APPBAR = TextStyle(
      color: ThemeColors.COLOR_WHITE,
      fontSize: 24,
      // height: 1.2,
      // letterSpacing: 1.0,
      fontFamily: fontFamily,
      fontWeight: FontWeight.bold);

  static const TextStyle STYLE_TITLE = TextStyle(
      color: ThemeColors.COLOR_BLACK,
      height: 1.2,
      fontSize: 30.0,
      // letterSpacing: 1,
      fontFamily: fontFamily,
      fontWeight: FontWeight.w900);

  static const TextStyle STYLE_CONTENT = TextStyle(
      color: ThemeColors.COLOR_GREY,
      height: 1.2,
      // letterSpacing: 1,
      fontSize: 16.0,
      fontFamily: fontFamily);

  static const TextStyle STYLE_LABEL = TextStyle(
      color: ThemeColors.COLOR_BLACK,
      height: 1.2,
      // letterSpacing: 1,
      fontSize: 16.0,
      fontFamily: fontFamily);

  static const TextStyle STYLE_LABEL_BOLD = TextStyle(
      color: ThemeColors.COLOR_BLACK,
      height: 1.2,
      // letterSpacing: 1,
      fontSize: 16.0,
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700);

  static const TextStyle STYLE_DESCRIPTION = TextStyle(
      color: ThemeColors.COLOR_GREY,
      height: 1.2,
      // letterSpacing: 1,
      fontSize: 14.0,
      fontFamily: fontFamily);

  static const TextStyle STYLE_TEXT_UNDERLINE = TextStyle(
    color: ThemeColors.COLOR_THEME_APP,
    // letterSpacing: 1,
    fontSize: 14.0,
    decoration: TextDecoration.underline,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle STYLE_TEXT_ERROR = TextStyle(
    color: ThemeColors.COLOR_THEME_APP,
    // letterSpacing: 1,
    fontSize: 14.0,
    decoration: TextDecoration.underline,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle STYLE_ERROR = TextStyle(
      color: ThemeColors.COLOR_ERROR,
      height: 1.4,
      // letterSpacing: 1,
      fontSize: 13.0,
      fontFamily: fontFamily);
}
