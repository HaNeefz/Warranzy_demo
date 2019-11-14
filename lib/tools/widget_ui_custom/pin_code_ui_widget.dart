import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';

import '../localAuth.dart';
import 'text_builder.dart';

class PinCodeUI extends StatefulWidget {
  final String pinCorrect;
  final bool usedFingerPrintORFaceID;
  final bool onCheckPIN;
  // final
  final int pinAmout;
  final Function(bool, String) onCorrect;
  final Color pinColorActive;
  final Color pinColorInActive;
  final Color colorBorderButton;
  final Color colorButton;
  final TextStyle textStyle;
  final double padding;
  final Color splashColor;

  const PinCodeUI({
    Key key,
    this.pinCorrect,
    this.usedFingerPrintORFaceID = true,
    this.onCorrect,
    this.onCheckPIN = true,
    this.pinColorActive,
    this.pinColorInActive,
    this.pinAmout = 6,
    this.colorBorderButton,
    this.colorButton,
    this.textStyle,
    this.padding,
    this.splashColor,
  }) : super(key: key);
  @override
  _PinCodeUIState createState() => _PinCodeUIState();
}

class _PinCodeUIState extends State<PinCodeUI> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  List<Widget> listDot;
  List<int> listPinTemp = List<int>();

  gotoPage() {}
  @override
  void initState() {
    super.initState();
    listDot = List<Widget>(widget.pinAmout);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          showDot(),
          SizedBox(height: widget.padding ?? 0.0),
          buttonGrideNumber(),
        ],
      ),
    );
  }

  Widget showDot() {
    for (int i = 0; i < widget.pinAmout; i++) {
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
            color: active == false
                ? widget.pinColorActive ?? Colors.grey[300]
                : widget.pinColorInActive ?? Colors.teal,
            shape: BoxShape.circle),
      ),
    );
  }

  Future _localAuth() async {
    await Future.delayed(
        Duration(milliseconds: 200),
        () => localAuth.authenticate().then((_authorized) async {
              if (_authorized) {
                //To do something
                widget.onCorrect(true, allPin());
              }
            }));
  }

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
        ],
      ),
    );
  }

  Widget buttonNumbers({int number, Function onpressed}) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      splashColor: widget.splashColor ?? Colors.teal,
      onTap: onpressed,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.colorButton,
            border: Border.all(
                width: 2, color: widget.colorBorderButton ?? Colors.teal)),
        child: Center(
          child: number == 9 && widget.usedFingerPrintORFaceID == true
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
                      : number == 9
                          ? TextBuilder.build(
                              title: "",
                              style: widget.textStyle ??
                                  TextStyleCustom.STYLE_LABEL)
                          : TextBuilder.build(
                              title: "${number + 1}",
                              style: widget.textStyle ??
                                  TextStyleCustom.STYLE_LABEL),
        ),
      ),
    );
  }

  void checkedButton({int index}) {
    if (index - 1 == 9) {
      //onCLikedFingerOrFaceID();
    } else if (index - 1 == 11) {
      removeStepCounter();
    } else {
      onClickedNumber(index: index);
      if (widget.onCheckPIN == true) checkPINCorrect();
    }
  }

  removeStepCounter() {
    if (listPinTemp.length > 0) {
      setState(() {
        listPinTemp.removeLast();
      });
      print("Removed => " + listPinTemp.toString());
    }
  }

  onClickedNumber({int index}) async {
    if (listPinTemp.length < widget.pinAmout) {
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
      await clearList();
      print("---listTempPin Clear---");
    }
  }

  String allPin() {
    String pin = '';
    listPinTemp.forEach((v) {
      pin = pin + v.toString();
    });
    return pin;
  }

  checkPINCorrect() async {
    String pinCode = allPin();
    if (listPinTemp.length == widget.pinAmout) {
      if (widget.pinCorrect == pinCode) {
        print("pinCorrect : ${widget.pinCorrect}");
        print("Correct");
        widget.onCorrect(true, allPin());
        await clearList();
      } else {
        print("In Correct : $pinCode");
        widget.onCorrect(false, allPin());
        await clearList();
      }
    }
  }

  clearList() async {
    await Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        listPinTemp.clear();
      });
    });
  }
}
