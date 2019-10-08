import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warranzy_demo/page/asset_page/add_assets_page/scAdd_image_demo.dart';
import 'package:warranzy_demo/page/change_device_page/scChange_device.dart';
import 'package:warranzy_demo/page/pin_code/scPinCode.dart';
import 'package:warranzy_demo/services/providers/notification_state.dart';
import 'package:warranzy_demo/services/sqflit/db_customers.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
import 'package:warranzy_demo/services/sqflit/db_language.dart';
import 'package:warranzy_demo/tools/const.dart';
import '../../page/register/scRegister.dart';
import '../../tools/config/text_style.dart';
import '../../tools/export_lib.dart';
import '../../tools/theme_color.dart';
import '../../tools/widget_ui_custom/button_builder.dart';
import '../../tools/widget_ui_custom/text_builder.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  SharedPreferences _pref;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  NotificationState noti = NotificationState();
  bool hasAccount = false;
  @override
  void initState() {
    super.initState();
    iniFunction();
  }

  iniFunction() async {
    await noti.getNotificationID();
    await getDeviceInfo();
    checkHasCustomer();
  }

  getDeviceInfo() async {
    _pref = await SharedPreferences.getInstance();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // print('Running on ${androidInfo.androidId}');
      _pref.setString("DeviceID", androidInfo.androidId);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _pref.setString("DeviceID", iosInfo.identifierForVendor);
    } else {
      print("Another");
    }
    print('DeviceID : ${_pref.getString("DeviceID")}');
  }

  void checkHasCustomer() async {
    hasAccount = await DBProviderCustomer.db.checkHasCustomer();
    print("hasAccount => $hasAccount");
    setState(() {});
  }

  gotoRegisterPage() => ecsLib.pushPage(
        context: context,
        pageWidget: Register(),
      );

  gotoPinCodePage() => ecsLib.pushPage(
        context: context,
        pageWidget: PinCodePageUpdate(
          type: PageType.login,
          usedPin: true,
        ),
      );
  gotoChangeDevicePage() => ecsLib.pushPage(
        context: context,
        pageWidget: ChangeDevice(),
      );
  //ChangeDevice

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(child: ecsLib.logoApp()),
              TextBuilder.build(
                title: "Don't worry be Warranzy!!",
                style: TextStyleCustom.STYLE_APPBAR
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              TextBuilder.build(
                title: "Sign into your Account",
                style: TextStyleCustom.STYLE_CONTENT,
              ),
              SizedBox(
                height: 100.0,
              ),
              ButtonBuilder.buttonCustom(
                  context: context,
                  label: hasAccount == true
                      ? allTranslations.text("login")
                      : allTranslations.text("register"),
                  onPressed: () {
                    if (hasAccount == true) {
                      gotoPinCodePage();
                    } else {
                      gotoRegisterPage();
                    }
                  }),
              SizedBox(
                height: 20.0,
              ),
              ButtonBuilder.buttonCustom(
                  context: context,
                  label: allTranslations.text("change_device"),
                  colorsButton: ThemeColors.COLOR_WHITE,
                  onPressed: () {
                    gotoChangeDevicePage();
                  }),
              SizedBox(
                height: 20.0,
              ),
              // RaisedButton(
              //   child: Text("AddImageDemoPage Test"),
              //   onPressed: () {
              //     ecsLib.pushPage(
              //       context: context,
              //       pageWidget: AddImageDemo(),
              //     );
              //   },
              // ),
              // RaisedButton(
              //   child: Text("getDataCountry"),
              //   onPressed: () async {
              //     await DBProviderInitialApp.db.getAllDataCountry();
              //   },
              // ),
              // RaisedButton(
              //   child: Text("getDataTimeZone"),
              //   onPressed: () async {
              //     await DBProviderInitialApp.db.getAllDataTimeZone();
              //   },
              // ),
              // RaisedButton(
              //   child: Text("getDataProducCategory"),
              //   onPressed: () async {
              //     // await DBProviderInitialApp.db.getAllDataProductCategory();
              //     // await DBProviderInitialApp.db.deleteAllDataIn3Table();
              //     await DBProviderLanguage.db.deleteAllLanguage();
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
