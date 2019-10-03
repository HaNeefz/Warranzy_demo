import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/models/model_verify_login.dart';
import 'package:warranzy_demo/page/asset_page/add_assets_page/scFillInformation.dart';
import 'package:warranzy_demo/page/profile_page/scProfile.dart';
import 'package:warranzy_demo/page/splash_screen/scSplash_screen.dart';
import 'package:warranzy_demo/services/api/api_service_assets.dart';
import 'package:warranzy_demo/services/api/jwt_service.dart';
import 'package:warranzy_demo/services/api/repository.dart';
import 'package:warranzy_demo/services/api_provider/api_bloc.dart';
import 'package:warranzy_demo/services/api_provider/api_response.dart';
import 'package:warranzy_demo/services/method/methode_helper.dart';
import 'package:warranzy_demo/services/method/scan_qr.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';
import 'package:warranzy_demo/services/sqflit/db_customers.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/carouselImage.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/loading_api.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/error_api.dart';
import 'package:http/http.dart' as http;

import 'add_assets_page/scAdd_image_demo.dart';
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
  String username = "Username";

  List<ModelAssetsData> listAssetData;
  JWTService jwtService;
  ApiBlocGetAllAsset<ResponseAssetOnline> getAllAssetBloc;

  Future<List<ModelDataAsset>> getModelDataAsset() async {
    print("getAllAsset");
    return await DBProviderAsset.db.getAllDataAsset();
  }

  // Future<ResponseAssetOnline> getUrlAssetOnline() async {
  //   // ResponseAssetOnline response;
  //   try {
  //     return await APIServiceAssets.getAllAseet();
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }
  // String jWT = "";
  // getJWT() async {
  //   jWT = await JWTService.getTokenJWT();
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    var url = "/Asset/getMyAsset";
    getAllAssetBloc = ApiBlocGetAllAsset<ResponseAssetOnline>(
      url: url,
    );
    getUsername();
    getModelData = getModelDataAsset();
    // getAssetOnline = getUrlAssetOnline();
  }

  getUsername() async {
    await SharedPreferences.getInstance().then((name) {
      setState(() {
        username = name.getString("UserName");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Column buildYourAssets() {
    /*body: {
      "CustUserID": "ca3f58b3a0214aaaa68a",
      "PINcode": "111111",
      "DeviceID": "7BAE0E71-C3C2-4532-8C99-DCA7BB713A69",
      "CountryCode": "TH",
      "TimeZone": "Asia/Bangkok"
    } */

    return Column(
      children: <Widget>[
        buildAssetOffine(),
        buildAssetOnline(),
      ],
    );
  }

  insertIntiSQLite(RepositoryOfAsset res) async {
    try {
      await DBProviderAsset.db
          .insertDataWarranzyUesd(res.warranzyUsed)
          .catchError((onError) => print("warranzyUsed : $onError"));
    } catch (e) {
      print("insertDataWarranzyUesd => $e");
    }
    try {
      await DBProviderAsset.db
          .insertDataWarranzyLog(res.warranzyLog)
          .catchError((onError) => print("warranzyLog $onError"));
    } catch (e) {
      print("insertDataWarranzyLog => $e");
    }
    res.filePool.forEach((data) async {
      try {
        await DBProviderAsset.db
            .insertDataFilePool(data)
            .catchError((onError) => print("filePool $onError"))
            .whenComplete(() {});
      } catch (e) {
        print("insertDataFilePool => $e");
      }
    });
  }

  StreamBuilder<ApiResponse<ResponseAssetOnline>> buildAssetOnline() {
    return StreamBuilder<ApiResponse<ResponseAssetOnline>>(
      stream: getAllAssetBloc.stmStream,
      builder: (BuildContext context,
          AsyncSnapshot<ApiResponse<ResponseAssetOnline>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return CircularProgressIndicator();
              break;
            case Status.COMPLETED:
              if (snapshot.data.data.statusSession != null) {
                if (snapshot.data.data.data != null)
                  return Column(
                    children: snapshot.data.data.data
                        .map((data) => new MyAssetOnline(data: data))
                        .toList(),
                  );
                else {
                  return Text("Data is empty.");
                }
              } else
                ecsLib.pushPageAndClearAllScene(
                    context: context, pageWidget: SplashScreenPage());
              //
              break;
            case Status.ERROR:
              return Center(
                  child: Text(
                "${snapshot.data.message}",
                textAlign: TextAlign.center,
              ));
              // Error(
              //   errorMessage: snapshot.data.message,
              //   onRetryPressed: () => getAllAssetBloc.fetchData(),
              // );
              break;
          }
        }
        return Container();
      },
    );
  }
  // FutureBuilder<ResponseAssetOnline> buildAssetOnline() {
  //   return FutureBuilder<ResponseAssetOnline>(
  //     future: getAssetOnline,
  //     builder:
  //         (BuildContext context, AsyncSnapshot<ResponseAssetOnline> snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         var data = snapshot.data;
  //         if (data?.status == true) {
  //           return Column(
  //             children: data.data
  //                 .map((data) => new MyAssetOnline(data: data))
  //                 .toList(),
  //           );
  //         } else {
  //           return Text("Somethig wrong");
  //         }
  //       } else
  //         return CircularProgressIndicator();
  //     },
  //   );
  // }

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
                child: TextBuilder.build(title: "Data offline is empty"),
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
    List<String> _popUpItem = ["Search", "Sort"];
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
                child: PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                  itemBuilder: (BuildContext context) {
                    return _popUpItem.map((String choice) {
                      return PopupMenuItem(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ),
              // Expanded(
              //   child: IconButton(
              //     icon: Icon(Icons.clear_all),
              //     onPressed: () async {
              //       try {
              //         await DBProviderAsset.db
              //             .deleteAllAsset()
              //             .whenComplete(() => setState(() {
              //                   getModelData = getModelDataAsset();
              //                 }));
              //       } catch (e) {}
              //     },
              //   ),
              // )
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
          .post("https://testwarranty-239103.appspot.com/API/v1/Asset/AddAsset",
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
            context,
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
      padding: const EdgeInsets.all(8.0),
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
                    title: "Hello, $username",
                    style: TextStyleCustom.STYLE_TITLE
                        .copyWith(color: ThemeColors.COLOR_GREY),
                    maxLine: 1,
                    textOverflow: TextOverflow.ellipsis)
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
                print("Scan QR Code $res");
                ecsLib.showDialogLoadingLib(context);
                await Repository.getDataFromQRofAsset(body: {"WTokenID": res})
                    .then((response) {
                  ecsLib.cancelDialogLoadindLib(context);
                  print("response => $response");
                });
                if (res.isNotEmpty) Navigator.pop(context);
                // ecsLib.pushPage(
                //   context: context,
                //   pageWidget: FillInformation(
                //     onClickAddAssetPage: PageAction.SCAN_QR_CODE,
                //     hasDataAssetAlready: false,
                //   ),
                // );
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

class MyAssetFormSQLite extends StatefulWidget {
  // final RepositoryOfAssetFromSqflite data;
  final ModelDataAsset data;
  MyAssetFormSQLite({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  _MyAssetFormSQLiteState createState() => _MyAssetFormSQLiteState();
}

class _MyAssetFormSQLiteState extends State<MyAssetFormSQLite> {
  final Dio dio = Dio();
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  List<ImageDataEachGroup> imageDataEachGroup = [];
  String catName = '';

  getProductCateName() async {
    var _catName = await DBProviderInitialApp.db.getProductCatName(
        id: widget.data.pdtCatCode, lang: allTranslations.currentLanguage);
    setState(() {
      catName = _catName;
      // print("catName ====================> $catName");
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.data.alertDate);
    getProductCateName();
    if (widget.data.createType == "C") {
      imageDataEachGroup = getImage(widget.data);
    }
  }

  List<ImageDataEachGroup> getImage(ModelDataAsset images) {
    Map<String, dynamic> tempImages;
    List<ImageDataEachGroup> tempImageDataEachGroup = [];
    if (images.images != null) {
      tempImages = jsonDecode(images.images);
      tempImages.forEach((String k, dynamic v) {
        var listTemp = v as List;
        List<String> tempUrl = [];
        for (var item in listTemp) {
          tempUrl.add(item);
          // setState(() {
          //   listImageUrl.add(item);
          // });
        }
        tempImageDataEachGroup
            .add(ImageDataEachGroup(title: k, imageUrl: tempUrl));
      });
      tempImageDataEachGroup.forEach((v) {
        print("Title : ${v.title} | url[${v.imageUrl.length}] ${v.imageUrl}");
      });
    }
    return tempImageDataEachGroup;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        child: ListTile(
          title: Row(
            children: <Widget>[
              // Container(
              //   width: 100,
              //   height: 100,
              //   decoration: BoxDecoration(
              //       border: Border.all(
              //           width: 0.3, color: ThemeColors.COLOR_THEME_APP),
              //       borderRadius: BorderRadius.circular(10)),
              //   child: Center(
              //     child: FlutterLogo(),
              //   ),
              // ),
              if (widget.data.imageMain != null)
                CachedNetworkImage(
                  imageUrl: widget.data.imageMain,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 100,
                    height: 100,
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
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    size: 100,
                  ),
                )
              else
                Icon(
                  Icons.error,
                  size: 100,
                ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextBuilder.build(
                          title: widget.data.title ?? "Empty title",
                          style: TextStyleCustom.STYLE_LABEL_BOLD),
                      TextBuilder.build(
                          title: widget.data.custRemark ?? "Empty Remark",
                          style: TextStyleCustom.STYLE_CONTENT,
                          textOverflow: TextOverflow.ellipsis,
                          maxLine: 2),
                      TextBuilder.build(
                          title:
                              "\nExpire Date : ${widget.data.warrantyExpire.split(" ").first ?? "Empty warrantyExpire"}\nRemaining : ${showDateRemaining(widget.data.warrantyExpire)}",
                          style: TextStyleCustom.STYLE_CONTENT
                              .copyWith(fontSize: 12),
                          textOverflow: TextOverflow.ellipsis,
                          maxLine: 3),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                            color: ThemeColors.COLOR_GREY.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextBuilder.build(
                            title: widget.data?.modelCatName?.eN ?? catName,
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
            ecsLib.pushPage(
              context: context,
              pageWidget: DetailAsset(
                dataAsset: widget.data,
                showDetailOnline: false,
              ),
            );
          },
        ),
      ),
    );
  }

  String showDateRemaining(String dateTime) {
    int date = DateTime.parse(dateTime).difference(DateTime.now()).inDays;
    int hours = DateTime.parse(dateTime).difference(DateTime.now()).inHours;
    if (date > 0) {
      return "$date day.";
    } else if (date == 0 && hours > 0) {
      return "$hours hours.";
    } else {
      return "Expired";
    }
  }
}

class MyAssetOnline extends StatefulWidget {
  final ModelDataAsset data;

  MyAssetOnline({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  _MyAssetOnlineState createState() => _MyAssetOnlineState();
}

class _MyAssetOnlineState extends State<MyAssetOnline> {
  final Dio dio = Dio();
  String catName = '';
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();

  getProductCateName() async {
    var _catName = await DBProviderInitialApp.db.getProductCatName(
        id: widget.data.pdtCatCode, lang: allTranslations.currentLanguage);
    setState(() {
      catName = _catName;
    });
  }

  void initState() {
    super.initState();
    getProductCateName();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        title: Row(
          children: <Widget>[
            if (widget.data.imageMain != null)
              CachedNetworkImage(
                imageUrl: widget.data.imageMain,
                imageBuilder: (context, imageProvider) => Container(
                  width: 120,
                  height: 120,
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
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  size: 100,
                ),
              )
            else
              Icon(
                Icons.error,
                size: 100,
              ),
            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextBuilder.build(
                        title: widget.data.title ?? "NULL",
                        style:
                            TextStyleCustom.STYLE_TITLE.copyWith(fontSize: 20),
                        maxLine: 2,
                        textOverflow: TextOverflow.ellipsis),
                    TextBuilder.build(
                        title: widget.data.custRemark ?? "Empty",
                        style: TextStyleCustom.STYLE_CONTENT
                            .copyWith(fontSize: 13),
                        maxLine: 3,
                        textOverflow: TextOverflow.ellipsis),
                    TextBuilder.build(
                        title: "Warranty Expired " +
                                "${widget.data.warrantyExpire.split(" ")?.first}" ??
                            "Empty",
                        style: TextStyleCustom.STYLE_CONTENT
                            .copyWith(fontSize: 12),
                        maxLine: 1,
                        textOverflow: TextOverflow.ellipsis),
                    TextBuilder.build(
                        title:
                            "\nExpire Date : ${widget.data.warrantyExpire.split(" ").first ?? "Empty warrantyExpire"}\nRemaining : ${showDateRemaining(widget.data.warrantyExpire)}",
                        style: TextStyleCustom.STYLE_CONTENT
                            .copyWith(fontSize: 12),
                        textOverflow: TextOverflow.ellipsis,
                        maxLine: 3),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                      padding: EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                          color: ThemeColors.COLOR_GREY.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextBuilder.build(
                          title: catName ?? "",
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
          await ecsLib.pushPage(
            context: context,
            pageWidget: LoadingDetailAsset(
              dataAsset: widget.data,
              online: true,
            ),
          );
          // try {
          //   ecsLib.showDialogLoadingLib(context);
          //   await APIServiceAssets.getDetailAseet(
          //           wtokenID: widget.data.wTokenID)
          //       .then((res) {
          //     ecsLib.cancelDialogLoadindLib(context);
          //     if (res?.status == true) {
          //       ecsLib.pushPage(
          //         context: context,
          //         pageWidget: DetailAsset(
          //           dataAsset: res.data,
          //           showDetailOnline: true,
          //         ),
          //       );
          //     } else if (res.status == false) {
          //       ecsLib.showDialogLib(
          //           content: res?.message ?? "status false",
          //           context: context,
          //           textOnButton: allTranslations.text("close"),
          //           title: "ERROR STATUS");
          //     } else {
          //       ecsLib.showDialogLib(
          //           content: res?.message ?? "Something wrong",
          //           context: context,
          //           textOnButton: allTranslations.text("close"),
          //           title: "ERROR SERVER");
          //     }
          //   });
          // } catch (e) {
          //   ecsLib.showDialogLib(
          //       content: "Catch Something wrong",
          //       context: context,
          //       textOnButton: allTranslations.text("close"),
          //       title: "CATCH ERROR");
          // }
        },
      ),
    );
  }

  String showDateRemaining(String dateTime) {
    int date = DateTime.parse(dateTime).difference(DateTime.now()).inDays;
    int hours = DateTime.parse(dateTime).difference(DateTime.now()).inHours;
    if (date > 0) {
      return "$date day.";
    } else if (date == 0 && hours > 0) {
      return "$hours hours.";
    } else {
      return "Expired";
    }
  }
}
