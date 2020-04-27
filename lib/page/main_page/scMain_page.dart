import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/page/asset_page/scAssets.dart';
import 'package:warranzy_demo/page/notification_page/scNotification.dart';
import 'package:warranzy_demo/page/service_page/scService.dart';
import 'package:warranzy_demo/page/trade_page/scTrade.dart';
import 'package:warranzy_demo/services/providers/asset_state.dart';
import 'package:warranzy_demo/services/providers/notification_state.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class MainPage extends StatefulWidget {
  int currentPage;

  MainPage({Key key, this.currentPage = 0}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  int get currentPage => widget.currentPage;
  set setPage(newPage) => widget.currentPage = newPage;
  // int currentPageBar = 0;
  PageController pagesController;
  AssetStateTest _assetState = AssetStateTest();
  final List<Widget> pageTabBar = [
    AssetPage(
      key: PageStorageKey("AssetPage"),
    ),
    ClaimAndServicePage(key: PageStorageKey("ClaimAndServicePage")),
    TradePage(key: PageStorageKey("TradePage")),
    NotificationPage(key: PageStorageKey("NotificationPage"))
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    final NotificationState notiState = Provider.of<NotificationState>(context);
    var textStyle = TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14);
    double _width = 30;
    double _height = 30;
    return Scaffold(
        body: PageStorage(
          child: pageTabBar[currentPage],
          bucket: bucket,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          // selectedLabelStyle:
          items: <BottomNavigationBarItem>[
            buttomNavigatorItem(
                iconsPath: Assets.ICON_ASSET,
                title: "Asset",
                style: textStyle,
                width: _width,
                height: _height),
            buttomNavigatorItem(
                iconsPath: Assets.ICON_SERVICE,
                title: "Service",
                style: textStyle,
                width: _width,
                height: _height),
            buttomNavigatorItem(
                iconsPath: Assets.ICON_TRADE,
                title: "Trade",
                style: textStyle,
                width: _width,
                height: _height),
            BottomNavigationBarItem(
              title: TextBuilder.build(title: "Notification", style: textStyle),
              icon: notiState.emptyMessage
                  ? Image.asset(Assets.ICON_NOTIFICATION,
                      width: _width, height: _height)
                  : Badge(
                      badgeContent: TextBuilder.build(
                          title: "${notiState.counterMessage}",
                          style: textStyle.copyWith(
                              color: ThemeColors.COLOR_WHITE)),
                      child: Icon(
                        Icons.notifications_active,
                        size: 35,
                      ),
                    ),
              activeIcon: notiState.emptyMessage
                  ? Image.asset(Assets.ICON_NOTIFICATION,
                      width: _width,
                      height: _height,
                      color: ThemeColors.COLOR_THEME_APP)
                  : Badge(
                      badgeContent: TextBuilder.build(
                          title: "${notiState.counterMessage}",
                          style: textStyle.copyWith(
                              color: ThemeColors.COLOR_THEME_APP)),
                      child: Icon(
                        Icons.notifications_active,
                        size: 35,
                      ),
                    ),
            ),
          ],
          currentIndex: currentPage,
          selectedItemColor: ThemeColors.COLOR_THEME_APP,
          unselectedItemColor: ThemeColors.COLOR_BLACK,
          selectedFontSize: 15,
          onTap: (position) {
            setState(() {
              setPage = position;
            });
          },
        )
        // FancyBottomNavigation(
        //   tabs: [
        //     TabData(iconData: Icons.card_giftcard, title: "Asset"),
        //     TabData(iconData: Icons.timeline, title: "Service"),
        //     TabData(iconData: Icons.account_balance, title: "Trade"),
        //     TabData(
        //         iconData: iconsWithBadges(notiState), title: "Notification"),
        //   ],
        //   onTabChangedListener: (position) {
        //     setState(() {
        //       setPage = position;
        //     });
        //   },
        // )
        );
  }

  IconData iconsWithBadges(NotificationState notiState) {
    return notiState.emptyMessage
        ? Icons.notifications
        : Icons.notifications_active;
  }

  BottomNavigationBarItem buttomNavigatorItem(
      {String iconsPath,
      String title,
      TextStyle style,
      double width,
      double height}) {
    return BottomNavigationBarItem(
        title: TextBuilder.build(title: title, style: style),
        icon: Image.asset(iconsPath, width: width, height: height),
        activeIcon: Image.asset(
          iconsPath,
          width: width,
          height: height,
          color: ThemeColors.COLOR_THEME_APP,
        ));
  }
}
