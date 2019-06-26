import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/theme_color.dart';

import 'text_builder.dart';

class ButtonBuilder {
  static Widget build(
      {@required BuildContext context,
      @required String label,
      TextStyle labelStyle,
      double height = 50.0,
      Color colorsButton,
      double elevation = 0.0,
      double cornerRadius = 10.0,
      Function onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        decoration: BoxDecoration(
            border: colorsButton == null
                ? Border.all(width: 0.5, color: COLOR_THEME_APP)
                : null,
            borderRadius: BorderRadius.circular(cornerRadius)),
        child: RaisedButton(
          splashColor: COLOR_THEME_APP,
          color: colorsButton ?? COLOR_TRANSPARENT,
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
    // Padding(
    //   padding: const EdgeInsets.all(6.0),
    //   child: InkWell(
    //     onTap: onPressed,
    //     child: Container(
    //       width: MediaQuery.of(context).size.width,
    //       decoration: BoxDecoration(
    //           border: Border.all(width: 0.5, color: COLOR_THEME_APP),
    //           color: colorsButton ??= COLOR_TRANSPARENT,
    //           borderRadius: BorderRadius.circular(cornerRadius)),
    //       height: height,
    //       child: Center(
    //         child: TextBuilder.build(
    //             title: label,
    //             style: labelStyle ?? TextStyleCustom.STYLE_LABEL_BOLD),
    //       ),
    //     ),
    //   ),
    // );
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
