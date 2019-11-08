import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class AutoCompletedCustom {
  static AutoCompleteTextField<String> autoCompleteTextFieldCustom(
      {key,
      controller,
      dynamic suggestions,
      Function(String) onSubmit,
      returnWidget}) {
    return returnWidget = AutoCompleteTextField<String>(
      key: key,
      suggestions: suggestions,
      clearOnSubmit: false,
      controller: controller,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 30, 10, 20),
          hintText: "Search"),
      itemFilter: (item, query) {
        return item.toLowerCase().startsWith(query.toLowerCase());
      },
      itemSorter: (a, b) => //
          a.compareTo(b),
      itemBuilder: (context, item) {
        return _buildTextAutoCompleteCustom(item);
      },
      itemSubmitted: (item) => onSubmit(item),
    );
  }

  static Widget _buildTextAutoCompleteCustom(String item) => Container(
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextBuilder.build(
                  title: "$item", style: TextStyleCustom.STYLE_LABEL_BOLD),
            ),
            Divider()
          ],
        ),
      );
}
