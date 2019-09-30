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
  @override
  void initState() {
    super.initState();
    getDataCustomers();
  }

  void getDataCustomers() async {
    var tempDataCust = await DBProviderCustomer.db.getDataCustomer();
    dataCust = tempDataCust;
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
                FlatButton(
                  child: Icon(
                    Icons.lock_open,
                    size: 30,
                    color: ThemeColors.COLOR_WHITE,
                  ),
                  onPressed: () {
                    MethodHelper.clearTimeZoneAndCountryCode();
                    ecsLib.pushPageAndClearAllScene(
                      context: context,
                      pageWidget: SplashScreenPage(),
                    );
                  },
                )
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
                      child: Hero(
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 3)),
                          child: Center(
                            child: FlutterLogo(
                              size: 100,
                              colors: ThemeColors.COLOR_THEME_APP,
                            ),
                          ),
                        ),
                        tag: "PhotoProfile",
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 200.0),
                        child: TextBuilder.build(
                            title: "Username",
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

              // title: TextBuilder.build(
              //     title: "Profile", style: TextStyleCustom.STYLE_APPBAR),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              // FormWidgetBuilder.formDropDown(
              //     key: "test1",
              //     title: "DropDowm",
              //     validate: [
              //       FormBuilderValidators.required(),
              //     ],
              //     items: [
              //       1,
              //       2,
              //       3
              //     ]),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextBuilder.build(
                        title: "Profile",
                        style: TextStyleCustom.STYLE_LABEL.copyWith(
                            fontSize: 25, color: ThemeColors.COLOR_THEME_APP)),
                    ListTile(
                      leading: Icon(
                        Icons.account_circle,
                        size: 40,
                        color: ThemeColors.COLOR_BLACK,
                      ),
                      title: TextBuilder.build(title: "Account Details"),
                      trailing: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  buttonContact(Icons.call, "Call Center", Colors.green,
                      () => _service.call("0123456789")),
                  buttonContact(Icons.sms, "Send Sms", Colors.blue,
                      () => _service.sendSms("0123456789")),
                  buttonContact(Icons.email, "Email us", Colors.redAccent,
                      () => _service.sendEmail("wpoungchoo@gmail.com")),
                ],
              ),
              RaisedButton(
                child: Icon(Icons.check),
                onPressed: () {
                  _fbKey.currentState.save();
                  if (_fbKey.currentState.validate()) {
                    print(_fbKey.currentState.value);
                  }
                },
              ),
              RaisedButton(
                child: Text("Send to cloud_firestore"),
                onPressed: sendTocloudFireStore,
              ),
              RaisedButton(
                child: Text("Test Loading"),
                onPressed: () => ecsLib.showDialogLoadingLib(context),
              ),
              RaisedButton(
                child: Text("GetCategory"),
                onPressed: () => DBProviderInitialApp.db.getGroupCategory(),
              ),
              RaisedButton(
                  child: Text("GetSubCategoryByGroup"),
                  onPressed: () async {
                    // DBProviderInitialApp.db
                    //     .getSubCategoryByGroupID(groupID: "A");
                    await DBProviderInitialApp.db.getAllSubCategory();
                  }),
              RaisedButton(
                child: Text("GetAsset"),
                onPressed: () async {
                  // Map<String, dynamic> tempM = {};
                  // List<ModelDataAsset> modelData =
                  //     await DBProviderAsset.db.getAllDataAsset();
                  // for (var temp in modelData) {
                  //   Map<String, dynamic> jsonDecoder =
                  //       jsonDecode(temp.fileAttachID);
                  //   tempM = await getListImage(jsonDecoder);
                  //   print(tempM);
                  //   // print(jsonDecoder);
                  //   print("---------------");
                  // }
                  // await DBProviderAsset.db.getMainImage();
                  await DBProviderAsset.db.getAllBrandName();
                },
              ),
            ])),
            SliverFixedExtentList(
              itemExtent: 150.0,
              delegate: SliverChildListDelegate([
                Container(color: Colors.red),
                Container(color: Colors.green),
                Container(color: Colors.blue),
                Container(color: Colors.pink),
                Container(color: Colors.yellow),
                Container(color: Colors.orange),
                Container(color: Colors.purple),
                Container(color: Colors.black),
                Container(color: Colors.grey),
              ]),
            )
          ]),
        ));
  }

  Future<Map<String, dynamic>> getListImage(Map<String, dynamic> map) async {
    Map<String, dynamic> mapImage = {};
    map.forEach((k, v) async {
      mapImage.addAll({"$k": []});
      List vv = v as List;
      print("$k | ${vv.length}");
      List<String> img = [];
      for (var list in vv) {
        var tempImagePool = await DBProviderAsset.db.getImagePool(list);
        img.add(tempImagePool);
      }
      mapImage["$k"] = img;
    });
    return mapImage.isNotEmpty ? mapImage : {};
  }

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
}
