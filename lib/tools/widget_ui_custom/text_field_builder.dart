import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';

import '../theme_color.dart';

class TextFieldBuilder {
  static Widget enterInformation(
      {@required String key,
      @required validators,
      TextEditingController textContrl,
      String label,
      String hintText,
      FocusNode focusNode,
      int maxLength,
      int maxLine,
      TextAlign textAlign = TextAlign.start,
      bool obsecure = false,
      TextInputType keyboardType,
      TextInputAction textInputAction,
      double size = 12,
      bool borderOutLine = true,
      String initialValue,
      Widget prefix,
      Widget suffix,
      bool readOnly = false}) {
    return Container(
      child: FormBuilderTextField(
        attribute: key,
        validators: validators,
        controller: textContrl,
        autovalidate: false,
        maxLength: maxLength,
        textAlign: textAlign,
        maxLines: maxLine,
        obscureText: obsecure,
        initialValue: initialValue ?? null,
        keyboardType: keyboardType ??= TextInputType.text,
        readonly: readOnly,
        textInputAction: textInputAction ??= TextInputAction.done,
        style: TextStyleCustom.STYLE_LABEL.copyWith(fontSize: 15),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(size),
            border: borderOutLine
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal[300]))
                : UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal[300])),
            //InputBorder.none,
            errorBorder: borderOutLine
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal[300]))
                : UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal[300])),
            labelText: label != null ? label : null,
            labelStyle: TextStyleCustom.STYLE_LABEL,
            hintText: "\t\t\t ${hintText ?? ""}",
            hintStyle: TextStyleCustom.STYLE_CONTENT,
            counterStyle: TextStyleCustom.STYLE_LABEL,
            errorStyle: TextStyleCustom.STYLE_ERROR,
            prefixIcon: prefix,
            suffixIcon: suffix),
      ),
    );
  }

  static Widget custom(
      {@required String key,
      @required validators,
      TextEditingController textContrl,
      String label,
      String hintText,
      FocusNode focusNode,
      int maxLength,
      int maxLine,
      TextAlign textAlign = TextAlign.start,
      bool obsecure = false,
      TextInputType keyboardType,
      TextInputAction textInputAction,
      double size = 12,
      bool borderOutLine = true,
      String initialValue,
      Widget prefix,
      Widget suffix,
      bool readOnly = false}) {
    return Container(
      child: FormBuilderTextField(
        attribute: key,
        validators: validators,
        controller: textContrl,
        autovalidate: false,
        maxLength: maxLength,
        textAlign: textAlign,
        maxLines: maxLine,
        obscureText: obsecure,
        initialValue: initialValue ?? null,
        keyboardType: keyboardType ??= TextInputType.text,
        readonly: readOnly,
        textInputAction: textInputAction ??= TextInputAction.done,
        style: TextStyleCustom.STYLE_LABEL.copyWith(fontSize: 15),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(size),
            border: borderOutLine
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal[300]))
                : UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal[300])),
            //InputBorder.none,
            errorBorder: borderOutLine
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal[300]))
                : UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal[300])),
            labelText: label != null ? label : null,
            labelStyle: TextStyleCustom.STYLE_LABEL,
            hintText: "\t\t\t ${hintText ?? ""}",
            hintStyle: TextStyleCustom.STYLE_CONTENT,
            counterStyle: TextStyleCustom.STYLE_LABEL,
            errorStyle: TextStyleCustom.STYLE_ERROR,
            prefixIcon: prefix,
            suffixIcon: suffix),
      ),
    );
  }
}
