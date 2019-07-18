import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:warranzy_demo/page/asset_page/scAssets.dart';
import 'package:warranzy_demo/page/notification_page/scNotification.dart';
import 'package:warranzy_demo/page/service_page/scService.dart';
import 'package:warranzy_demo/page/trade_page/scTrade.dart';
import 'package:warranzy_demo/tools/export_lib.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  int currentPageBar = 0;
  PageController pagesController;
  final List<Widget> pageTabBar = [
    AssetPage(),
    ClaimAndServicePage(),
    TradePage(),
    NotificationPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: pageTabBar[currentPageBar]),
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(iconData: Icons.card_giftcard, title: "Asset"),
            TabData(iconData: Icons.timeline, title: "Service"),
            TabData(iconData: Icons.account_balance, title: "Trade"),
            TabData(
                iconData: Icons.notifications_active, title: "Notification"),
          ],
          onTabChangedListener: (position) {
            setState(() {
              currentPageBar = position;
            });
          },
        ));
  }
}
