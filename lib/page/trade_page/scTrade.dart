import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class TradePage extends StatefulWidget {
  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: _currentPage,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: COLOR_WHITE,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: IconButton(
              icon: Icon(
                Icons.supervisor_account,
                color: COLOR_THEME_APP,
                size: 40,
              ),
              onPressed: () {},
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  size: 40,
                  color: COLOR_THEME_APP,
                ),
                onPressed: () {},
              ),
            )
          ],
          title: TextBuilder.build(
              title: "Trade Market", style: TextStyleCustom.STYLE_APPBAR),
          bottom: TabBar(
            indicatorColor: COLOR_THEME_APP,
            // controller: _tabController,
            onTap: (i) {
              setState(() {
                _currentPage = i;
                // _tabController.animateTo(_currentPage);
              });
            },
            labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            tabs: <Widget>[
              TextBuilder.build(
                  title: "Popular",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Electronics",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Tablet",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Cleaning",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
            ],
          ),
        ),
        body: Container(
          child: TabBarView(
            children: <Widget>[
              TextBuilder.build(
                  title: "Popular",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Electronics",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Tablet",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Cleaning",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
