import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:warranzy_demo/models/model_language.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/page/login_first/scLogin.dart';
import 'package:simple_animations/simple_animations.dart';
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
  final Dio dio = Dio();

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
                .then((res) async {
              if (res == true) {
                print("ADDED ${picker.getSelectedValues()}");
                // ecsLib.pushPageReplacement(
                //     context: context, pageWidget: LoginPage());
                await initialApp();
              } else
                print("ADD LANGUAGE FAIL"); //ต้องเเก้ปัญหานี้ด้วย
            });
          }).showDialog(context);
    } else
      await checkUpdateApp();
  }

  checkUpdateApp() async {
    await Future.delayed(Duration(milliseconds: 2000), () async {
      ecsLib.showDialogLoadingLib(context, content: "Checking Update");
      await Future.delayed(Duration(seconds: 2), () {
        ecsLib.cancelDialogLoadindLib(context);
        print("Checked Update");
        ecsLib.pushPageReplacement(context: context, pageWidget: LoginPage());
      });
    });
  }

  initialApp() async {
    await Future.delayed(Duration(milliseconds: 2000), () async {
      ecsLib.showDialogLoadingLib(context, content: "Initial Application");
      try {
        await dio
            .get("http://192.168.0.36:9999/API/v1/User/InitialApp")
            .then((res) {
          var data = RepositoryInitalApp.fromJson(jsonDecode(res.data));
          if (data.status == true) {
            print("<---------Completed InitialApplication");
            ecsLib.cancelDialogLoadindLib(context);
            ecsLib.pushPageReplacement(
                context: context, pageWidget: LoginPage());
          } else if (data.status == false) {
            ecsLib.showDialogLib(
                context: context,
                title: "ERROR LOADING",
                content: "null",
                textOnButton: allTranslations.text("close"));
          } else {
            ecsLib.showDialogLib(
                context: context,
                title: "ERROR SERVER",
                content: "null",
                textOnButton: allTranslations.text("close"));
          }
          // var s = data.productCatagory[0].catName;
          // var temp = jsonDecode(s);
          // var catName = CatName.fromJson(temp);
        });
      } catch (e) {
        print(e);
      }
    });
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
