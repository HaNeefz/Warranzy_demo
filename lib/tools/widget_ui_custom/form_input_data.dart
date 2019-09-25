import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/services/method/mark_text_input_format.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';

import '../theme_color.dart';
import 'text_builder.dart';

class FormWidgetBuilder {
  static Widget formWidget(
      {@required String title, @required Widget child, bool showTitle = true}) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(width: 0.3, color: ThemeColors.COLOR_GREY),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (showTitle == true)
              TextBuilder.build(
                  title: title,
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 15)),
            child,
          ],
        ));
  }

  static Widget formDropDown(
      {@required key,
      @required String title,
      @required List items,
      @required validate,
      String hint,
      Function(String value) onChange}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 0.3, color: ThemeColors.COLOR_GREY),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextBuilder.build(
              title: title,
              style: TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 15)),
          FormBuilderDropdown(
            attribute: key,
            // initialValue: items.first,
            onChanged: onChange,
            hint: TextBuilder.build(
                title: "$hint",
                style: TextStyleCustom.STYLE_CONTENT.copyWith(fontSize: 15)),
            items: items
                .map<DropdownMenuItem>((data) => DropdownMenuItem(
                      child: TextBuilder.build(
                        title: "${items.indexOf(data) + 1}. \t\t$data",
                        style:
                            TextStyleCustom.STYLE_LABEL.copyWith(fontSize: 15),
                      ),
                      value: data,
                    ))
                .toList(),
            validators: validate, //<DropdownMenuItem>[],
          )
        ],
      ),
    );
  }

  static Widget formDropDownCategory(
      {@required key,
      @required String title,
      @required List<ProductCategory> items,
      @required validate,
      String hint,
      Function onChange}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 0.3, color: ThemeColors.COLOR_GREY),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextBuilder.build(
              title: title,
              style: TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 15)),
          FormBuilderDropdown(
            attribute: key,
            // initialValue: items.first,
            onChanged: onChange,
            hint: TextBuilder.build(
                title: "$hint",
                style: TextStyleCustom.STYLE_CONTENT.copyWith(fontSize: 15)),
            items: items
                .map<DropdownMenuItem>((data) => DropdownMenuItem(
                      child: TextBuilder.build(
                        title: "${data.catCode}. \t\t${data.modelCatName}",
                        style:
                            TextStyleCustom.STYLE_LABEL.copyWith(fontSize: 15),
                      ),
                      value: data.catCode,
                    ))
                .toList(),
            validators: validate, //<DropdownMenuItem>[],
          )
        ],
      ),
    );
  }

  static Widget formInputData(
      {@required String key,
      @required validators,
      @required String title,
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
      List<TextInputFormatter> inputFormatters = const [],
      Widget prefix,
      Widget suffix,
      bool readOnly = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
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
              style: TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 15)),
          FormBuilderTextField(
            attribute: key,
            validators: validators != null ? validators : null,
            controller: textContrl,
            autovalidate: autovalidate,
            inputFormatters: inputFormatters,
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

  static Widget formInputDataNotValidate(
      {@required String title,
      TextEditingController controller,
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
      margin: EdgeInsets.symmetric(vertical: 5),
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
              style: TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 15)),
          TextField(
            controller: controller,
            maxLength: maxLength,
            textAlign: textAlign,
            maxLines: maxLine,
            obscureText: obsecure,
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
}
/*
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
*/
