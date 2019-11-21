import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:warranzy_demo/models/model_get_brand_name.dart';
import 'package:warranzy_demo/models/model_language.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/page/login_first/scLogin.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:warranzy_demo/services/api/base_url.dart';
import 'package:warranzy_demo/services/api/repository.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
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
          onConfirm: (Picker picker, List value) async {
            // print("Picker picker : ${picker.adapter.picker.}");
            print("Picker value : ${picker.getSelectedValues()}");
            String lang = "";
            if (picker.getSelectedValues().first == "English") {
              lang = "en";
            } else
              lang = "th";
            await sqfliteDB
                .addDataLanguage(ModelLanguage(
                    prefix: lang, name: picker.getSelectedValues().first))
                .then((res) async {
              if (res == true) {
                print("ADDED ${picker.getSelectedValues()}");
                await initialApp();
                // var lang = await sqfliteDB.getDataLanguage();
                await allTranslations.setNewLanguage(lang ?? "th");
                setState(() {});
              } else
                print(
                    "VALUES ${picker.getSelectedValues()} => ADD LANGUAGE FAIL"); //ต้องเเก้ปัญหานี้ด้วย
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
      try {
        ecsLib.showDialogLoadingLib(context, content: "Initial App");
        await Repository.initialApplication().then((res) async {
          var temp = res;
          if (temp.status == true) {
            ecsLib.cancelDialogLoadindLib(context);
            ecsLib.showDialogLoadingLib(context, content: "Setting App");
            await DBProviderInitialApp.db.deleteAllDataIn3Table();
            await getBrandName();
            temp.country.forEach((v) async => await DBProviderInitialApp.db
                .insertDataInToTableCountry(v)
                .catchError((onError) => print("Country $onError")));
            temp.timeZone.forEach((v) async => await DBProviderInitialApp.db
                .insertDataInToTableTimeZone(v)
                .catchError((onError) => print("TimeZone $onError")));
            temp.productCategory.forEach((v) async {
              await DBProviderInitialApp.db
                  .insertDataInToTableProductSubCategory(v)
                  .catchError(
                      (onError) => print("ProductSubCategory $onError"));
              await DBProviderInitialApp.db
                  .updateIconSubCategory(v)
                  .catchError((onError) {
                print("UpdateLogo ProductSubCategory $onError");
              });
            });
            temp.groupCategory.forEach((v) async {
              await DBProviderInitialApp.db
                  .insertDataInToTableGroupCategory(v)
                  .catchError(
                      (onError) => print("ProductHeaderCategory $onError"));
              await DBProviderInitialApp.db
                  .updateIconGroupCategory(v)
                  .catchError((onError) {
                print("Update ProductCategory $onError");
              });
            });
            // ecsLib.cancelDialogLoadindLib(context);

            ecsLib.pushPageReplacement(
                context: context, pageWidget: LoginPage());
          } else
            print("Status ${temp.status}");
        });
      } on DioError catch (e) {
        print("$e");
      } catch (e) {
        print(e);
      }
    });
  }

  Future<bool> getBrandName() async {
    print("get in");
    bool success = false;
    int length = 0;
    int amountOfBrand = 0;
    Firestore.instance
        .collection('BrandName')
        .snapshots()
        .listen((onData) async {
      print("listen OK");
      amountOfBrand = onData.documents.length;
      for (var temp in onData.documents) {
        String docID = temp.documentID;
        temp.data.addAll({"DocumentID": docID});
        GetBrandName tempBrand = GetBrandName.fromJson(temp.data);
        await DBProviderAsset.db.inserDataBrand(tempBrand).then((onValue) {
          if (onValue == true) length++;
        });
        if (length == amountOfBrand) {
          success = true;
          print("insertBrand completed");
        }
      }
    });
    return success;
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
