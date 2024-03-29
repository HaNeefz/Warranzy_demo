import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warranzy_demo/models/model_cust_temp_data.dart';
import 'package:warranzy_demo/models/model_user.dart';
// import 'package:warranzy_demo/models/model_mas_cust.dart';
import 'package:warranzy_demo/models/model_verify_login.dart';
import 'package:warranzy_demo/page/login_first/scLogin.dart';
import 'package:warranzy_demo/page/main_page/scMain_page.dart';
import 'package:warranzy_demo/services/api/api_services_user.dart';
import 'package:warranzy_demo/services/api/base_url.dart';
import 'package:warranzy_demo/services/api/jwt_service.dart';
import 'package:warranzy_demo/services/api/repository.dart';
import 'package:warranzy_demo/services/api_provider/api_bloc.dart';
import 'package:warranzy_demo/services/api_provider/api_bloc_widget.dart';
import 'package:warranzy_demo/services/api_provider/api_response.dart';
import 'package:warranzy_demo/services/method/methode_helper.dart';
import 'package:warranzy_demo/services/providers/customer_state.dart';
import 'package:warranzy_demo/services/providers/network_provider.dart';
import 'package:warranzy_demo/services/sqflit/db_customers.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/localAuth.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/app_bar_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/manage_image_profile.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class PinCodePageUpdate extends StatefulWidget {
  final PageType type;
  final ModelMasCustomer modelMasCustomer;
  final bool specialPass;
  bool usedPin;
  PinCodePageUpdate(
      {Key key,
      @required this.type,
      this.usedPin = true,
      this.modelMasCustomer,
      this.specialPass})
      : super(key: key);
  @override
  _PinCodePageUpdateState createState() => _PinCodePageUpdateState();
}

class _PinCodePageUpdateState extends State<PinCodePageUpdate> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  JWTService jwtService;
  List<Widget> listDot = List<Widget>(6);
  List<int> listPinTemp = List<int>();
  List<int> listPinCorrect = [0, 0, 0, 0, 0, 0];
  String username = "Username";
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  // bool get setPinCodePage => widget.setPin;
  // bool usedFingerprintOrFaceID = false;
  PageType get type => widget.type;
  bool get usedPin => widget.usedPin;
  ModelMasCustomer get modelMasCustomer => widget.modelMasCustomer;
  ApiBlocGetAllAsset<ModelVerifyLogin> _loginBloc;
  String imageProfile;

  getDataCustomer() async {
    SharedPreferences pref = await _pref;
    ModelCustomers dataCust = await DBProviderCustomer.db.getDataCustomer();
    pref.setString("UserID", dataCust.custUserID);
    pref.setString("UserName", dataCust.custName);
    pref.setString("Email", dataCust.custEmail);
    pref.setString("MobilePhone", dataCust.mobilePhone);
    pref.setString("Address", dataCust.homeAddress);
    pref.setString("BirthYear", dataCust.birthYear);
    pref.setString("CountryCode", dataCust.countryCode);
    pref.setString("CreateDate", dataCust.createDate);
    pref.setString("Gender", dataCust.gender);
    pref.setString("DeviceID", dataCust.deviceID);
    pref.setString("NotificationID", dataCust.notificationID);
    pref.setString("PackageType", dataCust.packageType);
    pref.setString("PinCode", dataCust.pINcode);
    pref.setString("SpecialPass", dataCust.specialPass);
    pref.setString("ImageProfile", dataCust?.imageProfile);
  }

  void sendApiLogin() async {
    SharedPreferences pref = await _pref;
    var postData = {
      "DeviceID": pref?.getString("DeviceID"),
      "PINcode": pref?.getString("PinCode"),
      "CustUserID": pref?.getString("UserID"),
      "TimeZone": await MethodHelper.timeZone,
      "CountryCode": await MethodHelper.countryCode
    };
    print("Data before send Api => $postData");
    ecsLib.showDialogLoadingLib(context);
    // gotoMainPage();
    await Repository.apiLogin(body: postData).then((response) {
      if (response?.status == true) {
        gotoMainPage();
      } else if (response?.status == false) {
        ecsLib
            .showDialogLib(context,
                content: response?.message ?? "PIN Incorrct, Try again.",
                textOnButton: allTranslations.text("close"),
                title: "SERVER ERROR")
            .then((res) {
          if (res) ecsLib.cancelDialogLoadindLib(context);
        });
        setState(() {
          listPinTemp.clear();
        });
      } else {
        ecsLib
            .showDialogLib(context,
                content: response?.message ?? "Catch Error",
                textOnButton: allTranslations.text("close"),
                title: "ERROR")
            .then((res) {
          if (res) ecsLib.cancelDialogLoadindLib(context);
        });
      }
    });

    // ecsLib.showDialogLoadingLib(context);
    // await APIServiceUser.apiVerifyLogin(postData: postData).then((response) {
    //   if (response?.status == true) {
    //     gotoMainPage();
    //   } else if (response?.status == false) {
    //     ecsLib
    //         .showDialogLib(context,
    //             content: response?.message ?? "PIN Incorrct, Try again.",
    //             textOnButton: allTranslations.text("close"),
    //             title: "SERVER ERROR")
    //         .then((res) {
    //       if (res) ecsLib.cancelDialogLoadindLib(context);
    //     });
    //     setState(() {
    //       listPinTemp.clear();
    //     });
    //   } else {
    //     ecsLib
    //         .showDialogLib(context,
    //             content: response?.message ?? "Catch Error",
    //             textOnButton: allTranslations.text("close"),
    //             title: "SERVER ERROR")
    //         .then((res) {
    //       if (res) ecsLib.cancelDialogLoadindLib(context);
    //     });
    //   }
    // });
  }

  Future _localAuth() async {
    await Future.delayed(
        Duration(milliseconds: 200),
        () => localAuth.authenticate().then((_authorized) async {
              if (_authorized) {
                sendApiLogin();
              }
            }));
  }

  gotoMainPage() => ecsLib.pushPageAndClearAllScene(
        context: context,
        pageWidget: MainPage(),
      );

  initMethodLogin() async {
    if (usedPin == true && type == PageType.login) {
      if (widget.specialPass == true) _localAuth();
    } else {
      print(modelMasCustomer?.fullName);
      print(modelMasCustomer?.address);
      print(modelMasCustomer?.countryCode);
      print(modelMasCustomer?.email);
      print(modelMasCustomer?.mobilePhone);
      print(modelMasCustomer?.notificationID);
      print(modelMasCustomer?.pinCode);
      print(modelMasCustomer?.deviceID);
      print(modelMasCustomer?.gender);
      print(modelMasCustomer?.birthYear);
      print(modelMasCustomer?.config?.spacialPass);
    }
  }

  @override
  void initState() {
    super.initState();
    getDataCustomer();
    initMethodLogin();
  }

  bool get pinCorrect => listEquals(listPinTemp, listPinCorrect);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarThemes.appBarStyle(
        context: context,
        // actions: [switchUsedPin()],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            buildLogo(),
            buildTitle(),
            buildSubTitle(),
            showDot(),
            buildButtonNumberOrScan(),
            buildButtonConfirmPinForSetPin() // Show When Type = PageType.setPin
          ],
        ),
      ),
    );
  }

  Widget switchUsedPin() {
    Widget switchWidget = Container();
    switch (type) {
      case PageType.login:
        switchWidget = Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                Switch(
                  onChanged: (bool value) {
                    setState(() {
                      widget.usedPin = value;
                    });
                  },
                  value: widget.usedPin,
                ),
                FlatButton(
                    child: TextBuilder.build(title: "Use PIN"), onPressed: null)
              ],
            )
          ],
        );
        break;
      default:
        switchWidget = Container();
    }
    return switchWidget;
  }

  Widget buildButtonConfirmPinForSetPin() {
    Widget widgetConfirmSetPin = Container();
    switch (type) {
      case PageType.setPin:
        if (listPinTemp.length == 6)
          widgetConfirmSetPin = Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: ButtonBuilder.buttonCustom(
                context: context,
                label: allTranslations.text("continue"),
                onPressed: () async {
                  ecsLib.pushPage(
                    context: context,
                    pageWidget: ImageProfile(
                      hasImage: false,
                      onContinue: (map) async {
                        // await ecsLib.showDialogLib(context,
                        //     title: "SUCCESS!",
                        //     content: "Create your account successfully.",
                        //     textOnButton: allTranslations.text("ok"));

                        await ecsLib
                            .showDialogAction(
                          context,
                          title: "Use Scan to Authen",
                          content: "Do you need to Scan for sign in.",
                          textOk: "Yes, I do",
                          textCancel: "Later",
                        )
                            .then((response) async {
                          String pinCode =
                              "${listPinTemp[0]}${listPinTemp[1]}${listPinTemp[2]}${listPinTemp[3]}${listPinTemp[4]}${listPinTemp[5]}";

                          if (response == true) {
                            ecsLib.showDialogLoadingLib(
                              context,
                            );
                            var data = postDataCutomers(
                                pinCode: pinCode, specialPass: "Y");
                            map.remove("CustUserID");
                            data.addAll(map);
                            print("Data before send : $data");
                            sendApiRegister(data, pinCode);
                          } else {
                            ecsLib.showDialogLoadingLib(
                              context,
                            );
                            var data = postDataCutomers(
                                pinCode: pinCode, specialPass: "N");
                            map.remove("CustUserID");
                            data.addAll(map);
                            print("Data before send : $data");
                            sendApiRegister(data, pinCode);
                          }
                        });
                      },
                    ),
                  );
                }),
          );
        else
          widgetConfirmSetPin = Container();

        break;
      default:
        Container();
    }
    return widgetConfirmSetPin;
  }

  Future sendApiRegister(Map data, String pinCode) async {
    Repository.apiRegister(body: data).then((response) async {
      if (response?.status == true) {
        response.data.pINcode = pinCode;
        response.data.imageProfile = data['ImageProfile'];
        if (await DBProviderCustomer.db.addDataCustomer(response.data) ==
            true) {
          var dataCust = await DBProviderCustomer.db.getDataCustomer();
          // await DBProviderCustomer.db.updateCustomerFieldPinCode(ModelCustomers(
          //     pINcode: pinCode,
          //     custUserID: dataCust.custUserID,
          //     imageProfile: data['ImageProfile']));
          // dataCust = await DBProviderCustomer.db.getDataCustomer();
          print(
              "===========Information Customer============\n${dataCust.toJson()}\n============");
          ecsLib.cancelDialogLoadindLib(context);
          ecsLib.pushPageAndClearAllScene(
              context: context, pageWidget: LoginPage());
          ecsLib.pushPage(
            context: context,
            pageWidget: PinCodePageUpdate(
              type: PageType.login,
              usedPin: data['SpecialPass'] == "Y" ? true : false,
            ),
          );
          // });
        } else {
          ecsLib.showDialogLib(context,
              title: "SQFLITE FAILD!",
              content: "Can't insert data into sqflite.",
              textOnButton: allTranslations.text("close"));
        }
      } else if (response?.status == false) {
        ecsLib.showDialogLib(
          context,
          title: "ERROR REGISTER",
          content: response?.message,
          textOnButton: allTranslations.text("close"),
        );
      } else {
        ecsLib.showDialogLib(context,
            title: "ERROR SERVER!",
            content: response?.message,
            textOnButton: allTranslations.text("close"));
      }
    }).catchError((onError) {
      print("Error => $onError");
    });
  }

  Map postDataCutomers(
      {@required String pinCode, @required String specialPass}) {
    modelMasCustomer?.pinCode = pinCode;
    modelMasCustomer?.config?.spacialPass = specialPass;

    var data = {
      "CustName": modelMasCustomer.fullName,
      "HomeAddress": modelMasCustomer.address,
      "CountryCode": modelMasCustomer.countryCode,
      "CustEmail": modelMasCustomer.email,
      "MobilePhone":
          "${modelMasCustomer.countryNumberPhoneCode}${modelMasCustomer.mobilePhone}",
      "NotificationID": modelMasCustomer.notificationID,
      "PINcode": modelMasCustomer.pinCode,
      "DeviceID": modelMasCustomer.deviceID,
      "Gender": modelMasCustomer.gender,
      "BirthYear": modelMasCustomer.birthYear,
      "SpecialPass": specialPass,
    };
    // print(data);
    return data;
  }

//------------------dot------------------------
  Widget showDot() {
    for (int i = 0; i < 6; i++) {
      if (listPinTemp.length > 0) {
        if (i < listPinTemp.length)
          listDot[i] = dot(active: true);
        else
          listDot[i] = dot();
      } else {
        listDot[i] = dot();
      }
    }
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: listDot),
    );
  }

  Widget dot({bool active = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
            color: active == false ? Colors.grey[300] : Colors.teal,
            shape: BoxShape.circle),
      ),
    );
  }

//------------------------Logo Title SubTitle--------------
  Widget buildLogo() {
    Widget widgetLogo;
    switch (type) {
      case PageType.setPin:
        widgetLogo = ecsLib.logoApp(width: 150, height: 150);
        break;
      default:
        widgetLogo = ShowProfile();
    }
    return widgetLogo;
  }

  Widget buildTitle() {
    Widget widgetTitle;
    switch (type) {
      case PageType.setPin:
        widgetTitle = TextBuilder.build(
            title:
                listPinTemp.length == 6 ? "Confirm Pin Code" : "Set Pin Code",
            style: TextStyleCustom.STYLE_TITLE);
        break;
      default:
        widgetTitle = showUsername();
    }
    return widgetTitle;
  }

  Widget buildSubTitle() {
    Widget widgetSubTitle = Container();
    switch (type) {
      case PageType.setPin:
        widgetSubTitle = TextBuilder.build(
            title: "Set your pin code for sign in",
            style: TextStyleCustom.STYLE_CONTENT);
        break;
      default:
        widgetSubTitle = TextBuilder.build(
            title: "Enter your pin code", style: TextStyleCustom.STYLE_CONTENT);
    }
    return widgetSubTitle;
  }

  //-------------------Button Number Or Button Scan-----------------

  Widget buildButtonNumberOrScan() {
    Widget widgetButtonPinOrScan = Container();
    switch (type) {
      case PageType.setPin:
        widgetButtonPinOrScan = buttonGrideNumber();
        break;
      default:
        widgetButtonPinOrScan = buildButtonScanForLogin();
    }
    return widgetButtonPinOrScan;
  }

  //-------------------Create Button Number-----------------

  Widget buttonGrideNumber() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 70.0,
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GridView.builder(
            shrinkWrap: true,
            itemCount: 12,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 20, crossAxisSpacing: 20),
            itemBuilder: (BuildContext context, int index) {
              return buttonNumbers(
                number: index,
                onpressed: () {
                  checkedButton(index: index + 1);
                },
              );
            },
          ),
          type == PageType.login
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ButtonBuilder.buttonCustom(
                            context: context,
                            colorsButton:
                                ThemeColors.COLOR_MAJOR.withAlpha(200),
                            labelStyle: TextStyleCustom.STYLE_LABEL_BOLD
                                .copyWith(color: ThemeColors.COLOR_WHITE),
                            paddingValue: 0,
                            label: allTranslations.text("forgot_pin"),
                            onPressed: () async {
                              print(DateTime.now());
                              print(DateTime.now().toUtc());
                              print(DateTime.now().timeZoneOffset);

                              print(DateTime.now().timeZoneName);
                              // Dio dio = Dio();
                              // FormData form = FormData.from({
                              //   "Time":
                              //       "${DateTime.now().toUtc().toString()} ${DateTime.now().timeZoneOffset.toString()}"
                              // });
                              // print(form);
                              // try {
                              //   print("sendTime");
                              //   ecsLib.showDialogLoadingLib(context);
                              //   await dio
                              //       .post(
                              //           "http://192.168.0.36:9999/API/v1/User/TestTime",
                              //           data: form)
                              //       .then((response) {
                              //     ecsLib.cancelDialogLoadindLib(context);
                              //     print("response");
                              //     print(response);
                              //   });
                              // } catch (e) {
                              //   print("$e");
                              // }
                              // print(await JWTService.getTokenJWT());
                            }),
                      ),
                      // RaisedButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => NewApiStructure()));
                      //   },
                      // ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

//------get Profile And Username
  Widget showUsername() {
    return new ShowUsername();
  }

  Widget showImage() {
    return CircleAvatar(
      radius: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: imageProfile.startsWith("A") == true
            ? Image.asset(
                "assets/icons/avatars/$imageProfile.png",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
            : Image.memory(
                base64Decode(
                  imageProfile,
                ),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget getProfile() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: imageProfile != null
          ? showImage()
          : Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2),
                  color: ThemeColors.COLOR_WHITE),
              child: Center(
                child: Icon(
                  Icons.account_circle,
                  size: 50.0,
                ),
              ),
            ),
    );
  }

//------button Scan for sign in-------------------------
  Widget buildButtonScanForLogin() {
    if (usedPin == false)
      return Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 2 - 100),
          child: Column(children: <Widget>[
            ButtonBuilder.buttonCustom(
                context: context,
                label: "Scan to Authentication",
                onPressed: () => _localAuth()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: ButtonBuilder.buttonCustom(
                        context: context,
                        paddingValue: 0,
                        colorsButton: ThemeColors.COLOR_TRANSPARENT,
                        label: "Use PIN",
                        onPressed: () {
                          setState(() {
                            widget.usedPin = !widget.usedPin;
                          });
                        }),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: ButtonBuilder.buttonCustom(
                        context: context,
                        colorsButton: ThemeColors.COLOR_MAJOR.withAlpha(200),
                        labelStyle: TextStyleCustom.STYLE_LABEL_BOLD
                            .copyWith(color: ThemeColors.COLOR_WHITE),
                        paddingValue: 0,
                        label: allTranslations.text("forgot_pin"),
                        onPressed: () async {}),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.0,
            )
          ]));
    else
      return buttonGrideNumber();
  }

//-------------------------Show Button Number
  Widget buttonNumbers({int number, Function onpressed}) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      splashColor: Colors.teal,
      onTap: onpressed,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2, color: Colors.teal)),
        child: Center(
          child: number == 9 && type == PageType.login
              ? GestureDetector(
                  onTap: () => _localAuth(),
                  child: Icon(
                    Icons.fingerprint,
                    size: 40,
                  ))
              : number == 10
                  ? TextBuilder.build(title: "0")
                  : number == 11
                      ? Icon(
                          Icons.backspace,
                          size: 30,
                        )
                      : number == 9 && type == PageType.setPin
                          ? TextBuilder.build(
                              title: "", style: TextStyleCustom.STYLE_LABEL)
                          : TextBuilder.build(
                              title: "${number + 1}",
                              style: TextStyleCustom.STYLE_LABEL),
        ),
      ),
    );
  }

  void checkedButton({int index}) {
    if (index - 1 == 9) {
      onCLikedFingerOrFaceID();
    } else if (index - 1 == 11) {
      removeStepCounter();
    } else {
      onClickedNumber(index: index);
      checkPINCorrect();
    }
  }

  checkPINCorrect() async {
    SharedPreferences pref = await _pref;
    if (usedPin == true && listPinTemp.length == 6 && type == PageType.login) {
      var pinCode =
          "${listPinTemp[0]}${listPinTemp[1]}${listPinTemp[2]}${listPinTemp[3]}${listPinTemp[4]}${listPinTemp[5]}";
      if (pref?.getString("PinCode") == pinCode) {
        //pinCorrect == true
        print("Correct");
        // gotoMainPage();

        sendApiLogin();
        setState(() {
          listPinTemp.clear();
        });
      } else {
        print("In Correct");
        ecsLib
            .showDialogLib(context,
                title: "PIN",
                content: allTranslations.text("pin_incorrect"),
                textOnButton: allTranslations.text("close"))
            .whenComplete(() {
          setState(() {
            listPinTemp.clear();
          });
        });
      }
    }
  }

  onClickedNumber({int index}) {
    if (listPinTemp.length < 6) {
      if (index - 1 == 10) {
        setState(() {
          listPinTemp.add(0);
        });
      } else {
        setState(() {
          listPinTemp.add(index);
        });
      }
      print("$listPinTemp => ${listPinTemp.length}");
    } else {
      setState(() {
        listPinTemp.clear();
      });
      print("---listTempPin Clear---");
    }
  }

  onCLikedFingerOrFaceID() {
    print("finger");
  }

  removeStepCounter() {
    if (listPinTemp.length > 0) {
      setState(() {
        listPinTemp.removeLast();
      });
      print("Removed => " + listPinTemp.toString());
    }
  }
}

class ShowUsername extends StatelessWidget {
  const ShowUsername({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerState>(
      builder: (context, customerState, _) => Container(
          child: TextBuilder.build(
              title: customerState.dataCustomer.custName,
              style: TextStyleCustom.STYLE_TITLE.copyWith(letterSpacing: 2))),
    );
  }
}

class NewApiStructure extends StatefulWidget {
  NewApiStructure({
    Key key,
  }) : super(key: key);

  @override
  _NewApiStructureState createState() => _NewApiStructureState();
}

class _NewApiStructureState extends State<NewApiStructure> {
  final body = {
    "CustUserID": "ca3f58b3a0214aaaa68a",
    "PINcode": "111111",
    "DeviceID": "7BAE0E71-C3C2-4532-8C99-DCA7BB713A69",
    "CountryCode": MethodHelper.timeZone,
    "TimeZone": "Asia/Bangkok"
  };

  var url = "/User/Login";

  ApiBlocGetAllAsset<ModelVerifyLogin> _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = ApiBlocGetAllAsset<ModelVerifyLogin>(url: url, body: body);
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Api"),
      ),
      body: //Container(),
          StreamBuilder<ApiResponse<ModelVerifyLogin>>(
        stream: _loginBloc.stmStream,
        builder: (BuildContext context,
            AsyncSnapshot<ApiResponse<ModelVerifyLogin>> snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case Status.COMPLETED:
                return Text("${snapshot.data.data.status}");
                break;
              case Status.ERROR:
                return Column(
                  children: <Widget>[
                    Text(snapshot.data.message),
                    RaisedButton(
                      shape: CircleBorder(),
                      child: Icon(Icons.refresh),
                      onPressed: () {
                        _loginBloc.fetchData();
                      },
                    )
                  ],
                );
                break;
            }
          }
          return Container();
        },
      ),
    );
  }
}

class ShowProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerState>(
      builder: (context, customerState, _) => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: customerState?.dataCustomer?.imageProfile != null
            ? showImage(customerState)
            : Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2),
                    color: ThemeColors.COLOR_WHITE),
                child: Center(
                  child: Icon(
                    Icons.account_circle,
                    size: 50.0,
                  ),
                ),
              ),
      ),
    );
  }

  Widget showImage(CustomerState customerState) {
    var path = customerState?.dataCustomer?.imageProfile;
    return CircleAvatar(
      radius: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: path.startsWith("A") == true
            ? Image.asset(
                "assets/icons/avatars/$path.png",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
            : Image.memory(
                base64Decode(
                  path,
                ),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
