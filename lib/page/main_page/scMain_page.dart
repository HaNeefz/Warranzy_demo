import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:warranzy_demo/page/asset_page/scAssets.dart';
import 'package:warranzy_demo/page/notification_page/scNotification.dart';
import 'package:warranzy_demo/page/service_page/scService.dart';
import 'package:warranzy_demo/page/trade_page/scTrade.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  int currentPageBar = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 4, vsync: this, initialIndex: currentPageBar)
          ..animateTo(currentPageBar);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          body: SafeArea(
            child: TabBarView(
              // controller: _tabController,
              children: <Widget>[
                AssetPage(),
                ClaimAndServicePage(),
                TradePage(),
                NotificationPage()
              ],
            ),
          ),
          bottomNavigationBar: Container(
            // color: Colors.black,
            decoration: BoxDecoration(
              color: COLOR_WHITE,
              borderRadius: BorderRadius.circular(40),
            ),
            child: TabBar(
              tabs: <Widget>[
                tabWidget(icons: Icons.card_giftcard, text: "Asset"),
                tabWidget(icons: Icons.card_giftcard, text: "Asset"),
                tabWidget(icons: Icons.card_giftcard, text: "Asset"),
                tabWidget(icons: Icons.card_giftcard, text: "Asset"),
              ],
            ),
          )
          // FancyBottomNavigation(
          //   tabs: [
          //     TabData(iconData: Icons.card_giftcard, title: "Asset"),
          //     TabData(iconData: Icons.timeline, title: "Service"),
          //     TabData(iconData: Icons.account_balance, title: "Trade"),
          //     TabData(iconData: Icons.notifications_active, title: "Notification"),
          //   ],
          //   onTabChangedListener: (position) {
          //     setState(() {
          //       currentPageBar = position;
          //       _tabController.animateTo(currentPageBar);
          //     });
          //   },
          // ),
          ),
    );
  }

  Widget tabWidget({IconData icons, String text}) {
    return Tab(
      icon: Icon(
        icons,
        color: COLOR_THEME_APP,
      ),
      child:
          TextBuilder.build(title: "$text", style: TextStyleCustom.STYLE_LABEL),
    );
  }
}
