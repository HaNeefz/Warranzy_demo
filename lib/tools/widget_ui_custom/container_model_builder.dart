import 'package:flutter/material.dart';
import '../theme_color.dart';

class ModelContainerBuilder {
  static Widget build({
    @required Widget child,
    double width,
    double height,
    EdgeInsetsGeometry magin,
    EdgeInsetsGeometry padding,
    double borderWidth = 0.5,
    Color colorsBorder = ThemeColors.COLOR_THEME_APP,
    Color color = ThemeColors.COLOR_TRANSPARENT,
    double borderRadius = 20,
  }) {
    return Container(
      margin: magin ?? EdgeInsets.all(5.0),
      padding: padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: color,
          border: Border.all(width: borderWidth, color: colorsBorder),
          borderRadius: BorderRadius.circular(borderRadius)),
      child: child,
    );
  }
}
