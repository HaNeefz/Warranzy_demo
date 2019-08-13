import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';

import '../theme_color.dart';
import 'text_builder.dart';

class IconButtonThemeBuilder {
  static Widget build(
      {String label,
      IconData icons,
      double width = 80,
      double height = 80,
      int index,
      Function onPressed,
      String replaceIconsToNameImageAsset}) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(20.0),
        decoration: BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.white),
                    color: Colors.transparent,
                    shape: BoxShape.circle),
                child: icons is IconData
                    ? Icon(
                        icons,
                        size: 50.0,
                        color: ThemeColors.COLOR_ICONS_THEME,
                      )
                    : Padding(
                        child: replaceIconsToNameImageAsset.isNotEmpty
                            ? Image.asset(
                                replaceIconsToNameImageAsset,
                              )
                            : FlutterLogo(),
                        padding: EdgeInsets.all(10),
                      )),
            SizedBox(
              height: 20.0,
            ),
            TextBuilder.build(
                title: label ?? "", style: TextStyleCustom.STYLE_LABEL),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }
}
