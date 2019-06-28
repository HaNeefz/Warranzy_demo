import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:warranzy_demo/page/main_page/scMain_page.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/app_bar_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class LoginByScan extends StatefulWidget {
  @override
  _LoginByScanState createState() => _LoginByScanState();
}

class _LoginByScanState extends State<LoginByScan> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();

  gotoMainPage() => ecsLib.pushPageAndClearAllScene(
        context: context,
        pageWidget: MainPage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 200),
        child: Column(
          children: <Widget>[
            TextBuilder.build(
                title: "Use another verification",
                style: TextStyleCustom.STYLE_CONTENT),
            SizedBox(
              height: 20,
            ),
            ButtonBuilder.buttonCustom(
                context: context,
                label: "Scan fingerprint",
                onPressed: gotoMainPage),
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
            ),
          ],
        ),
      ),
    );
  }
}

class PinCodePage extends StatefulWidget {
  final bool setPin;

  PinCodePage({
    Key key,
    this.setPin = true,
  }) : super(key: key);
  @override
  _PinCodePageState createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  List<Widget> listDot = List<Widget>(6);
  List<int> listPinTemp = List<int>();
  List<int> listPinCorrect = [0, 0, 0, 0, 0, 0];
  // bool get setPinCodePage => widget.setPin;
  // bool usedFingerprintOrFaceID = false;

  @override
  void initState() {
    super.initState();
  }

  bool pinCorrect() => listEquals(listPinTemp, listPinCorrect);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarThemes.appBarStyle(context: context),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ecsLib.logoApp(width: 150, height: 150),
          TextBuilder.build(
              title: listPinTemp.length == 6
                  ? "Confirm Pin Code"
                  : "Set Pin Code",
              style: TextStyleCustom.STYLE_TITLE),
          showDot(),
          buttonGrideNumber(),
          buildButtonConfirm(context)
        ],
      ),
    );
  }

  Widget buildButtonConfirm(BuildContext context) {
    if (listPinTemp.length == 6)
      return ButtonBuilder.buttonCustom(
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
                  ecsLib.pushPageAndClearAllScene(
                    context: context,
                    pageWidget: LoginByScan(),
                  );
                });
              } else {}
            });
            // await _onAlert2ButtonsPressed(context).then((_) async {
            //   await _onAlertButtonPressed(context);
            // });
          });
    else
      return Container();
  }

  Future _onAlertButtonPressed(context) async {
    Alert(
      context: context,
      type: AlertType.success,
      title: "SUCCESS",
      desc: "Create your account successfully.",
      buttons: [
        DialogButton(
          gradient:
              LinearGradient(colors: [Colors.teal[400], Colors.teal[100]]),
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
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

  Widget buttonGrideNumber() {    
    return Container(
        padding: EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 70.0,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 20, crossAxisSpacing: 20),
          children: Iterable.generate(
              12,
              (index) => buttonNumbers(
                    number: index,
                    onpressed: () {
                      checkedButton(index: index + 1);
                    },
                  )).toList(),
        )
        // GridView.builder(
        //   itemCount: number,
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 3, mainAxisSpacing: 20, crossAxisSpacing: 20),
        //   itemBuilder: (BuildContext context, int index) {
        //     return buttonNumbers(
        //       number: index,
        //       onpressed: () {
        //         checkedButton(index: index + 1);
        //       },
        //     );
        //   },
        // ),
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
