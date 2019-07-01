import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              TextBuilder.build(title: "Popular",style: TextStyleCustom.STYLE_LABEL_BOLD),
              TextBuilder.build(title: "Electronics",style: TextStyleCustom.STYLE_LABEL_BOLD),
              TextBuilder.build(title: "Tablet",style: TextStyleCustom.STYLE_LABEL_BOLD),
              TextBuilder.build(title: "Cleaning",style: TextStyleCustom.STYLE_LABEL_BOLD),
            ],
          ),
        ),
        body: Container(
          child: Center(child: TextBuilder.build(title: "History")),
        ),
      ),
    );
  }
}
