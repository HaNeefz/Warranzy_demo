import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';

import '../theme_color.dart';
import 'text_builder.dart';

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
      bool autovalidate = false,
      Widget prefix,
      Widget suffix,
      bool readOnly = false}) {
    return Container(
      child: FormBuilderTextField(
        attribute: key,
        validators: validators,
        controller: textContrl,
        autovalidate: autovalidate,
        maxLength: maxLength,
        textAlign: textAlign,
        maxLines: maxLine,
        obscureText: obsecure,
        initialValue: initialValue,
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
            counterStyle: TextStyleCustom.STYLE_LABEL.copyWith(fontSize: 14),
            errorStyle: TextStyleCustom.STYLE_ERROR,
            prefixIcon: prefix,
            suffixIcon: suffix),
      ),
    );
  }

  static Widget formInputData(
      {@required String key,
      @required validators,
      String title,
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
      double size = 5,
      bool borderOutLine = false,
      String initialValue,
      bool autovalidate = false,
      Widget prefix,
      Widget suffix,
      bool readOnly = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 0.3, color: ThemeColors.COLOR_GREY),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextBuilder.build(
              title: readOnly == true ? title + " (read only)" : title,
              style: TextStyleCustom.STYLE_CONTENT.copyWith(fontSize: 15)),
          FormBuilderTextField(
            attribute: key,
            validators: validators,
            controller: textContrl,
            autovalidate: autovalidate,
            maxLength: maxLength,
            textAlign: textAlign,
            maxLines: maxLine,
            obscureText: obsecure,
            initialValue: initialValue,
            keyboardType: keyboardType ??= TextInputType.text,
            readonly: readOnly,
            textInputAction: textInputAction ??= TextInputAction.done,
            style: TextStyleCustom.STYLE_LABEL.copyWith(fontSize: 15),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal[300])),
                // InputBorder.none,
                errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal[300])),
                labelText: label != null ? label : null,
                labelStyle: TextStyleCustom.STYLE_LABEL,
                hintText: "\t\t\t ${hintText ?? ""}",
                hintStyle: TextStyleCustom.STYLE_CONTENT,
                counterStyle:
                    TextStyleCustom.STYLE_LABEL.copyWith(fontSize: 14),
                errorStyle: TextStyleCustom.STYLE_ERROR,
                prefixIcon: prefix,
                suffixIcon: suffix),
          ),
        ],
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

  static Widget textFormFieldCustom({
    @required final TextEditingController controller,
    @required String title,
    bool borderOutLine = false,
    int maxLength,
    int maxLine = 1,
    bool validet = true,
  }) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
                child: Center(
                    child: Text(
              "${title ?? "title's empty"}:",
              textAlign: TextAlign.center,
            ))),
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TextFormField(
                    controller: controller,
                    validator: (s) {
                      if(validet == true)
                      if (s.isEmpty) {
                        return "Please enter data";
                      }
                      return null;
                    },
                    maxLength: maxLength,
                    maxLines: maxLine,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[100],
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                      border:
                          // borderOutLine
                          //     ? OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(30),
                          //         borderSide: BorderSide(color: Colors.teal[300]))
                          //     : UnderlineInputBorder(
                          //         borderRadius: BorderRadius.circular(30),
                          //         borderSide: BorderSide(color: Colors.teal[300])),
                          InputBorder.none,
                      errorBorder: InputBorder.none,
                      // borderOutLine
                      //     ? OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(30),
                      //         borderSide: BorderSide(color: Colors.teal[300]))
                      //     : UnderlineInputBorder(
                      //         borderRadius: BorderRadius.circular(30),
                      //         borderSide: BorderSide(color: Colors.teal[300])),
                    )),
              ),
            ),
          ],
        ),
        Divider()
      ],
    );
  }
}
