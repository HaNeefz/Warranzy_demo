import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/models/model_image_data_each_group.dart';
import 'package:warranzy_demo/models/model_repository_asset_scan.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/models/model_user.dart';
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
import 'package:warranzy_demo/services/providers/asset_state.dart';
import 'package:warranzy_demo/services/providers/customer_state.dart';
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
import 'package:warranzy_demo/tools/widget_ui_custom/show_image_profile.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/error_api.dart';
import 'package:http/http.dart' as http;

import 'add_assets_page/scAdd_image_demo.dart';
import 'detail_asset_page/scDetailAsset.dart';

class AssetPageNew extends StatelessWidget {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();

  @override
  Widget build(BuildContext context) {
    var dateTime = DateTime.now();
    String date = DateFormat('EEEE, d MMMM').format(dateTime);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          height: 100,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            ThemeColors.COLOR_THEME_APP,
            ThemeColors.COLOR_WHITE
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextBuilder.build(
                    title: date, style: TextStyleCustom.STYLE_LABEL_BOLD),
                ShowProfile(
                  ecsLib: ecsLib,
                ),
              ],
            ),
          ),
        ),
      ),
      body: WillPopScope(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // shrinkWrap: true,
              children: <Widget>[
                ShowCustomerName(),
                // buildHeaderAndProfile(),
                CarouselWithIndicator(
                  height: 250,
                  items: ["1", "2", "3", "5"],
                  autoPlay: false,
                ),
                buildLabelAndSeeAll(context),
                buildYourAssets(),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }

  buildYourAssets() {
    return ShowAsset();
  }

  Row buildLabelAndSeeAll(BuildContext context) {
    List<String> _popUpItem = ["Search", "Sort"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: TextBuilder.build(
              title: "Your Asset",
              style: TextStyleCustom.STYLE_TITLE.copyWith(letterSpacing: 1.5)),
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
                        child: GestureDetector(
                            child: Text(choice),
                            onTap: () {
                              // setState(() {});
                              // print(allTranslations.currentLanguage);
                            }),
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

                if (res.isNotEmpty) {
                  ecsLib.showDialogLoadingLib(context);
                  await Repository.getDataFromQRofAsset(body: {"WTokenID": res})
                      .then((response) async {
                    ecsLib.cancelDialogLoadindLib(context);
                    if (response.status == true) {
                      await ecsLib
                          .pushPage(
                        context: context,
                        pageWidget: FillInformation(
                          onClickAddAssetPage: PageAction.SCAN_QR_CODE,
                          hasDataAssetAlready: false,
                          dataScan: response,
                        ),
                      )
                          .whenComplete(() {
                        Navigator.pop(context);
                      });
                    } else if (response.status == false) {
                      await ecsLib
                          .showDialogLib(
                            context,
                            title: "WARRANZY",
                            content: response.message ?? "",
                            textOnButton: allTranslations.text("close"),
                          )
                          .whenComplete(() => Navigator.pop(context));
                    }
                  });
                } else {
                  ecsLib.showDialogLib(context,
                      content: "Not Found.",
                      textOnButton: allTranslations.text("close"),
                      title: "ERROR DATA SCAN");
                }
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

class AssetPage extends StatefulWidget {
  const AssetPage({Key key}) : super(key: key);
  @override
  _AssetPageState createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  final Dio dio = Dio();
  Future getAssetOnline;
  Future<List<ModelDataAsset>> getModelData;
  List<ModelDataAsset> listModelDataAsset = [];
  String username = "Username";

  ApiBlocGetAllAsset<ResponseAssetOnline> getAllAssetBloc;

  Future<List<ModelDataAsset>> getModelDataAsset() async {
    print("getAllAsset");
    return await DBProviderAsset.db.getAllDataAsset();
  }

  // AssetStateTest _assetState = AssetStateTest();

  @override
  void initState() {
    super.initState();
    // widget.assetState.fetchData();
    // getAllAsset();
    // var url = "/Asset/getMyAsset";
    // getAllAssetBloc = ApiBlocGetAllAsset<ResponseAssetOnline>(
    //   url: url,
    // );
    getModelData = getModelDataAsset();
    // getAssetOnline = getUrlAssetOnline();
  }

  @override
  Widget build(BuildContext context) {
    var dateTime = DateTime.now();
    String date = DateFormat('EEEE, d MMMM').format(dateTime);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          height: 100,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            ThemeColors.COLOR_THEME_APP,
            ThemeColors.COLOR_WHITE
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextBuilder.build(
                    title: date, style: TextStyleCustom.STYLE_LABEL_BOLD),
                new ShowProfile(
                  ecsLib: ecsLib,
                ),
              ],
            ),
          ),
        ),
      ),
      body: WillPopScope(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // shrinkWrap: true,
              children: <Widget>[
                ShowCustomerName(),
                // buildHeaderAndProfile(),
                CarouselWithIndicator(
                  height: 250,
                  items: ["1", "2", "3", "5"],
                  autoPlay: false,
                ),
                buildLabelAndSeeAll(),
                buildYourAssets(),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }

  buildYourAssets({AssetState assetState}) {
    return
        // LoadingDataAsset(assetState: assetState);
        buildAssetOffine();
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
              if (snapshot.data.data.statusSession == null) {
                if (snapshot.data.data.data != null)
                  return Column(
                    children: snapshot.data.data.data
                        .map((data) => new MyAssetOnline(data: data))
                        .toList(),
                  );
                else {
                  return Text("Data is empty.");
                }
              } else {
                ecsLib.pushPageAndClearAllScene(
                    context: context, pageWidget: SplashScreenPage());
                return Text("${snapshot.data.data.message}");
              }
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
              title: "Your Asset",
              style: TextStyleCustom.STYLE_TITLE.copyWith(letterSpacing: 1.5)),
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
                        child: GestureDetector(
                            child: Text(choice),
                            onTap: () {
                              // setState(() {});
                              // print(allTranslations.currentLanguage);
                            }),
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
              child: Center(
                child: Hero(
                  child: Icon(Icons.person_pin, size: 50),
                  tag: "PhotoProfile",
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

                if (res.isNotEmpty) {
                  ecsLib.showDialogLoadingLib(context);
                  await Repository.getDataFromQRofAsset(body: {"WTokenID": res})
                      .then((response) async {
                    ecsLib.cancelDialogLoadindLib(context);
                    if (response.status == true) {
                      await ecsLib
                          .pushPage(
                        context: context,
                        pageWidget: FillInformation(
                          onClickAddAssetPage: PageAction.SCAN_QR_CODE,
                          hasDataAssetAlready: false,
                          dataScan: response,
                        ),
                      )
                          .whenComplete(() {
                        Navigator.pop(context);
                      });
                    } else if (response.status == false) {
                      await ecsLib
                          .showDialogLib(
                            context,
                            title: "WARRANZY",
                            content: response.message ?? "",
                            textOnButton: allTranslations.text("close"),
                          )
                          .whenComplete(() => Navigator.pop(context));
                    }
                  });
                } else {
                  ecsLib.showDialogLib(context,
                      content: "Not Found.",
                      textOnButton: allTranslations.text("close"),
                      title: "ERROR DATA SCAN");
                }
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

class ShowAsset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AssetState>(
        builder: (context, assetState, _) =>
            // assetState.isFecthing == false
            //     ? Center(child: CircularProgressIndicator())
            //     :
            Column(
              children: <Widget>[
                if (assetState.assets.length > 0)
                  SingleChildScrollView(
                    child: Column(
                        children: assetState.assets.reversed
                            .map((data) => new MyAssetFormSQLite(data: data))
                            .toList()),
                  )
                else
                  Center(
                    child: TextBuilder.build(title: "Data offline is empty"),
                  )
              ],
            ));
  }
}

class LoadingDataAsset extends StatefulWidget {
  final AssetState assetState;
  const LoadingDataAsset({
    Key key,
    this.assetState,
  }) : super(key: key);

  @override
  _LoadingDataAssetState createState() => _LoadingDataAssetState();
}

class _LoadingDataAssetState extends State<LoadingDataAsset> {
  AssetState get assetState => widget.assetState;

  @override
  void initState() {
    super.initState();
    widget.assetState.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final assetState = Provider.of<AssetState>(context);
    return assetState.isFecthing == false
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: <Widget>[
              if (assetState.assets.length > 0)
                SingleChildScrollView(
                  child: Column(
                      children: assetState.assets
                          .map((data) => new MyAssetFormSQLite(data: data))
                          .toList()),
                )
              else
                Center(
                  child: TextBuilder.build(title: "Data offline is empty"),
                )
              // if (assetState.assets.length > 0)
              //   if (assetState.isFecthing == true)
              //     SingleChildScrollView(
              //       child: Column(
              //           children: assetState.assets
              //               .map((data) => new MyAssetFormSQLite(data: data))
              //               .toList()),
              //     )
              //   else
              //     Center(child: CircularProgressIndicator())
              // else
              //   Center(
              //     child: TextBuilder.build(title: "Data offline is empty"),
              //   )
            ],
          );
  }
}

class ShowCustomerName extends StatelessWidget {
  const ShowCustomerName({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerState = Provider.of<CustomerState>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 15),
      child: TextBuilder.build(
          title: "Hello, ${customerState.dataCustomer.custName ?? ""}",
          style: TextStyleCustom.STYLE_TITLE
              .copyWith(color: ThemeColors.COLOR_GREY, letterSpacing: 1.5),
          maxLine: 1,
          textOverflow: TextOverflow.ellipsis),
    );
  }
}

class ShowProfile extends StatelessWidget {
  ShowProfile({
    Key key,
    @required this.ecsLib,
  }) : super(key: key);

  final ECSLib ecsLib;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ecsLib.pushPage(
          context: context,
          pageWidget: ProfilePage(
            heroTag: "PhotoProfile",
          ),
        );
      },
      child: Consumer<CustomerState>(
        builder: (context, customerState, _) => Center(
          child: Hero(
            child: customerState?.dataCustomer?.imageProfile == null
                ? Icon(Icons.person_pin, size: 50, color: Colors.black)
                : ShowImageProfile(
                    imagePath: customerState?.dataCustomer?.imageProfile,
                    borderColor: Colors.black,
                    radius: 30,
                  ),
            tag: "PhotoProfile",
          ),
        ),
      ),
    );
  }
}

// class ShowMyAsset extends StatelessWidget {
//   final AssetState assetState;

//   const ShowMyAsset({Key key, this.assetState}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
// FutureBuilder<List<ModelDataAsset>>(
//   future: assetState.allAssets,
//   builder:
//       (BuildContext context, AsyncSnapshot<List<ModelDataAsset>> snapshot) {
//     if (snapshot.connectionState == ConnectionState.done) {
//       if (!(snapshot.hasError)) {
//         if (snapshot.data.isNotEmpty)
//           return Padding(
//               padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
//               child: RefreshIndicator(
//                 onRefresh: () async {
//                   await assetState.refreshAsset();
//                 },
//                 child: Column(
//                   children: <Widget>[
//                     SingleChildScrollView(
//                       child: Column(
//                           children: snapshot.data
//                               .map((data) =>
//                                   new MyAssetFormSQLite(data: data))
//                               .toList()),
//                     ),
//                   ],
//                 ),
//               ));
//         else {
//           return Center(
//             child: TextBuilder.build(title: "Data offline is empty"),
//           );
//         }
//       } else {
//         return Text("Error");
//       }
//     } else if (snapshot.connectionState == ConnectionState.waiting) {
//       return CircularProgressIndicator();
//     } else {
//       return Text("Something wrong.!!");
//     }
//   },
// );
//   }
// }

// class MyAssetOffline extends StatefulWidget {
//   @override
//   _MyAssetOfflineState createState() => _MyAssetOfflineState();
// }

// class _MyAssetOfflineState extends State<MyAssetOffline> {
//   final ecsLib = getIt.get<ECSLib>();
//   final allTranslations = getIt.get<GlobalTranslations>();
//   Future<List<ModelDataAsset>> getModelData;
//   List<ImageDataEachGroup> imageDataEachGroup = [];
//   Uint8List imageMain;
//   List<Map<String, dynamic>> dataImage = [];
//   List<Map<String, dynamic>> titleAndFileData = [];
//   bool hasData = false;

//   Future<List<ModelDataAsset>> getModelDataAsset() async {
//     print("begin getAllAsset");
//     List<ModelDataAsset> tempAllAsset =
//         await DBProviderAsset.db.getAllDataAsset();
//     await getImageEachAsset(tempAllAsset);
//     tempAllAsset.forEach((v) async {
//       await getProductCateName(v.pdtCatCode);
//     });

//     print("end getAsset");
//     if (tempAllAsset.isNotEmpty) {
//       setState(() => hasData = true);
//       return tempAllAsset;
//     } else {
//       return [];
//     }
//   }

//   Future getImageEachAsset(List<ModelDataAsset> listAsset) async {
//     // print("listAsset => $listAsset");
//     listAsset.forEach((data) async {
//       //each of asset, outside
//       // print("data => ${data.fileAttachID}");
//       Map<String, dynamic> mapTempImage = {};
//       Map<String, dynamic> map =
//           jsonDecode(data.fileAttachID); //get fileID type Json
//       String imageName = '';
//       List<String> imageKey = [];
//       map.forEach((k, v) async {
//         print("$k , $v");
//         imageName = k;
//         mapTempImage.addAll({"$imageName": {}});
//         List list = v as List;
//         list.forEach((f) async {
//           // imageKey.add(f);
//           await getImageFilePool(imageKey: f, imageName: imageName).then((v) {
//             print("v $v");
//           });
//         });
//       });

//       print("-------------------------------------End");
//       // getImage(mapTempImage);
//     });
//   }

//   Future<List<String>> getImageFilePool(
//       {List<String> imageKey, String imageName}) async {
//     List<String> imageData = [];
//     List<FilePool> image;
//     imageKey.forEach((key) async {
//       image = await DBProviderAsset.db.getImagePoolReturn(key);
//       if (image.length > 0) {
//         // print("first.fileData => ${image.first.fileData}");
//         print("Eiei");
//         imageData.add(image.first.fileData);
//         return imageData;
//       } else {
//         return imageData = [];
//       }
//     });
//     return imageData;
//   }

//   List<String> listCatName = [];
//   String catName = 'catName is null';

//   getProductCateName(String catCode) async {
//     var _catName = await DBProviderInitialApp.db
//         .getProductCatName(id: catCode, lang: allTranslations.currentLanguage);
//     // setState(() => listCatName.add(_catName));
//     listCatName.add(_catName);
//     imageDataEachGroup.forEach((v) {
//       print("title ${v.title}");
//       print("imageBase64 ${v.imageBase64.length}");
//     });
//     return _catName;
//   }

//   List<ImageDataEachGroup> getImage(Map<String, dynamic> images) {
//     // Map<String, dynamic> tempImages;
//     List<ImageDataEachGroup> tempImageDataEachGroup = [];
//     if (images != null) {
//       images.forEach((String k, dynamic v) {
//         print("Key $k | Value $v");
//         //   var listTemp = v as List;
//         //   List<String> tempBase64 = [];
//         //   for (var item in listTemp) {
//         //     tempBase64.add(item);
//         //   }
//         //   tempImageDataEachGroup
//         //       .add(ImageDataEachGroup(title: k, imageBase64: tempBase64));
//       });
//       // setState(() => imageDataEachGroup = List.of(tempImageDataEachGroup));

//       // print("imageDataEachGroup => ${imageDataEachGroup.length}");
//     }
//     return tempImageDataEachGroup;
//   }
//   // List<ImageDataEachGroup> getImage(ModelDataAsset images) {
//   //   Map<String, dynamic> tempImages;
//   //   List<ImageDataEachGroup> tempImageDataEachGroup = [];
//   //   if (images.images != null) {
//   //     tempImages = jsonDecode(images.images);
//   //     tempImages.forEach((String k, dynamic v) {
//   //       var listTemp = v as List;
//   //       List<String> tempUrl = [];
//   //       for (var item in listTemp) {
//   //         tempUrl.add(item);
//   //         // setState(() {
//   //         //   listImageUrl.add(item);
//   //         // });
//   //       }
//   //       tempImageDataEachGroup
//   //           .add(ImageDataEachGroup(title: k, imageUrl: tempUrl));
//   //     });
//   //     setState(() => imageDataEachGroup = List.of(tempImageDataEachGroup));

//   //     print("imageDataEachGroup => ${imageDataEachGroup.length}");
//   //   }
//   //   return tempImageDataEachGroup;
//   // }

//   @override
//   void initState() {
//     super.initState();
//     imageDataEachGroup = List<ImageDataEachGroup>();
//     getModelData = getModelDataAsset();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<ModelDataAsset>>(
//       future: getModelData,
//       builder:
//           (BuildContext context, AsyncSnapshot<List<ModelDataAsset>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.data.isNotEmpty) {
//             print("Amount asset => ${snapshot.data.length}");
//             return Padding(
//               padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
//               child: Column(
//                   children: snapshot.data.map((data) {
//                 print("Asset No. ${snapshot.data.indexOf(data)}");
//                 return Card(
//                   elevation: 5.0,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   child: Container(
//                     child: ListTile(
//                       title: Row(
//                         children: <Widget>[
//                           if (data.imageMain != null)
//                             CachedNetworkImage(
//                               imageUrl: data.imageMain,
//                               imageBuilder: (context, imageProvider) =>
//                                   Container(
//                                 width: 100,
//                                 height: 100,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20),
//                                   image: DecorationImage(
//                                       image: imageProvider,
//                                       fit: BoxFit.cover,
//                                       colorFilter: ColorFilter.mode(
//                                           Colors.red, BlendMode.dstATop)),
//                                 ),
//                               ),
//                               placeholder: (context, url) =>
//                                   CircularProgressIndicator(),
//                               errorWidget: (context, url, error) => Icon(
//                                 Icons.error,
//                                 size: 100,
//                               ),
//                             )
//                           else
//                             imageDataEachGroup != null &&
//                                     imageDataEachGroup.length > 0
//                                 ? ClipRRect(
//                                     borderRadius: BorderRadius.circular(10),
//                                     child: Image.memory(
//                                       base64Decode(imageDataEachGroup[
//                                               (snapshot.data.indexOf(data))]
//                                           .imageBase64
//                                           .first),
//                                       width: 130,
//                                       height: 130,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   )
//                                 : Icon(
//                                     Icons.error,
//                                     size: 100,
//                                   ),
//                           Expanded(
//                             flex: 2,
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 10, horizontal: 10),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   TextBuilder.build(
//                                       title: data.title ?? "Empty title",
//                                       style: TextStyleCustom.STYLE_LABEL_BOLD),
//                                   TextBuilder.build(
//                                       title: data.custRemark ?? "Empty Remark",
//                                       style: TextStyleCustom.STYLE_CONTENT,
//                                       textOverflow: TextOverflow.ellipsis,
//                                       maxLine: 2),
//                                   TextBuilder.build(
//                                       title:
//                                           "\nExpire Date : ${data.warrantyExpire.split(" ").first ?? "Empty warrantyExpire"}\nRemaining : ${showDateRemaining(data.warrantyExpire)}",
//                                       style: TextStyleCustom.STYLE_CONTENT
//                                           .copyWith(fontSize: 12),
//                                       textOverflow: TextOverflow.ellipsis,
//                                       maxLine: 3),
//                                   Container(
//                                     margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 5, vertical: 5),
//                                     decoration: BoxDecoration(
//                                         color: ThemeColors.COLOR_GREY
//                                             .withOpacity(0.2),
//                                         borderRadius:
//                                             BorderRadius.circular(20)),
//                                     child: TextBuilder.build(
//                                         title: listCatName[
//                                             snapshot.data.indexOf(data)],
//                                         style: TextStyleCustom.STYLE_CONTENT
//                                             .copyWith(
//                                                 fontSize: 14,
//                                                 color:
//                                                     ThemeColors.COLOR_BLACK)),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       onTap: () async {
//                         await ecsLib
//                             .pushPage(
//                           context: context,
//                           pageWidget: DetailAsset(
//                             dataAsset: data,
//                             showDetailOnline: false,
//                             dataScan: null,
//                           ),
//                         )
//                             .then((v) {
//                           print("come back");
//                           setState(() => getModelData = getModelDataAsset());
//                         });
//                       },
//                     ),
//                   ),
//                 );
//               }).toList()),
//             );
//           } else if (snapshot.data.isEmpty) {
//             return Center(
//               child: TextBuilder.build(title: "Data offline is empty"),
//             );
//           } else
//             return Center(
//               child: TextBuilder.build(title: "Error"),
//             );
//         } else if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else {
//           return Text("Something wrong.!!");
//         }
//       },
//     );
//   }

// String showDateRemaining(String dateTime) {
//   int date = DateTime.parse(dateTime).difference(DateTime.now()).inDays;
//   int hours = DateTime.parse(dateTime).difference(DateTime.now()).inHours;
//   if (date > 0) {
//     return "$date day.";
//   } else if (date == 0 && hours > 0) {
//     return "$hours hours.";
//   } else {
//     return "Expired";
//   }
// }
// }

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
  List<Map<String, List<String>>> keyImage = [];
  List<ImageDataEachGroup> imageDataEachGroup = [];
  List<String> imageData = [];
  List<String> tempImageData = [];
  String catName = '';

  getProductCateName() async {
    var _catName = await DBProviderInitialApp.db.getProductCatName(
        id: widget.data.pdtCatCode, lang: allTranslations.currentLanguage);
    // print("leng : ${allTranslations.currentLanguage}");
    // setState(() {
    catName = _catName;
    // print("catName ====================> $catName");
    // });
  }

  @override
  void initState() {
    super.initState();
    // print("Asset Type : ${widget.data.createType}");
    getProductCateName();
    separateImage(widget.data);
  }

  separateImage(ModelDataAsset images) async {
    Map<String, dynamic> tempImages;
    List<ImageDataEachGroup> tempImageDataEachGroup = [];
    // List<Map<String, List<String>>> keyImage = [];
    List<String> tempKey = [];
    String imageName = '';
    if (images.fileAttachID != null) {
      // print("======== WTOKENID => ${images.wTokenID} ========");
      tempImages = jsonDecode(images.fileAttachID);
      // print("images.fileAttachID => ${images.fileAttachID}");

      tempImages.forEach((String k, dynamic v) {
        imageName = k;
        List listTempKey = v as List;
        // print("New Value length : ${listTempKey.length}");
        // print("======== Name : $k");
        int index = 1;
        int listTempKeyLength = listTempKey.length;
        for (var key in listTempKey) {
          if (listTempKeyLength >= index) {
            // print("Value index No. $index");
            // print("========= KEY : $key");
            tempKey.add(key);
          } else {
            // print("index $index");
            print("length limit");
          }
          index++;
        }
        keyImage.add({"$k": tempKey});
        tempKey = [];
      });
      // print("keyImage => $keyImage");
      imageName = keyImage.first.keys.toList().first;
      // print("getImage by ${keyImage.first[imageName].first}");
      await DBProviderAsset.db
          .getImagePoolReturn(keyImage.first[imageName].first)
          .then((dataImage) {
        if (dataImage != null) {
          imageData.add(dataImage.first.fileData);
        } else {
          print("getImagePool is Null");
        }
      });
      tempImageDataEachGroup
          .add(ImageDataEachGroup(title: imageName, imageBase64: imageData));
      setState(() => imageDataEachGroup = List.of(tempImageDataEachGroup));
      // print("added ${imageDataEachGroup.length}");

      // print("keyImage After Added => $keyImage ");
    }
    return tempImageDataEachGroup;
  }

  @override
  Widget build(BuildContext context) {
    // final assetState = Provider.of<AssetState>(context);
    alert({String title, String content}) => ecsLib.showDialogLib(context,
        content: content,
        textOnButton: allTranslations.text("close"),
        title: "ERROR STATUS");

    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        child: ListTile(
          title: Row(
            children: <Widget>[
              if (widget?.data?.imageMain != null)
                CachedNetworkImage(
                  imageUrl: widget?.data?.imageMain,
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
                imageDataEachGroup.length > 0
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          base64Decode(
                              imageDataEachGroup.first.imageBase64.first),
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.error,
                        size: 150,
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
                          style: TextStyleCustom.STYLE_LABEL_BOLD
                              .copyWith(fontSize: 20)),
                      TextBuilder.build(
                          title: widget.data.custRemark ?? "",
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
            print("Asset Type : ${widget.data.createType}");
            if (widget.data.createType == "C") {
              await ecsLib.pushPage(
                  context: context,
                  pageWidget: DetailAsset(
                    dataAsset: widget.data,
                    showDetailOnline: true,
                    dataScan: null,
                    listImage: keyImage,
                  ));
            } else {
              try {
                ecsLib.showDialogLoadingLib(context);
                await Repository.getDetailAseet(
                    body: {"WTokenID": widget.data.wTokenID}).then((res) async {
                  ecsLib.cancelDialogLoadindLib(context);
                  if (res?.status == true) {
                    ecsLib.pushPage(
                      context: context,
                      pageWidget: DetailAsset(
                        dataAsset: res.data,
                        showDetailOnline: true,
                        dataScan: res.dataScan,
                        listImage: keyImage,
                      ),
                    );
                  } else if (res.status == false) {
                    alert(
                        content:
                            "status false : " + res?.message ?? "status false");
                  } else {
                    // alert(content: res?.message ?? "Something wrong");
                    await ecsLib.pushPage(
                        context: context,
                        pageWidget: DetailAsset(
                          dataAsset: widget.data,
                          showDetailOnline: true,
                          dataScan: ModelDataScan(fileImageID: []),
                          listImage: keyImage,
                        ));
                  }
                });
              } catch (e) {
                alert(title: "CATCH ERROR", content: "catch : $e");
              }
            }
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
