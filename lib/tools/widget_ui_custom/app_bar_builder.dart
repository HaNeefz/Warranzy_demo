import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';

import 'text_builder.dart';

class AppBarTheme {
  static AppBar appBarStyle(
      {@required String title,
      TextStyle style,
      Color background,
      List<Widget> actions}) {
    return AppBar(
      title: TextBuilder.build(
          title: title, style: style ??= TextStyleCustom.STYLE_APPBAR),
      backgroundColor: background,
      actions: actions,
    );
  }
}
