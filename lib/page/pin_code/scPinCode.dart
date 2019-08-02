import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_mas_customers.dart';
import 'package:warranzy_demo/page/login_first/scLogin.dart';
import 'package:warranzy_demo/page/main_page/scMain_page.dart';
import 'package:warranzy_demo/services/api/api_services.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/localAuth.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/app_bar_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class PinCodePageUpdate extends StatefulWidget {
  final PageType type;
  final ModelMasCustomer modelMasCustomer;
  bool usedPin;
  PinCodePageUpdate(
      {Key key,
      @required this.type,
      this.usedPin = false,
      this.modelMasCustomer})
      : super(key: key);
  @override
  _PinCodePageUpdateState createState() => _PinCodePageUpdateState();
}

class _PinCodePageUpdateState extends State<PinCodePageUpdate> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  List<Widget> listDot = List<Widget>(6);
  List<int> listPinTemp = List<int>();
  List<int> listPinCorrect = [0, 0, 0, 0, 0, 0];
  // bool get setPinCodePage => widget.setPin;
  // bool usedFingerprintOrFaceID = false;
  PageType get type => widget.type;
  bool get usedPin => widget.usedPin;
  ModelMasCustomer get modelMasCustomer => widget.modelMasCustomer;

  Future _localAuth() async {
    await Future.delayed(
        Duration(milliseconds: 300),
        () => localAuth.authenticate().then((_authorized) {
              if (_authorized) {
                gotoMainPage();
              }
            }));
  }

  gotoMainPage() => ecsLib.pushPageAndClearAllScene(
        context: context,
        pageWidget: MainPage(),
      );

  @override
  void initState() {
    super.initState();
    if (usedPin == false && type == PageType.login) {
      _localAuth();
    }
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
                  await ecsLib.showDialogLib(
                      context: context,
                      title: "SUCCESS!",
                      content: "Create your account successfully.",
                      textOnButton: allTranslations.text("ok"));
                  await ecsLib
                      .showDialogAction(
                    context: context,
                    title: "Use Scan to Authen",
                    content: "Do you need to Scan for sign in.",
                    textOk: "Yes, I do",
                    textCancel: "Later",
                  )
                      .then((response) {
                    String pinCode =
                        "${listPinTemp[0]}${listPinTemp[1]}${listPinTemp[2]}${listPinTemp[3]}${listPinTemp[4]}${listPinTemp[5]}";

                    if (response == true) {
                      Navigator.pop(context);
                      ecsLib.showDialogLoadingLib(
                        context: context,
                        content: "Please wait.",
                      );
                      var data =
                          postDataCutomers(pinCode: pinCode, spacialPass: "Y");
                      apiRegister(postData: data).then((reponse) {
                        print(reponse);
                        if (reponse["Status"] == true) {
                          Navigator.pop(context);
                          setState(() {
                            listPinTemp.clear();
                            ecsLib.pushPageAndClearAllScene(
                                context: context, pageWidget: LoginPage());
                            ecsLib.pushPage(
                              context: context,
                              pageWidget: PinCodePageUpdate(
                                type: PageType.login,
                              ),
                            );
                          });
                        } else {
                          showErrorRegister();
                        }
                      });
                    } else {
                      Navigator.pop(context);
                      ecsLib.showDialogLoadingLib(
                        context: context,
                        content: "Please wait.",
                      );
                      var data =
                          postDataCutomers(pinCode: pinCode, spacialPass: "N");
                      apiRegister(postData: data).then((response) {
                        print(response);
                        if (response["Status"] == true) {
                          Navigator.pop(context);
                          setState(() {
                            listPinTemp.clear();
                            ecsLib.pushPage(
                              context: context,
                              pageWidget: PinCodePageUpdate(
                                type: PageType.login,
                                usedPin: true,
                              ),
                            );
                          });
                        } else {
                          showErrorRegister();
                        }
                      });
                    }
                  });
                  // await _onAlert2ButtonsPressed(context).then((_) async {
                  //   await _onAlertButtonPressed(context);
                  // });
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

  void showErrorRegister() {
    ecsLib.showDialogLib(
      context: context,
      title: "ERROR REGISTER",
      content: "Can't register!",
      textOnButton: allTranslations.text("close"),
    );
  }

  Map postDataCutomers(
      {@required String pinCode, @required String spacialPass}) {
    modelMasCustomer?.pinCode = pinCode;
    modelMasCustomer?.config?.spacialPass = spacialPass;

    var data = {
      "CustName": modelMasCustomer.fullName,
      "HomeAddress": modelMasCustomer.address,
      "ContryCode": modelMasCustomer.countryCode,
      "CustEmail": modelMasCustomer.email,
      "MobilePhone":
          "${modelMasCustomer.countryNumberPhoneCode}${modelMasCustomer.mobilePhone}",
      "NotificationID": modelMasCustomer.notificationID,
      "PINcode": modelMasCustomer.pinCode,
      "DeviceID": modelMasCustomer.deviceID,
      "Gender": modelMasCustomer.gender,
      "BirdYear": modelMasCustomer.birthYear,
      "SpacialPass": spacialPass,
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
        widgetLogo = getProfile();
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
        widgetTitle = getUername();
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
      child: GridView.builder(
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
    );
  }

//------get Profile And Username
  Widget getUername() {
    return Container(
      child: TextBuilder.build(
          title: "Username", style: TextStyleCustom.STYLE_TITLE),
    );
  }

  Widget getProfile() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2),
            color: COLOR_WHITE),
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
                        colorsButton: COLOR_TRANSPARENT,
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
                        colorsButton: COLOR_MAJOR.withAlpha(200),
                        labelStyle: TextStyleCustom.STYLE_LABEL_BOLD
                            .copyWith(color: COLOR_WHITE),
                        paddingValue: 0,
                        label: allTranslations.text("forgot_pin"),
                        onPressed: () {}),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20.0),
                  //   child: GestureDetector(
                  //       child: TextBuilder.build(
                  //           title: allTranslations.text("forgot_pin"),
                  //           style: TextStyleCustom.STYLE_LABEL
                  //               .copyWith(color: COLOR_THEME_APP)),
                  //       onTap: () {}),
                  // ),
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

  checkPINCorrect() {
    if (usedPin == true && listPinTemp.length == 6) {
      if (pinCorrect == true) {
        print("Correct");
        gotoMainPage();
      } else {
        print("In Correct");
        ecsLib
            .showDialogLib(
                context: context,
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
