import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';

import '../theme_color.dart';

class TextFieldBuilder {
  static Widget enterInformation(
      {@required String key,
      @required validators,
      TextEditingController textContrl,
      String hintText,
      IconData prefixIcon,
      FocusNode focusNode,
      int maxLength,
      int maxLine,
      TextAlign textAlign = TextAlign.start,
      bool obsecure = false,
      TextInputType keyboardType,
      TextInputAction textInputAction,
      bool readOnly = false}) {
    return Container(      
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(width: 0.5, color: COLOR_THEME_APP),
        borderRadius: BorderRadius.circular(15.0),
        // boxShadow: [
        //   BoxShadow(
        //     blurRadius: 5,
        //     color: Colors.teal,
        //     spreadRadius: 1,
        //   )
        // ]
      ),
      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
      margin: EdgeInsets.all(8.0),
      height: 90.0,
      child: FormBuilderTextField(
        attribute: key,
        validators: validators,
        controller: textContrl,
        autovalidate: true,
        maxLength: maxLength,
        textAlign: textAlign,
        maxLines: maxLine,
        obscureText: obsecure,
        keyboardType: keyboardType ??= TextInputType.text,
        readonly: readOnly,
        textInputAction: textInputAction ??= TextInputAction.done,
        style: TextStyleCustom.STYLE_LABEL.copyWith(fontSize: 18),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "\t\t\t" + hintText,
            hintStyle: TextStyleCustom.STYLE_LABEL,
            counterStyle: TextStyleCustom.STYLE_LABEL,
            errorStyle:
                TextStyleCustom.STYLE_ERROR,
            prefixIcon: Container(
                width: 40.0,
                height: 40.0,
                margin: EdgeInsets.only(right: 10),                
                decoration: BoxDecoration(
                    color: COLOR_THEME_APP,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(10.0),
                        right: Radius.circular(10.0))),
                child: Icon(
                  prefixIcon,
                  color: Colors.black,
                ))),
      ),
    );
  }
}
