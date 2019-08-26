import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/page/asset_page/add_assets_page/scFillInformation.dart';
import 'package:warranzy_demo/page/profile_page/scProfile.dart';
import 'package:warranzy_demo/page/splash_screen/scSplash_screen.dart';
import 'package:warranzy_demo/services/api/jwt_service.dart';
import 'package:warranzy_demo/services/method/scan_qr.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';
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
      children: <Widget>[
        // FutureBuilder<Iterable<RepositoryOfAssetFromSqflite>>(
        //   future: DBProviderAsset.db.getAllDataAsset(),
        //   builder: (BuildContext context,
        //       AsyncSnapshot<Iterable<RepositoryOfAssetFromSqflite>> snapshot) {
        //     if (snapshot.connectionState == ConnectionState.done) {
        //       if (!(snapshot.hasError)) {
        //         return Padding(
        //           padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             mainAxisSize: MainAxisSize.min,
        //             children: <Widget>[
        //               Column(
        //                   children: snapshot.data
        //                       .map((data) => Card(
        //                             elevation: 5.0,
        //                             child: Padding(
        //                               padding: const EdgeInsets.all(8.0),
        //                               child: Container(
        //                                 child: Row(
        //                                   children: <Widget>[
        //                                     Expanded(
        //                                       flex: 1,
        //                                       child: Container(
        //                                         width: 150,
        //                                         height: 150,
        //                                         decoration: BoxDecoration(
        //                                             border: Border.all(
        //                                                 width: 0.3,
        //                                                 color: ThemeColors
        //                                                     .COLOR_THEME_APP),
        //                                             borderRadius:
        //                                                 BorderRadius.circular(
        //                                                     10)),
        //                                         child: Center(
        //                                           child: FlutterLogo(),
        //                                         ),
        //                                       ),
        //                                     ),
        //                                     Expanded(
        //                                       flex: 2,
        //                                       child: Container(
        //                                         padding: EdgeInsets.symmetric(
        //                                             vertical: 10,
        //                                             horizontal: 10),
        //                                         child: Column(
        //                                           crossAxisAlignment:
        //                                               CrossAxisAlignment.start,
        //                                           children: <Widget>[
        //                                             TextBuilder.build(
        //                                                 title: data.title ??
        //                                                     "Empty title",
        //                                                 style: TextStyleCustom
        //                                                     .STYLE_LABEL_BOLD),
        //                                             TextBuilder.build(
        //                                                 title:
        //                                                     data.custRemark ??
        //                                                         "Empty Remark",
        //                                                 style: TextStyleCustom
        //                                                     .STYLE_CONTENT,
        //                                                 textOverflow:
        //                                                     TextOverflow
        //                                                         .ellipsis,
        //                                                 maxLine: 2),
        //                                             TextBuilder.build(
        //                                                 title: data.fileID ??
        //                                                     "Empty Remark | ${data.fileName}",
        //                                                 style: TextStyleCustom
        //                                                     .STYLE_CONTENT,
        //                                                 textOverflow:
        //                                                     TextOverflow
        //                                                         .ellipsis,
        //                                                 maxLine: 2),
        //                                             TextBuilder.build(
        //                                                 title: "\nExpire Date : ${data.warrantyExpire}" ??
        //                                                     "Empty warrantyExpire",
        //                                                 style: TextStyleCustom
        //                                                     .STYLE_CONTENT
        //                                                     .copyWith(
        //                                                         fontSize: 12),
        //                                                 textOverflow:
        //                                                     TextOverflow
        //                                                         .ellipsis,
        //                                                 maxLine: 2),
        //                                             Container(
        //                                               margin:
        //                                                   EdgeInsets.symmetric(
        //                                                       vertical: 10),
        //                                               width: 80,
        //                                               height: 30,
        //                                               decoration: BoxDecoration(
        //                                                   borderRadius:
        //                                                       BorderRadius
        //                                                           .circular(20),
        //                                                   color: ThemeColors
        //                                                       .COLOR_GREY
        //                                                       .withOpacity(
        //                                                           0.3)),
        //                                               child: Center(
        //                                                 child: TextBuilder.build(
        //                                                     title:
        //                                                         data.pdtCatCode,
        //                                                     style:
        //                                                         TextStyleCustom
        //                                                             .STYLE_LABEL
        //                                                             .copyWith(
        //                                                                 fontSize:
        //                                                                     12),
        //                                                     textOverflow:
        //                                                         TextOverflow
        //                                                             .ellipsis,
        //                                                     maxLine: 2),
        //                                               ),
        //                                             ),
        //                                           ],
        //                                         ),
        //                                       ),
        //                                     ),
        //                                   ],
        //                                 ),
        //                               ),
        //                             ),
        //                           ))
        //                       .toList()),
        //
        //             ],
        //           ),
        //         );
        //       } else {
        //         return Text("Error");
        //       }
        //     } else if (snapshot.connectionState == ConnectionState.waiting) {
        //       return CircularProgressIndicator();
        //     } else {
        //       return Text("Something wrong.!!");
        //     }
        //   },
        // ),
        FutureBuilder(
          future: DBProviderAsset.db.getAllDataAssetTest(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!(snapshot.hasError)) {
                return Text("${snapshot.data}");
              } else
                return Text("Error");
            } else if (snapshot.connectionState == ConnectionState.waiting)
              return CircularProgressIndicator();
            else
              return Text("Somthing wrong.");
          },
        ),
        Column(
          children: listAssetData.map((i) {
            return ModelAssetWidget(i);
          }).toList(),
        )
      ],
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
                    try {
                      var filePool = await DBProviderAsset.db
                          .getAllDataFilePool()
                          .catchError((onError) =>
                              print("getAllDataFilePool => $onError"));
                      var waranzyUsed = await DBProviderAsset.db
                          .getAllDataWarranzyUsed()
                          .catchError((onError) =>
                              print("getAllDataWarranzyUsed => $onError"));
                      var warranzyLog = await DBProviderAsset.db
                          .getAllDataWarranzyLog()
                          .catchError((onError) =>
                              print("getAllDataWarranzyLog => $onError"));

                      filePool.forEach(
                          (v) => print("filePool => ${v.fileDescription}"));
                      waranzyUsed.forEach(
                          (v) => print("waranzyUsed => ${v.custUserID}"));
                      warranzyLog.forEach(
                          (v) => print("warranzyLog => ${v.fileAttachID}"));
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.clear_all),
                  onPressed: () async {
                    // try {
                    //   await DBProviderAsset.db.deleteAllAsset();
                    // } catch (e) {}
                    
                  },
                ),
              )
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
