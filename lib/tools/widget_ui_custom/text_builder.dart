import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';

class TextBuilder {
  static Widget build(
      {@required String title,
      TextStyle style,
      TextAlign textAlign,
      TextOverflow textOverflow}) {
    return Text(
      title,
      style: style ?? TextStyleCustom.STYLE_LABEL,
      textAlign: textAlign,
      overflow: textOverflow,      
    );
  }
}
