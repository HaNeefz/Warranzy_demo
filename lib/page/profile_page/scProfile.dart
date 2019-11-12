import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/models/model_user.dart';
// import 'package:warranzy_demo/models/model_mas_cust.dart';
import 'package:warranzy_demo/page/login_first/scLogin.dart';
import 'package:warranzy_demo/page/splash_screen/scSplash_screen.dart';
import 'package:warranzy_demo/services/calls_and_message/calls_and_message.dart';
import 'package:warranzy_demo/services/method/methode_helper.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';
import 'package:warranzy_demo/services/sqflit/db_customers.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/form_input_data.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_field_builder.dart';

import 'account_detail.dart';

class ProfilePage extends StatefulWidget {
  final String heroTag;

  const ProfilePage({Key key, this.heroTag}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final CallsAndMessageService _service = CallsAndMessageService();
  bool checkInformationChange = false;
  ModelCustomers dataCust;
  bool _usedTouchID = false;

  @override
  void initState() {
    super.initState();
    getDataCustomers();
  }

  void getDataCustomers() async {
    var tempDataCust = await DBProviderCustomer.db.getDataCustomer();
    dataCust = tempDataCust;
    setState(() => _usedTouchID = dataCust.specialPass == "Y" ? true : false);

    print("ID Customer => ${await DBProviderCustomer.db.getIDCustomer()}");
    print(
        "<=========================MAS_CUSTOMER=========================>\n${dataCust.toJson()}\n<================================================================>");
  }

  sendTocloudFireStore() async {
    try {
      print("Click");
      Firestore.instance.collection('BrandName').snapshots().listen((data) {
        for (var list in data.documents) print(list.data);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Text textContent(String text) {
      return TextBuilder.build(
          title: text ?? "", style: TextStyleCustom.STYLE_CONTENT);
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        // backgroundColor: Colors.grey[400],
        body: FormBuilder(
          key: _fbKey,
          onChanged: (data) {
            print(data);
          },
          child: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: ThemeColors.COLOR_WHITE,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                // FlatButton(
                //   child: Icon(
                //     Icons.lock_open,
                //     size: 30,
                //     color: ThemeColors.COLOR_WHITE,
                //   ),
                //   onPressed: () {

                //   },
                // )
              ],
              elevation: 5,
              forceElevated: true,
              flexibleSpace: Container(
                  color: ThemeColors.COLOR_WHITE,
                  child: Stack(children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(
                        Assets.BACK_GROUND_APP,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: buildHeroProfile(),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 200.0),
                        child: TextBuilder.build(
                            title: "${dataCust?.custName ?? ""}",
                            style: TextStyleCustom.STYLE_APPBAR
                                .copyWith(color: ThemeColors.COLOR_WHITE)),
                      ),
                    )
                  ])
                  // child: Image.asset(Assets.BACK_GROUND_APP,fit: BoxFit.cover,),
                  ),
              // pinned: true,
              // snap: true,
              // floating: true,
              expandedHeight: 300,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    headLine("Profile"),
                    listTile(
                        title: "Profile",
                        icons: Icons.account_circle,
                        onPressed: () {
                          ecsLib.pushPage(
                              context: context,
                              pageWidget: AccountDetail(
                                modelCustomers: dataCust,
                              ));
                        }),
                    listTile(
                        title: "Your Address",
                        icons: Icons.person_pin_circle,
                        onPressed: () async {
                          // print("Tap Your Address");
                          // await DBProviderAsset.db.getDataAssetByWTokenID(
                          //     wTokenID: "ca3f5-TH-ef074218359d482fa68b517ed");
                          // await DBProviderAsset.db.deleteAllAsset();
                        }),
                    Divider(),
                    headLine("Security"),
                    listTile(
                        title: "Change PIN",
                        icons: Icons.keyboard,
                        onPressed: () {}),
                    listTile(
                        title: "Sign in with touch ID",
                        icons: Icons.fingerprint,
                        trailing: Switch(
                          value: _usedTouchID,
                          onChanged: (bool value) {
                            setState(() => _usedTouchID = value);
                          },
                        )),
                    Divider(),
                    headLine("Setting app"),
                    listTile(
                        title: "Language",
                        icons: Icons.g_translate,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            textContent(allTranslations.currentLanguage == "en"
                                ? "English"
                                : "ภาษาไทย"),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                        onPressed: () {}),
                    listTile(
                        title: "Feedback",
                        icons: Icons.feedback,
                        onPressed: () {}),
                    Divider(),
                    headLine("About warranzy"),
                    listTile(
                        title: "Customer Service",
                        icons: Icons.call,
                        trailing: textContent("02-330-9390"),
                        onPressed: () => _service.call("02-330-9390")),
                    listTile(
                        title: "FAQ", icons: Icons.message, onPressed: () {}),
                    listTile(
                        title: "Privacy",
                        icons: Icons.account_balance,
                        onPressed: () {}),
                    listTile(
                        title: "Terms of Service",
                        icons: Icons.account_balance,
                        onPressed: () {}),
                    Divider(),
                    listTile(
                        title: "Logout",
                        icons: Icons.lock_open,
                        onPressed: () {
                          MethodHelper.clearTimeZoneAndCountryCode();
                          ecsLib.pushPageAndClearAllScene(
                            context: context,
                            pageWidget: SplashScreenPage(),
                          );
                        }),
                    Divider(),
                  ],
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: <Widget>[
              //     buttonContact(Icons.call, "Call Center", Colors.green,
              //         () => _service.call("0123456789")),
              //     buttonContact(Icons.sms, "Send Sms", Colors.blue,
              //         () => _service.sendSms("0123456789")),
              //     buttonContact(Icons.email, "Email us", Colors.redAccent,
              //         () => _service.sendEmail("wpoungchoo@gmail.com")),
              //   ],
              // ),
              // RaisedButton(
              //   child: Icon(Icons.check),
              //   onPressed: () {
              //     _fbKey.currentState.save();
              //     if (_fbKey.currentState.validate()) {
              //       print(_fbKey.currentState.value);
              //     }
              //   },
              // ),
              // RaisedButton(
              //   child: Text("Send to cloud_firestore"),
              //   onPressed: sendTocloudFireStore,
              // ),
              // RaisedButton(
              //   child: Text("Test Loading"),
              //   onPressed: () => ecsLib.showDialogLoadingLib(context),
              // ),
              // RaisedButton(
              //   child: Text("GetCategory"),
              //   onPressed: () => DBProviderInitialApp.db.getGroupCategory(),
              // ),
              // RaisedButton(
              //     child: Text("GetSubCategoryByGroup"),
              //     onPressed: () async {
              //       // DBProviderInitialApp.db
              //       //     .getSubCategoryByGroupID(groupID: "A");
              //       await DBProviderInitialApp.db.getAllSubCategory();
              //     }),
              // RaisedButton(
              //   child: Text("GetAsset"),
              //   onPressed: () async {
              //     // Map<String, dynamic> tempM = {};
              //     List<ModelDataAsset> modelData =
              //         await DBProviderAsset.db.getAllDataAsset();
              //     for (var temp in modelData) {
              //       print(temp.fileAttachID);
              //       //   Map<String, dynamic> jsonDecoder =
              //       //       jsonDecode(temp.fileAttachID);
              //       //   tempM = await getListImage(jsonDecoder);
              //       //   print(tempM);
              //       //   // print(jsonDecoder);
              //       //   print("---------------");
              //     }
              //     // await DBProviderAsset.db.getMainImage();
              //     await DBProviderAsset.db.getAllBrandName();
              //   },
              // ),
              // RaisedButton(
              //   child: Text("Clear SQLite"),
              //   onPressed: () async {
              //     await DBProviderAsset.db.deleteAllAsset();
              //     // print(await DBProviderCustomer.db.getSpecialPass());
              //   },
              // ),
              // RaisedButton(
              //   child: Text("getImagePool"),
              //   onPressed: () async {
              //     await DBProviderAsset.db.getAllDataFilePool();
              //     // print(await DBProviderCustomer.db.getSpecialPass());
              //   },
              // ),
              // // RaisedButton(
              // //   child: Text("Clear SQLite"),
              // //   onPressed: () async {
              // //     await DBProviderAsset.db.deleteAllAsset();
              // //     // print(await DBProviderCustomer.db.getSpecialPass());
              // //   },
              // // ),
            ])),
            // SliverFixedExtentList(
            //   itemExtent: 150.0,
            //   delegate: SliverChildListDelegate([
            //     Container(color: Colors.red),
            //     Container(color: Colors.green),
            //     Container(color: Colors.blue),
            //     Container(color: Colors.pink),
            //     Container(color: Colors.yellow),
            //     Container(color: Colors.orange),
            //     Container(color: Colors.purple),
            //     Container(color: Colors.black),
            //     Container(color: Colors.grey),
            //   ]),
            // )
          ]),
        ));
  }

  Hero buildHeroProfile() {
    return Hero(
      child: Container(
        width: 160,
        height: 160,
        child: Stack(
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
            Positioned(
              bottom: 20,
              right: 0,
              child: Container(
                width: 50,
                height: 50,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.teal),
                child: IconButton(
                  icon: Icon(Icons.add_a_photo, size: 30, color: Colors.white),
                  onPressed: () async {
                    await buildShowModalBottomSheet(context);
                  },
                ),
              ),
            )
            // Icon(Icons.person_pin,
            //     size: 100, color: Colors.white),
          ],
        ),
      ),
      tag: "PhotoProfile",
    );
  }

  Widget headLine([String title]) {
    return TextBuilder.build(
        title: title ?? "",
        style: TextStyleCustom.STYLE_LABEL
            .copyWith(fontSize: 20, color: ThemeColors.COLOR_THEME_APP));
  }

  Widget listTile(
      {IconData icons, String title, Function onPressed, Widget trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(
          icons,
          size: 30,
          color: ThemeColors.COLOR_BLACK,
        ),
        title: TextBuilder.build(title: title ?? ""),
        trailing: trailing ?? Icon(Icons.arrow_forward_ios),
        onTap: onPressed,
      ),
    );
  }

  // Future<Map<String, dynamic>> getListImage(Map<String, dynamic> map) async {
  //   Map<String, dynamic> mapImage = {};
  //   map.forEach((k, v) async {
  //     mapImage.addAll({"$k": []});
  //     List vv = v as List;
  //     print("$k | ${vv.length}");
  //     List<String> img = [];
  //     for (var list in vv) {
  //       var tempImagePool = await DBProviderAsset.db.getImagePool(list);
  //       img.add(tempImagePool);
  //     }
  //     mapImage["$k"] = img;
  //   });
  //   return mapImage.isNotEmpty ? mapImage : {};
  // }

  Widget buttonContact(
      [IconData icons, String title, Color colors, Function onPressed]) {
    return RaisedButton.icon(
      color: colors,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: Icon(icons),
      label: TextBuilder.build(
          title: title,
          textAlign: TextAlign.center,
          style: TextStyleCustom.STYLE_LABEL.copyWith(fontSize: 12)),
      onPressed: onPressed,
    );
  }

  Widget formInformation(title, widget,
      {@required bool showTextReadOnly,
      @required bool editAble,
      Function onTapEdit}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: RichText(
            text: TextSpan(children: [
              TextSpan(text: title, style: TextStyleCustom.STYLE_LABEL),
              showTextReadOnly == true ? TextSpan(text: '\n') : TextSpan(),
              showTextReadOnly == true
                  ? TextSpan(
                      text: "(ReadOnly)",
                      style: TextStyleCustom.STYLE_ERROR.copyWith(fontSize: 10))
                  : TextSpan()
            ]),
          )),
          Expanded(flex: 3, child: widget),
          editAble == true
              ? IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onTapEdit,
                )
              : Container()
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
              leading: Icon(
                Icons.edit,
                color: ThemeColors.COLOR_BLACK,
              ),
              title: TextBuilder.build(title: "Edit Profile"),
              onTap: () async {
                print("Edit Profile");
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.add_a_photo,
                color: ThemeColors.COLOR_BLACK,
                size: 35,
              ),
              title: TextBuilder.build(title: "Add Profile"),
              onTap: () {
                print("Add profile");
              },
            ),
          ],
        ),
      ),
    );
  }
}
