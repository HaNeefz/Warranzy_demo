import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/theme_color.dart';

import 'text_builder.dart';

class ButtonBuilder {
  static Widget build(
      {@required BuildContext context,
      @required String label,
      TextStyle labelStyle,
      double height = 55.0,
      Color colorsButton,
      double elevation = 0.0,
      double cornerRadius = 25.0,
      Function onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        decoration: BoxDecoration(
            border: colorsButton == null
                ? Border.all(width: 0.5, color: COLOR_THEME_APP)
                : null,
            gradient: LinearGradient(colors: <Color>[
              Colors.teal[300],
              Colors.teal[200],
              Colors.teal[100]
            ]),
            borderRadius: BorderRadius.circular(cornerRadius)),
        child: RaisedButton(
          splashColor: Colors.teal[300],
          // color: colorsButton ?? COLOR_TRANSPARENT,
          elevation: elevation,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cornerRadius)),
          child: TextBuilder.build(
              title: label,
              style: labelStyle ?? TextStyleCustom.STYLE_LABEL_BOLD),
          onPressed: onPressed,
        ),
      ),
    );
  }

  static Widget buttonCustom(
      {@required BuildContext context,
      @required String label,
      TextStyle labelStyle,
      double height = 55.0,
      Color colorsButton,
      double elevation = 0.0,
      double cornerRadius = 25.0,
      double paddingValue = 50.0,
      Function onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingValue),
      child: InkWell(
        borderRadius: BorderRadius.circular(cornerRadius),
        splashColor: Colors.white,
        onTap: onPressed,
        child: Container(
          height: 55,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: colorsButton != null
                  ? Border.all(width: 0.5, color: Colors.teal[300])
                  : null,
              borderRadius: BorderRadius.circular(cornerRadius),
              gradient: colorsButton == null
                  ? LinearGradient(
                      colors: <Color>[Colors.teal[300], Colors.teal[100]])
                  : null),
          child: Center(
              child: TextBuilder.build(
                  title: label,
                  style: labelStyle ??
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(
                          color: colorsButton == null
                              ? COLOR_WHITE
                              : Colors.teal[300]))),
        ),
      ),
    );
  }
}

buttonCustom(BuildContext context, String label, Function onPressed,
    {Color colors, TextStyle textStyle}) {
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.white),
          borderRadius: BorderRadius.circular(10.0)),
      child: RaisedButton(
        splashColor: Colors.teal,
        color: colors ?? Colors.transparent,
        // elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Text(
          label,
          style: textStyle ?? TextStyle(color: Colors.white),
        ),
        onPressed: onPressed,
      ),
    ),
  );
}
