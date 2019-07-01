import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:warranzy_demo/page/main_page/scMain_page.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/app_bar_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class PinCodePageUpdate extends StatefulWidget {
  final PageType type;
  const PinCodePageUpdate({Key key, @required this.type}) : super(key: key);
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

  gotoMainPage() => ecsLib.pushPageAndClearAllScene(
        context: context,
        pageWidget: MainPage(),
      );

  @override
  void initState() {
    super.initState();
  }

  bool pinCorrect() => listEquals(listPinTemp, listPinCorrect);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarThemes.appBarStyle(context: context),
      body: SingleChildScrollView(
        child: Center(
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
      ),
    );
  }

  Widget buildButtonConfirmPinForSetPin() {
    Widget widgetConfirmSetPin = Container();
    switch (type) {
      case PageType.setPin:
        if (listPinTemp.length == 6)
          widgetConfirmSetPin = ButtonBuilder.buttonCustom(
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
                  title: "Use Fingerprint",
                  content: "Do you need to use fingerprint for sign in.",
                  textOk: "Yes, I do",
                  textCancel: "Later",
                )
                    .then((response) {
                  if (response == true) {
                    setState(() {
                      listPinTemp.clear();
                      ecsLib.pushPage(
                        context: context,
                        pageWidget: PinCodePageUpdate(
                          type: PageType.login,
                        ),
                      );
                    });
                  } else {}
                });
                // await _onAlert2ButtonsPressed(context).then((_) async {
                //   await _onAlertButtonPressed(context);
                // });
              });
        else
          widgetConfirmSetPin = Container();

        break;
      default:
        Container();
    }
    return widgetConfirmSetPin;
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
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 70.0,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      child:
          // GridView(
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 3, mainAxisSpacing: 20, crossAxisSpacing: 20),
          //   children: Iterable.generate(
          //       12,
          //       (index) => buttonNumbers(
          //             number: index,
          //             onpressed: () {
          //               checkedButton(index: index + 1);
          //             },
          //           )).toList(),
          // )
          GridView.builder(
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
    return Container(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height / 2 - 100),
        child: Column(children: <Widget>[
          TextBuilder.build(
              title: "Use another verification",
              style: TextStyleCustom.STYLE_CONTENT),
          SizedBox(
            height: 20,
          ),
          ButtonBuilder.buttonCustom(
              context: context,
              label: "Scan fingerprint",
              onPressed: () => gotoMainPage()),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextBuilder.build(
                    title: "Forgot password",
                    style: TextStyleCustom.STYLE_CONTENT),
                TextBuilder.build(title: "\t\t|\t\t"),
                TextBuilder.build(
                    title: "Change Account",
                    style: TextStyleCustom.STYLE_CONTENT)
              ],
            ),
          ),
          SizedBox(
            height: 50.0,
          )
        ]));
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
          child: number == 9
              ? Icon(
                  Icons.fingerprint,
                  size: 40,
                )
              : number == 10
                  ? TextBuilder.build(title: "0")
                  : number == 11
                      ? Icon(
                          Icons.backspace,
                          size: 30,
                        )
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
