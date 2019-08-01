import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warranzy_demo/page/asset_page/scAssets.dart';
import 'package:warranzy_demo/page/notification_page/scNotification.dart';
import 'package:warranzy_demo/page/service_page/scService.dart';
import 'package:warranzy_demo/page/trade_page/scTrade.dart';
import 'package:warranzy_demo/services/providers/notification_state.dart';
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
  final List<Widget> pageTabBar = [
    AssetPage(),
    ClaimAndServicePage(),
    TradePage(),
    NotificationPage()
  ];

  @override
  Widget build(BuildContext context) {
    final NotificationState notiState = Provider.of<NotificationState>(context);
    var textStyle = TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14);
    return Scaffold(
        body: SafeArea(child: pageTabBar[currentPage]),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                title: TextBuilder.build(title: "Asset", style: textStyle),
                icon: Icon(
                  Icons.card_giftcard,
                )),
            BottomNavigationBarItem(
                title: TextBuilder.build(title: "Service", style: textStyle),
                icon: Icon(
                  Icons.timeline,
                )),
            BottomNavigationBarItem(
                title: TextBuilder.build(title: "Trade", style: textStyle),
                icon: Icon(
                  Icons.account_balance,
                )),
            BottomNavigationBarItem(
              title: TextBuilder.build(title: "Notification", style: textStyle),
              icon: notiState.emptyMessage
                  ? Icon(
                      Icons.notifications,
                    )
                  : Badge(
                      badgeContent: TextBuilder.build(
                          title: "${notiState.counterMessage}",
                          style: textStyle.copyWith(color: COLOR_WHITE)),
                      child: Icon(Icons.notifications_active),
                    ),
            ),
          ],
          currentIndex: currentPage,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: COLOR_THEME_APP,
          unselectedItemColor: COLOR_BLACK,
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
}
