import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:warranzy_demo/page/asset_page/scAssets.dart';
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
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 4, vsync: this, initialIndex: currentPageBar);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            AssetPage(),
            Icon(Icons.remove),
            Icon(Icons.account_balance),
            Icon(Icons.home),
          ],
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.card_giftcard, title: "Asset"),
          TabData(iconData: Icons.timeline, title: "Service"),
          TabData(iconData: Icons.account_balance, title: "Trade"),
          TabData(iconData: Icons.notifications_active, title: "Notification"),
        ],
        onTabChangedListener: (position) {
          setState(() {
            currentPageBar = position;
            _tabController.animateTo(currentPageBar);
          });
        },
      ),
    );
  }
}
