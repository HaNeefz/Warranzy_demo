import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/page/asset_page/add_assets_page/scFillInformation.dart';
import 'package:warranzy_demo/page/profile_page/scProfile.dart';
import 'package:warranzy_demo/page/splash_screen/scSplash_screen.dart';
import 'package:warranzy_demo/services/api/api_service_assets.dart';
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
import 'package:http/http.dart' as http;

import 'detail_asset_page/scDetailAsset.dart';

class AssetPage extends StatefulWidget {
  @override
  _AssetPageState createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  final Dio dio = Dio();
  Future getAssetOnline;
  Future<List<ModelDataAsset>> getModelData;

  List<ModelAssetsData> listAssetData;
  JWTService jwtService;

  Future<List<ModelDataAsset>> getModelDataAsset() async {
    return await DBProviderAsset.db.getAllDataAsset();
  }

  Future<ResponseAssetOnline> getUrlAssetOnline() async {
    try {
      var response = await dio.get(
          "http://192.168.0.36:9999/API/v1/Asset/getMyAsset",
          options: Options(
              headers: {"Authorization": await JWTService.getTokenJWT()}));
      if (response.statusCode == 200) {
        ecsLib.printJson(jsonDecode(response.data));
        return ResponseAssetOnline.fromJson(jsonDecode(response.data));
      } else
        throw Exception();
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    getModelData = getModelDataAsset();
    getAssetOnline = getUrlAssetOnline();
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
        buildAssetOffine(),
        buildAssetOnline(),
        // Column(
        //   children: listAssetData.map((i) {
        //     return ModelAssetWidget(i);
        //   }).toList(),
        // )
      ],
    );
  }

  FutureBuilder<ResponseAssetOnline> buildAssetOnline() {
    return FutureBuilder<ResponseAssetOnline>(
      future: getAssetOnline,
      builder:
          (BuildContext context, AsyncSnapshot<ResponseAssetOnline> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var data = snapshot.data;
          if (data?.status == true) {
            return Column(
              children: data.data
                  .map((data) => new MyAssetOnline(data: data))
                  .toList(),
            );
          } else {
            return Text("Somethig wrong");
          }
        } else
          return CircularProgressIndicator();
      },
    );
  }

  FutureBuilder<List<ModelDataAsset>> buildAssetOffine() {
    return FutureBuilder<List<ModelDataAsset>>(
      future: getModelData,
      builder:
          (BuildContext context, AsyncSnapshot<List<ModelDataAsset>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!(snapshot.hasError)) {
            if (snapshot.data.isNotEmpty)
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                        children: snapshot.data
                            .map((data) => new MyAssetFormSQLite(data: data))
                            .toList()),
                  ],
                ),
              );
            else {
              return Center(
                child: TextBuilder.build(title: "Data is empty"),
              );
            }
          } else {
            return Text("Error");
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return Text("Something wrong.!!");
        }
      },
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
                    try {
                      await DBProviderAsset.db
                          .deleteAllAsset()
                          .whenComplete(() => setState(() {
                                getModelData = getModelDataAsset();
                              }));
                    } catch (e) {}
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

class MyAssetFormSQLite extends StatelessWidget {
  // final RepositoryOfAssetFromSqflite data;
  final Dio dio = Dio();
  final ModelDataAsset data;
  MyAssetFormSQLite({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        child: ListTile(
          title: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.3, color: ThemeColors.COLOR_THEME_APP),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: FlutterLogo(),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextBuilder.build(
                          title: data.title ?? "Empty title",
                          style: TextStyleCustom.STYLE_LABEL_BOLD),
                      TextBuilder.build(
                          title: data.custRemark ?? "Empty Remark",
                          style: TextStyleCustom.STYLE_CONTENT,
                          textOverflow: TextOverflow.ellipsis,
                          maxLine: 2),
                      TextBuilder.build(
                          title: data.fileAttachID ??
                              "Empty Remark | ${data.custRemark}",
                          style: TextStyleCustom.STYLE_CONTENT,
                          textOverflow: TextOverflow.ellipsis,
                          maxLine: 2),
                      TextBuilder.build(
                          title: "\nExpire Date : ${data.warrantyExpire}" ??
                              "Empty warrantyExpire",
                          style: TextStyleCustom.STYLE_CONTENT
                              .copyWith(fontSize: 12),
                          textOverflow: TextOverflow.ellipsis,
                          maxLine: 2),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: 80,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: ThemeColors.COLOR_GREY.withOpacity(0.3)),
                        child: Center(
                          child: TextBuilder.build(
                              title: data.pdtCatCode,
                              style: TextStyleCustom.STYLE_LABEL
                                  .copyWith(fontSize: 12),
                              textOverflow: TextOverflow.ellipsis,
                              maxLine: 2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onTap: () async {
            ecsLib.pushPage(
              context: context,
              pageWidget: DetailAsset(
                dataAsset: data,
                showDetailOnline: false,
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyAssetOnline extends StatelessWidget {
  final ModelDataAsset data;
  final Dio dio = Dio();
  MyAssetOnline({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        title: Row(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: data.imageMain,
              imageBuilder: (context, imageProvider) => Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter:
                          ColorFilter.mode(Colors.red, BlendMode.dstATop)),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextBuilder.build(
                        title: data.title ?? "NULL",
                        style:
                            TextStyleCustom.STYLE_TITLE.copyWith(fontSize: 20),
                        maxLine: 2,
                        textOverflow: TextOverflow.ellipsis),
                    TextBuilder.build(
                        title: data.custRemark ?? "Empty",
                        style: TextStyleCustom.STYLE_CONTENT
                            .copyWith(fontSize: 13),
                        maxLine: 3,
                        textOverflow: TextOverflow.ellipsis),
                    TextBuilder.build(
                        title: "Warranty Date " + "${data.warrantyExpire}" ??
                            "Empty",
                        style: TextStyleCustom.STYLE_CONTENT
                            .copyWith(fontSize: 12),
                        maxLine: 1,
                        textOverflow: TextOverflow.ellipsis),
                    Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: ThemeColors.COLOR_GREY.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextBuilder.build(
                          title: data.pdtCatCode,
                          style: TextStyleCustom.STYLE_CONTENT.copyWith(
                              fontSize: 14, color: ThemeColors.COLOR_BLACK)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap: () async {
          try {
            ecsLib.showDialogLoadingLib(context);
            await APIServiceAssets.getDetailAseet(wtokenID: data.wTokenID)
                .then((res) {
              ecsLib.cancelDialogLoadindLib(context);
              if (res?.status == true) {
                ecsLib.pushPage(
                  context: context,
                  pageWidget: DetailAsset(
                    dataAsset: res.data,
                    showDetailOnline: true,
                  ),
                );
              } else if (res.status == false) {
                ecsLib.showDialogLib(
                    content: "status false",
                    context: context,
                    textOnButton: allTranslations.text("close"),
                    title: "ERROR STATUS");
              } else {
                ecsLib.showDialogLib(
                    content: "Something wrong",
                    context: context,
                    textOnButton: allTranslations.text("close"),
                    title: "ERROR SERVER");
              }
            });
          } catch (e) {
            ecsLib.showDialogLib(
                content: "Something wrong",
                context: context,
                textOnButton: allTranslations.text("close"),
                title: "CATCH ERROR");
          }
        },
      ),
    );
  }
}
