import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_user.dart';
import 'package:warranzy_demo/services/api/repository.dart';
import 'package:warranzy_demo/services/sqflit/db_customers.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/app_bar_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/pin_code_ui_widget.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class ChangPINcodePage extends StatefulWidget {
  final ModelCustomers modelCustomer;

  const ChangPINcodePage({Key key, this.modelCustomer}) : super(key: key);
  @override
  _ChangPINcodePageState createState() => _ChangPINcodePageState();
}

class _ChangPINcodePageState extends State<ChangPINcodePage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  gotoPage() {}
  String currentPIN;
  bool v = true;
  bool isContinueFirst = false;
  bool isContinueSecond = false;
  bool isCheckPin = true;

  @override
  void initState() {
    super.initState();
    currentPIN = widget.modelCustomer.pINcode;
  }

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
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: buildTitle(),
            ),
            PinCodeUI(
              usedFingerPrintORFaceID: false,
              pinCorrect: currentPIN,
              pinAmout: 6,
              onCheckPIN: true,
              onCorrect: (correct, newPin) {
                if (isContinueSecond == false) {
                  if (isCheckPin == true) {
                    if (correct == true) {
                      setState(() {
                        currentPIN = newPin;
                        isContinueFirst = true;
                        isCheckPin = false;
                      });
                    } else {
                      showAlert(
                          title: "PIN INCORRECT",
                          content: "Current pin incorrect.");
                    }
                  } else {
                    setState(() {
                      isContinueSecond = true;
                      currentPIN = newPin;
                    });
                  }
                } else {
                  if (currentPIN == newPin) {
                    print("pin completed : $newPin");
                    ecsLib
                        .showDialogAction(context,
                            title: "Change PIN",
                            content: "Do you want to change PIN ?",
                            textOk: allTranslations.text("ok"),
                            textCancel: allTranslations.text("no"))
                        .then((onClick) async {
                      if (onClick == true) {
                        await sendAPIChangePIN(newPin);
                      } else {
                        Navigator.pop(context, false);
                      }
                    });
                  } else {
                    showAlert(
                        title: "PIN INCORRECT", content: "Pin not match.");
                  }
                }
              },
            ),
            // if (isContinueSecond == true)
            //   ButtonBuilder.buttonCustom(
            //       context: context,
            //       colorsButton: ThemeColors.COLOR_MAJOR.withAlpha(200),
            //       labelStyle: TextStyleCustom.STYLE_LABEL_BOLD
            //           .copyWith(color: ThemeColors.COLOR_WHITE),
            //       paddingValue: 50,
            //       label: allTranslations.text("continue"),
            //       onPressed: () async {}),
          ],
        ),
      ),
    );
  }

  showAlert({
    String title,
    String content,
  }) {
    ecsLib.showDialogLib(
      context,
      content: content ?? "",
      textOnButton: allTranslations.text("close"),
      title: title ?? "",
    );
  }

  Widget buildTitle() {
    return TextBuilder.build(
        title: showTitle(), style: TextStyleCustom.STYLE_TITLE);
  }

  String showTitle() {
    if (isContinueFirst == true && isContinueSecond == false)
      return "Enter new PIN";
    else if (isContinueFirst == true && isContinueSecond == true) {
      return "Confirm new PIN";
    } else
      return "Enter your current PIN";
  }

  sendAPIChangePIN(String newPIN) async {
    ModelCustomers modelCustomer = ModelCustomers(
        custUserID: widget.modelCustomer.custUserID, pINcode: newPIN);
    var body = {
      "CustUserID": modelCustomer.custUserID,
      "PINcode": modelCustomer.pINcode
    };
    ecsLib.showDialogLoadingLib(context, content: "Update PIN Code");
    await Repository.apiChangePINCode(body: body).then((update) async {
      ecsLib.cancelDialogLoadindLib(context);
      if (update.status == true) {
        await DBProviderCustomer.db.updatePinCode(modelCustomer).then((v) {
          if (v > 0) {
            Navigator.pop(context, true);
            showAlert(title: "Update PIN", content: "Update completed.");
          } else {
            showAlert(title: "Update PIN fail", content: "Update Incompleted.");
          }
        });
      } else if (update.status == false) {
        showAlert(title: "Update PIN fail.", content: update.message);
      } else {
        showAlert(title: "Update PIN fail.", content: update.message);
      }
    });
  }

  updatePINonSQLite(String newPin) async {}
}
