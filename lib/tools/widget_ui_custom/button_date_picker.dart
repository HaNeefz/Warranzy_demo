import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class ButtonDatePickerCustom {
  static final _ecsLib = getIt.get<ECSLib>();
  static String _showDate = '';
  static String _valueDate = '';

  static String get valueDate => _valueDate;
  static String get showDate => _showDate;
  static set setShowDate(value) => _showDate = value;

  static buttonDatePicker(BuildContext context, Function getValue) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: FlatButton(
        child: Align(
          child: TextBuilder.build(title: _showDate),
          alignment: Alignment.centerLeft,
        ),
        onPressed: () async {
          var date = await showDatePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            initialDate: DateTime.now(),
          );

          if (date != null) {
            _valueDate = _ecsLib.setDateFormat(date);
            _showDate = _valueDate.split(" ").first;
          } else
            _showDate = "-";

          getValue();
        },
      ),
    );
  }
}
