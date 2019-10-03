import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warranzy_demo/models/model_cust_temp_data.dart';
import 'package:warranzy_demo/models/model_user.dart';
// import 'package:warranzy_demo/models/model_mas_cust.dart';
import 'package:warranzy_demo/models/model_verify_phone.dart';
import 'package:warranzy_demo/page/login_first/scLogin.dart';
import 'package:warranzy_demo/page/pin_code/scPinCode.dart';
import 'package:warranzy_demo/services/api/api_services_user.dart';
import 'package:warranzy_demo/services/api/repository.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';
import 'package:warranzy_demo/services/sqflit/db_customers.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/app_bar_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';

class VerifyChangeDevice extends StatefulWidget {
  final ModelVerifyNumber modelVerifyNumber;
  final ModelMasCustomer modelMasCustomer;

  const VerifyChangeDevice(
      {Key key, this.modelVerifyNumber, this.modelMasCustomer})
      : super(key: key);
  @override
  _VerifyChangeDeviceState createState() => _VerifyChangeDeviceState();
}

class _VerifyChangeDeviceState extends State<VerifyChangeDevice> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  TextEditingController controller = TextEditingController();
  ModelVerifyNumber get modelVerifyData => widget.modelVerifyNumber;
  ModelMasCustomer get modelMasCustomer => widget.modelMasCustomer;

  final int otpTimeOut = 120;
  String thisText = "";
  bool hasError = false;

  int pinLength = 4;

  getInfoDevice() async {
    var pref = await _pref;
    var deviceID = pref.getString("DeviceID");
    var notificationID = pref.getString("NotificationID");
    var dataDeviceInfo = {
      "DeviceID": deviceID,
      "NotificationID": notificationID
    };
    print("DeviceInfo => $dataDeviceInfo");
    return dataDeviceInfo;
  }

  @override
  void initState() {
    super.initState();
    getInfoDevice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarThemes.appBarStyle(context: context),
      body: ecsLib.dismissedKeyboard(
        context,
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _fbKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ecsLib.logoApp(width: 200, height: 200),
                SizedBox(
                  height: 50,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Please Enter the OTP to Verify your Account\n\n",
                      style: TextStyleCustom.STYLE_TITLE.copyWith(
                          fontSize: 22, color: ThemeColors.COLOR_THEME_APP),
                    ),
                    TextSpan(
                        text:
                            "A OTP has been sent to +${modelMasCustomer.countryNumberPhoneCode} ${modelMasCustomer.mobilePhone}",
                        style: TextStyleCustom.STYLE_LABEL.copyWith(
                            fontSize: 15, color: ThemeColors.COLOR_GREY)),
                  ]),
                ),
                PinCodeTextField(
                  autofocus: true,
                  controller: controller,
                  hideCharacter: false,
                  highlight: true,
                  highlightColor: ThemeColors.COLOR_GREY,
                  defaultBorderColor: ThemeColors.COLOR_THEME_APP,
                  hasTextBorderColor: ThemeColors.COLOR_THEME_APP,
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
                        checkOTPCorrect(context);
                      }),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 32),
                //   child: ButtonBuilder.buttonCustom(
                //       context: context,
                //       paddingValue: 20,
                //       label: "Delete User and Asset",
                //       onPressed: () async {
                //         await DBProviderCustomer.db.deleteAllDataOfCustomer();
                //         await DBProviderAsset.db.deleteAllAsset();
                //       }),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updatePINcode() async {
    //when download data completed, should update PINcode cause reponse don't send PINcode.
    var pref = await _pref;
    var pinCode = pref.getString("PINcode");
    var dataCust = await DBProviderCustomer.db.getDataCustomer();
    var res = await DBProviderCustomer.db.updateCustomerFieldPinCode(
        ModelCustomers(custUserID: dataCust.custUserID, pINcode: pinCode));
    var dataCustShow = await DBProviderCustomer.db.getDataCustomer();
    print(
        "<================Update data complete==================>\n${dataCustShow.toJson()}\n===================================================");
    return res;
  }

  void checkOTPCorrect(BuildContext context) async {
    if (checkOTPTimeOut() == false) {
      // false ยังไม่หมดเวลา
      if (controller.text == modelVerifyData?.codeVerify.toString()) {
        print("Verify Done.");
        Map<String, String> postData = await getInfoDevice();
        postData.addAll({
          "MobilePhone":
              "${modelMasCustomer.countryNumberPhoneCode}${modelMasCustomer.mobilePhone}"
        });
        print(postData);
        ecsLib.showDialogLoadingLib(context);

        Repository.apiVerifyChangeDevice(body: postData).then((response) async {
          if (response?.status == true) {
            if (await DBProviderCustomer.db.checkHasCustomer() == true) {
              print("Have information customer, deleting");
              await DBProviderCustomer.db.deleteAllDataOfCustomer();
              await DBProviderAsset.db.deleteAllAsset();
            }
            if (await DBProviderCustomer.db.addDataCustomer(response.data) ==
                true) {
              if (await updatePINcode() == true) {
                try {
                  for (var warranzyUsed in response.dataAssetUsed.warranzyUsed)
                    await DBProviderAsset.db
                        .insertDataWarranzyUesd(warranzyUsed)
                        .catchError(
                            (onError) => print("warranzyUsed : $onError"));
                } catch (e) {
                  print("insertDataWarranzyUesd => $e");
                }
                try {
                  for (var warranzyLog in response.dataAssetUsed.warranzyLog)
                    await DBProviderAsset.db
                        .insertDataWarranzyLog(warranzyLog)
                        .catchError((onError) => print("warranzyLog $onError"));
                } catch (e) {
                  print("insertDataWarranzyLog => $e");
                }
                response.dataAssetUsed.filePool.forEach((data) async {
                  try {
                    await DBProviderAsset.db
                        .insertDataFilePool(data)
                        .catchError((onError) => print("filePool $onError"))
                        .whenComplete(() {
                      Navigator.pop(context);
                      ecsLib.pushPageReplacement(
                        context: context,
                        pageWidget: PinCodePageUpdate(
                          type: PageType.login,
                          usedPin: true,
                        ),
                      );
                      ecsLib.showDialogLib(
                        context,
                        title: "COMPLETED INFORMATION",
                        content:
                            "Download information completed. You can Sign in now.",
                        textOnButton: allTranslations.text("ok"),
                      );
                    });
                  } catch (e) {
                    print("insertDataFilePool => $e");
                  }
                });
              } else {
                ecsLib.showDialogLib(
                  context,
                  title: "UPDATE PINCODE",
                  content: "Update pin incomplete. Try again.",
                  textOnButton: allTranslations.text("ok"),
                );
              }
            } else {
              ecsLib.showDialogLib(context,
                  title: "DOWNLOAD INFORMATION FAILD",
                  content: "Download information incomplete. Try again.",
                  textOnButton: allTranslations.text("close"));
            }
          } else if (response?.status == false) {
            ecsLib.cancelDialogLoadindLib(context);
            ecsLib.showDialogLib(context,
                title: "STATUS FAILD",
                content: response?.message,
                textOnButton: allTranslations.text("close"));
          } else {
            ecsLib.cancelDialogLoadindLib(context);
            ecsLib.showDialogLib(context,
                title: "SERVER ERROR",
                content: response?.message,
                textOnButton: allTranslations.text("close"));
          }
        });
      } else
        setState(() {
          hasError = true;
        });
    } else {
      ecsLib.showDialogLib(
        context,
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
