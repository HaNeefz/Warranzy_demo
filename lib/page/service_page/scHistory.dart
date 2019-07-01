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
        body: Container(
          child: Center(child: TextBuilder.build(title: "History")),
        ),
      ),
    );
  }
}
