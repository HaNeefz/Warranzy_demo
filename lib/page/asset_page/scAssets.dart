import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/page/asset_page/add_assets_page/scFillInformation.dart';
import 'package:warranzy_demo/page/profile_page/scProfile.dart';
import 'package:warranzy_demo/page/splash_screen/scSplash_screen.dart';
import 'package:warranzy_demo/services/api/jwt_service.dart';
import 'package:warranzy_demo/services/method/scan_qr.dart';
import 'package:warranzy_demo/services/sqflit/db_customers.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/carouselImage.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'widget_assets/widget_asset.dart';
import 'package:http/http.dart' as http;

class AssetPage extends StatefulWidget {
  @override
  _AssetPageState createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  ModelAssetsData assetData = ModelAssetsData();
  final Dio dio = Dio();

  List<ModelAssetsData> listAssetData;
  JWTService jwtService;

  @override
  void initState() {
    super.initState();
    listAssetData = assetData.pushData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            buildHeaderAndProfile(),
            CarouselWithIndicator(
              height: 250,
              items: ["1", "2", "3", "5"],
            ),
            buildLabelAndSeeAll(),
            buildYourAssets(),
          ],
        ),
      ),
    );
  }

  Column buildYourAssets() {
    return Column(
      children: listAssetData.map((i) {
        return ModelAssetWidget(i);
      }).toList(),
    );
  }

  Row buildLabelAndSeeAll() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: TextBuilder.build(
              title: "Your Asset", style: TextStyleCustom.STYLE_TITLE),
        )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton.icon(
                color: ThemeColors.COLOR_THEME_APP,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                icon: Icon(
                  Icons.add_circle,
                  color: ThemeColors.COLOR_WHITE,
                ),
                label: Text(
                  "Add asset",
                  style: TextStyleCustom.STYLE_LABEL
                      .copyWith(color: ThemeColors.COLOR_WHITE),
                ),
                onPressed: () async {
                  await buildShowModalBottomSheet(context);
                  // await checkSessionExpired();
                },
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.sort),
                  tooltip: "Sort Asset",
                  onPressed: () async {
                    // await buildShowModalBottomSheet(context);
                    // await checkSessionExpired();
                  },
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  checkSessionExpired() async {
    try {
      print("Check Session Expire");
      ecsLib.showDialogLoadingLib(context);
      await dio
          .post("http://192.168.0.36:9999/API/v1/Asset/AddAsset",
              options:
                  Options(headers: {"Authorization": JWTService.getTokenJWT()}))
          .then((res) async {
        var response = jsonDecode(res.data);
        if (response['Status'] == true) {
          await buildShowModalBottomSheet(context);
          ecsLib.cancelDialogLoadindLib(context);
        } else {
          print(response);
          await ecsLib.showDialogLib(
            context: context,
            title: "",
            content: response['Message'],
            textOnButton: allTranslations.text("close"),
          );
          ecsLib.pushPageReplacement(
            context: context,
            pageWidget: SplashScreenPage(),
          );
        }
      });
    } catch (e) {
      print("$e");
    }
  }

  Widget buildHeaderAndProfile() {
    var dateTime = DateTime.now();
    String date = DateFormat('EEEE, d MMMM').format(dateTime);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextBuilder.build(
                    title: date, style: TextStyleCustom.STYLE_LABEL_BOLD),
                TextBuilder.build(
                    title: "Hello, Username",
                    style: TextStyleCustom.STYLE_TITLE
                        .copyWith(color: ThemeColors.COLOR_GREY))
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                ecsLib.pushPage(
                  context: context,
                  pageWidget: ProfilePage(
                    heroTag: "PhotoProfile",
                  ),
                );
              },
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 3, color: ThemeColors.COLOR_THEME_APP)),
                child: Center(
                  child: Hero(
                    child: FlutterLogo(
                      colors: ThemeColors.COLOR_THEME_APP,
                    ),
                    tag: "PhotoProfile",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        height: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(Assets.ICON_SCANNER),
              ),
              title: TextBuilder.build(title: "Scan QR Code"),
              onTap: () async {
                var res = await MethodLib.scanQR(context);
                print("Scan QR Code");
                if (res.isNotEmpty) Navigator.pop(context);
                ecsLib.pushPage(
                  context: context,
                  pageWidget: FillInformation(
                    onClickAddAssetPage: PageAction.SCAN_QR_CODE,
                    hasDataAssetAlready: false,
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.playlist_add,
                color: ThemeColors.COLOR_BLACK,
                size: 35,
              ),
              title: TextBuilder.build(title: "Manaul Add Asset"),
              onTap: () {
                print("Manual Add Asset");
                Navigator.pop(context);
                ecsLib.pushPage(
                  context: context,
                  pageWidget: FillInformation(
                    onClickAddAssetPage: PageAction.MANUAL_ADD,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
