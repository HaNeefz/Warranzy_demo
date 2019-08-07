import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warranzy_demo/models/model_language.dart';
import 'package:warranzy_demo/page/login_first/scLogin.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:warranzy_demo/services/providers/notification_state.dart';
import 'package:warranzy_demo/services/sqflit/db_language.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();

  DBProviderLanguage get sqfliteDB => DBProviderLanguage.db;

  void ckeckLanguage() async {
    if (await sqfliteDB.checkHasLanguage() == false) {
      Picker(
          itemExtent: 40,
          adapter: PickerDataAdapter<String>(pickerdata: ["ไทย", "English"]),
          delimiter: [PickerDelimiter(child: Container())],
          hideHeader: true,
          confirmText: allTranslations.text("confirm"),
          // cancelText: allTranslations.text("cancel"),
          title: TextBuilder.build(title: "เลือกภาษา/Select language."),
          onConfirm: (Picker picker, List value) {
            print("Picker value : ${picker.getSelectedValues()}");
            sqfliteDB
                .addDataLanguage(
                    ModelLanguage(name: picker.getSelectedValues().first))
                .then((res) {
              if (res == true) {
                print("ADDED ${picker.getSelectedValues()}");
                ecsLib.pushPageReplacement(
                    context: context, pageWidget: LoginPage());
              } else
                print("ADD LANGUAGE FAIL"); //ต้องเเก้ปัญหานี้ด้วย
            });
          }).showDialog(context);
    } else
      Future.delayed(
          Duration(milliseconds: 3000),
          () => ecsLib.pushPageReplacement(
              context: context, pageWidget: LoginPage()));
  }

  // TODO: ทำ Log ของ Sqflite
  @override
  void initState() {
    super.initState();
    ckeckLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ControlledAnimation(
          duration: Duration(milliseconds: 1500),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, opacity) {
            return Opacity(opacity: opacity, child: ecsLib.logoApp());
          },
        ),
      ),
    );
  }
}
