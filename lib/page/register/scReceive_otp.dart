import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:warranzy_demo/models/model_cust_temp_data.dart';
import 'package:warranzy_demo/models/model_verify_phone.dart';
import 'package:warranzy_demo/page/pin_code/scPinCode.dart';
import 'package:warranzy_demo/services/api/api_services.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class ReceiveOTP extends StatefulWidget {
  final ModelMasCustomer modelMasCustomer;
  final ModelVerifyNumber modelVerifyNumber;

  const ReceiveOTP({Key key, this.modelMasCustomer, this.modelVerifyNumber})
      : super(key: key);
  @override
  _ReceiveOTPState createState() => _ReceiveOTPState();
}

class _ReceiveOTPState extends State<ReceiveOTP> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  TextEditingController controller = TextEditingController();
  final int otpTimeOut = 120;
  String thisText = "";
  int pinLength = 4;

  bool hasError = false;
  String errorMessage;

  ModelMasCustomer get modelMasCustomer => widget.modelMasCustomer;
  ModelVerifyNumber get modelVerifyData => widget.modelVerifyNumber;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle styleText =
        TextStyleCustom.STYLE_LABEL_BOLD.copyWith(color: COLOR_BLACK);
    return Scaffold(
      appBar: AppBar(
        title: TextBuilder.build(
            title: "Confirm OTP", style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(5, 30, 5, 5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 20.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Please Enter the OTP to Verify your Account\n\n",
                      style: TextStyleCustom.STYLE_TITLE
                          .copyWith(fontSize: 22, color: COLOR_THEME_APP),
                    ),
                    TextSpan(
                        text:
                            "A OTP has been sent to +${modelMasCustomer.countryNumberPhoneCode} ${modelMasCustomer.mobilePhone}",
                        style: TextStyleCustom.STYLE_LABEL
                            .copyWith(fontSize: 15, color: COLOR_GREY)),
                  ]),
                ),
              ),
              PinCodeTextField(
                autofocus: true,
                controller: controller,
                hideCharacter: false,
                highlight: true,
                highlightColor: COLOR_GREY,
                defaultBorderColor: COLOR_THEME_APP,
                hasTextBorderColor: COLOR_THEME_APP,
                maxLength: pinLength,
                hasError: hasError,
                // maskCharacter: "*", //😎
                onTextChanged: (text) {
                  setState(() {
                    hasError = false;
                  });
                },
                onDone: (text) {
                  // print("DONE $text");
                },
                pinCodeTextFieldLayoutType:
                    PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
                wrapAlignment: WrapAlignment.start,
                pinBoxDecoration:
                    ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                pinTextStyle: TextStyle(fontSize: 30.0),
                pinTextAnimatedSwitcherTransition:
                    ProvidedPinBoxTextAnimation.scalingTransition,
                pinTextAnimatedSwitcherDuration: Duration(milliseconds: 100),
              ),
              Visibility(
                child: Text(
                  "Wrong PIN!",
                  style: TextStyle(color: Colors.red),
                ),
                visible: hasError,
              ),
              Padding(
                padding: EdgeInsets.only(top: 32),
                child: ButtonBuilder.buttonCustom(
                    context: context,
                    paddingValue: 20,
                    label: allTranslations.text("confirm"),
                    onPressed: () {
                      sendOTP(context);
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: TextBuilder.build(
                        title: "Resend OTP",
                        style: TextStyleCustom.STYLE_TEXT_UNDERLINE
                            .copyWith(fontSize: 15)),
                    onTap: () async {
                      var data = {
                        "MobilePhone":
                            "${modelMasCustomer.countryNumberPhoneCode}${modelMasCustomer.mobilePhone}",
                        "Country": modelMasCustomer.countryCode,
                        "TimeZone": modelMasCustomer.timeZone,
                      };
                      print("data befor send => $data");
                      ecsLib.showDialogLoadingLib(
                        context: context,
                        content: "Resend OTP, Wait a minutes.",
                      );
                      await apiVerifyNumberTryRequest(postData: data)
                          .then((response) {
                        Navigator.pop(context);
                        print(
                            "createDate Old => ${modelVerifyData.createDate}");
                        print(
                            "verifyCode Old => ${modelVerifyData.codeVerify}");
                        modelVerifyData.createDate = response.createDate;
                        modelVerifyData.codeVerify = response.codeVerify;
                        print(
                            "createDate Change => ${modelVerifyData.createDate}");
                        print(
                            "verifyCode Change => ${modelVerifyData.codeVerify}");
                        sendOTP(context);
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void sendOTP(BuildContext context) {
    if (checkOTPTimeOut() == false) {
      // false ยังไม่หมดเวลา
      if (controller.text == modelVerifyData?.codeVerify.toString()) {
        print("Verify Done.");
        ecsLib.pushPage(
          context: context,
          pageWidget: PinCodePageUpdate(
            type: PageType.setPin,
            modelMasCustomer: modelMasCustomer,
          ),
        );
      } else
        setState(() {
          hasError = true;
        });
    } else {
      ecsLib.showDialogLib(
        context: context,
        title: "OTP TIME OUT",
        content: "OTP time out!. Please resend OTP.",
        textOnButton: allTranslations.text("close"),
      );
    }
  }

  bool checkOTPTimeOut() {
    var createOTPTime = DateTime.parse(modelVerifyData.createDate);
    var dateTimeNow = DateTime.now();
    if (dateTimeNow.compareTo(createOTPTime) > otpTimeOut)
      return true;
    else
      return false;
  }
}
