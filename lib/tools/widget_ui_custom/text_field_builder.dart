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
        readOnly: readOnly,
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
            readOnly: readOnly,
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
        readOnly: readOnly,
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

  static Widget textFormFieldCustom(
      {@required final TextEditingController controller,
      @required String title,
      bool borderOutLine = false,
      TextStyle titleStyle,
      TextInputType keyboardType = TextInputType.text,
      int maxLength,
      int maxLine = 1,
      bool validate = true,
      Function(String) onValidate,
      bool readOnly = false,
      Widget leader,
      Function(String) onChange,
      bool necessary = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "${title ?? "title's empty"}${necessary == true ? "*" : ""} :",
          // textAlign: TextAlign.center,
          style: titleStyle ??
              TextStyleCustom.STYLE_CONTENT
                  .copyWith(fontSize: 14, color: Colors.teal),
        ),
        Row(
          children: <Widget>[
            leader ?? Container(),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TextFormField(
                    controller: controller,
                    readOnly: readOnly,
                    validator: onValidate == null
                        ? (s) {
                            if (validate == true) if (s.isEmpty) {
                              return "Invalide, Please enter data.";
                            }
                            return null;
                          }
                        : (s) => onValidate(s),
                    maxLength: maxLength,
                    keyboardType: keyboardType,
                    maxLines: maxLine,
                    onChanged: (text) => onChange(text),
                    decoration: InputDecoration(
                      // hintText: title,
                      // hintStyle: TextStyleCustom.STYLE_LABEL
                      //     .copyWith(fontSize: 13, color: Colors.grey),
                      fillColor: Colors.grey[100],
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                      errorStyle: TextStyleCustom.STYLE_ERROR,
                      border: borderOutLine
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.teal[300]))
                          : UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.teal[300])),
                      // InputBorder.none,
                      errorBorder:
                          // InputBorder.none,
                          borderOutLine
                              ? OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.teal[300]))
                              : UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.teal[300])),
                    )),
              ),
            ),
          ],
        ),
        Divider()
      ],
    );
  }

  static Widget dropdownFormfield({
    String initalData,
    List<String> items,
    Function(String) onChange,
    Function(String) onSaved,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(filled: true, fillColor: Colors.grey[100]),
        value: initalData ?? "",
        items: items.isNotEmpty
            ? items.map((v) {
                return DropdownMenuItem<String>(
                  value: v,
                  child: TextBuilder.build(title: "$v"),
                );
              }).toList()
            : [
                DropdownMenuItem(
                  child: TextBuilder.build(title: "-"),
                )
              ],
        onChanged: onChange,
        onSaved: onSaved,
      ),
    );
  }
}
