import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:warranzy_demo/models/model_user.dart';
import 'package:warranzy_demo/page/splash_screen/scSplash_screen.dart';
import 'package:warranzy_demo/services/api/repository.dart';
import 'package:warranzy_demo/services/calls_and_message/calls_and_message.dart';
import 'package:warranzy_demo/services/method/methode_helper.dart';
import 'package:warranzy_demo/services/sqflit/db_customers.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/manage_image_profile.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/show_image_profile.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import 'account_detail.dart';
import 'change_pin_code.dart';
import 'language.dart';

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
    dataCust = null;
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

  showAlert({String title, String content}) {
    ecsLib.showDialogLib(context,
        title: title ?? "Title is empty",
        content: content ?? "Content is empty",
        textOnButton: allTranslations.text("close"));
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
                        onPressed: () async {
                          await ecsLib
                              .pushPage(
                                  context: context,
                                  pageWidget: AccountDetail(
                                    modelCustomers: dataCust,
                                  ))
                              .then((comback) {
                            if (comback == true) getDataCustomers();
                          });
                        }),
                    Divider(),
                    headLine("Security"),
                    listTile(
                        title: "Change PIN",
                        icons: Icons.keyboard,
                        onPressed: () async {
                          await ecsLib
                              .pushPage(
                                  context: context,
                                  pageWidget: ChangPINcodePage(
                                    modelCustomer: dataCust,
                                  ))
                              .then((comback) {
                            if (comback == true) getDataCustomers();
                          });
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => TestCategory()));
                        }),
                    listTile(
                        title: "Sign in with touch ID",
                        icons: Icons.fingerprint,
                        trailing: Switch(
                          value: _usedTouchID,
                          onChanged: (bool value) async {
                            await ecsLib
                                .showDialogAction(context,
                                    title:
                                        "Change Sign in with touch ID or FaceID",
                                    content:
                                        "Are you sure to change SpecialPass ?",
                                    textOk: allTranslations.text("ok"),
                                    textCancel: allTranslations.text("cancel"))
                                .then((onClick) {
                              if (onClick == true) changeSpecialPass(value);
                            });
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
                        onPressed: () {
                          ecsLib.pushPage(
                            context: context,
                            pageWidget: LanguagePage(),
                          );
                        }),
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

                          imageCache.clear();
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

  changeSpecialPass(value) async {
    dataCust.specialPass = value == true ? "Y" : "N";
    print("dataCust.specialPass :${dataCust.specialPass}");
    var body = {
      "CustUserID": dataCust.custUserID,
      "SpecialPass": dataCust.specialPass
    };
    ecsLib.showDialogLoadingLib(context, content: "Changing SpecialPass");
    await Repository.apiChangeSpecialPass(body: body).then((response) async {
      ecsLib.cancelDialogLoadindLib(context);
      if (response.status == true) {
        await DBProviderCustomer.db
            .updateSpecialPass(dataCust)
            .then((update) async {
          if (update == true) {
            setState(() => _usedTouchID = value);
          }
        });
      } else if (response.status == false) {
        showAlert(
            title: "Update SpecialPass fail", content: "${response.message}");
      } else {
        showAlert(
            title: "Update SpecialPass fail", content: "${response.message}");
      }
    });
  }

  ImageProvider<dynamic> showImage() {
    if (dataCust?.imageProfile?.startsWith("A") == true) {
      return AssetImage("assets/icons/avatars/${dataCust?.imageProfile}.png");
    } else {
      return MemoryImage(base64Decode(dataCust.imageProfile));
    }
  }

  Widget buildHeroProfile() {
    return Container(
      width: 160,
      height: 160,
      // color: Colors.red,
      child: Stack(
        children: <Widget>[
          Hero(
            child: ShowImageProfile(
              imagePath: dataCust?.imageProfile,
              radius: 80,
            ),
            tag: widget.heroTag,
          ),
          Positioned(
            right: 0,
            bottom: 10,
            child: ControlledAnimation(
              duration: Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, scale) => Opacity(
                opacity: scale,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.teal),
                  child: IconButton(
                    icon:
                        Icon(Icons.add_a_photo, size: 30, color: Colors.white),
                    onPressed: () async {
                      ecsLib.pushPage(
                        context: context,
                        pageWidget: ImageProfile(
                          hasImage: true,
                          imagesMySelf: dataCust?.imageProfile,
                          modelCustomer: dataCust,
                          onContinue: (map) async {
                            print("map: $map");
                            await ecsLib
                                .showDialogAction(context,
                                    title: "IMAGE PROFILE",
                                    content:
                                        "Are you sure to change Image profile ?",
                                    textOk: allTranslations.text("ok"),
                                    textCancel: allTranslations.text("cancel"))
                                .then((onClick) async {
                              if (onClick == true) {
                                ecsLib.showDialogLoadingLib(context,
                                    content: "Update Image Profile");
                                await Repository.apiUpdateImageProfile(
                                        body: map)
                                    .then((responseUpdate) async {
                                  ecsLib.cancelDialogLoadindLib(context);
                                  if (responseUpdate.status == true) {
                                    ModelCustomers model = ModelCustomers()
                                      ..custUserID = map['CustUserID']
                                      ..imageProfile = map['ImageProfile'];
                                    await DBProviderCustomer.db
                                        .updateUpdateImageProfile(model)
                                        .then((update) {
                                      if (update == true) {
                                        Navigator.pop(context);
                                        getDataCustomers();
                                      } else {
                                        showAlert(
                                            content: "Update Sqlite fail");
                                      }
                                    });
                                  } else if (responseUpdate.status == false) {
                                    showAlert(
                                        title: "Upload Fail",
                                        content: "${responseUpdate.message}");
                                  } else {
                                    showAlert(
                                        title: "Upload Fail",
                                        content: "${responseUpdate.message}");
                                  }
                                });
                              } else {
                                Navigator.pop(context);
                              }
                            });
                          },
                        ),
                      );
                      // await buildShowModalBottomSheet(context);
                    },
                  ),
                ),
              ),
            ),
          )
          // Icon(Icons.person_pin,
          //     size: 100, color: Colors.white),
        ],
      ),
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
