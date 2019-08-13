import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import 'scHistory.dart';
import 'scProcess.dart';

class ClaimAndServicePage extends StatefulWidget {
  @override
  _ClaimAndServicePageState createState() => _ClaimAndServicePageState();
}

class _ClaimAndServicePageState extends State<ClaimAndServicePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ThemeColors.COLOR_WHITE,
          title: TextBuilder.build(
              title: "Claim & Service",
              style: TextStyleCustom.STYLE_APPBAR.copyWith(color: ThemeColors.COLOR_BLACK)),
          bottom: TabBar(
            indicatorColor: ThemeColors.COLOR_THEME_APP,
            labelPadding: EdgeInsets.symmetric(vertical: 10),
            tabs: <Widget>[
              TextBuilder.build(
                  title: "Process", style: TextStyleCustom.STYLE_LABEL_BOLD),
              TextBuilder.build(
                  title: "History", style: TextStyleCustom.STYLE_LABEL_BOLD),
            ],
          ),
        ),
        body: Container(
          child: TabBarView(
            children: <Widget>[
              ProcessPage(),
              HistoryPage(),
            ],
          ),
        ),
      ),
    );
  }
}
