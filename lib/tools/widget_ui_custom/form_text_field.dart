import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';

import '../theme_color.dart';
import 'text_builder.dart';

class FormEnterInformationBuilder {
  static Widget build(
      {@required String title, TextStyle style, List<Widget> children}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          border: Border.all(width: 0.8, color: ThemeColors.COLOR_THEME_APP),
          borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextBuilder.build(
                      title: title,
                      style: style ?? TextStyleCustom.STYLE_TITLE))),
          for (var child in children) child,          
          SizedBox(
            height: 8.0,
          )
        ],
      ),
    );
  }
}
