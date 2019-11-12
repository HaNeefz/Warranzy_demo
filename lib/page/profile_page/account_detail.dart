import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_user.dart';
import 'package:warranzy_demo/models/model_verify_phone.dart';
import 'package:warranzy_demo/services/api/repository.dart';
import 'package:warranzy_demo/services/method/methode_helper.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_field_builder.dart';

class AccountDetail extends StatefulWidget {
  final ModelCustomers modelCustomers;

  const AccountDetail({Key key, this.modelCustomers}) : super(key: key);
  @override
  _AccountDetailState createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetail> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  ModelCustomers get modelCustomers => widget.modelCustomers;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _userID;
  TextEditingController _fullName;
  TextEditingController _email;
  TextEditingController _mobileNo;
  TextEditingController _verifyNumber;
  TextEditingController _address;

  String prefix = '';
  bool onEdit = false;
  bool isVerify = false;
  bool showVerify = false;
  bool isRequestOTP = false;
  bool isRequestOTPAgain = false;

  ModelVerifyNumber modelVerifyNumber = ModelVerifyNumber();

  getDataCustomer() async {
    prefix = await DBProviderInitialApp.db
        .getPrefixCountry(await MethodHelper.countryCode);
    if (modelCustomers != null) {
      setState(() {
        _userID = TextEditingController(text: modelCustomers.custUserID);
        _fullName = TextEditingController(text: modelCustomers.custName);
        _email = TextEditingController(text: modelCustomers.custEmail);
        _mobileNo = TextEditingController(
            text: modelCustomers.mobilePhone
                .substring(prefix.length, modelCustomers.mobilePhone.length));
        _address = TextEditingController(text: modelCustomers.homeAddress);
        _verifyNumber = TextEditingController(text: "");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDataCustomer();
  }

  @override
  void dispose() {
    super.dispose();
    _userID.dispose();
    _fullName.dispose();
    _email.dispose();
    _mobileNo.dispose();
    _address.dispose();
    _verifyNumber.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (onEdit == true) {
              ecsLib
                  .showDialogAction(context,
                      title: "Edit Account",
                      content: "Do you want to save before to go back ?",
                      textCancel: allTranslations.text("no"),
                      textOk: allTranslations.text('ok'))
                  .then((onClick) {
                if (onClick == false) Navigator.pop(context);
              });
            } else
              Navigator.pop(context);
          },
        ),
        title: TextBuilder.build(
            title: "Account Details", style: TextStyleCustom.STYLE_APPBAR),
        actions: <Widget>[],
      ),
      body: ecsLib.dismissedKeyboard(
        context,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    showDetail(
                        title: "User ID", controller: _userID, readOnly: true),
                    showDetail(
                      title: "Full Name",
                      controller: _fullName,
                      onChange: (text) => setState(() => onEdit = true),
                    ),
                    showDetail(
                        title: "Email",
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        onChange: (text) => setState(() => onEdit = true),
                        onValidate: (text) {
                          RegExp regex = new RegExp(pattern);
                          if (!regex.hasMatch(text))
                            return 'Enter Valid Email';
                          else
                            return null;
                        }),
                    showDetail(
                      title: "Address",
                      controller: _address,
                      onChange: (text) => setState(() => onEdit = true),
                    ),
                    showDetail(
                      title: "Mobile No",
                      controller: _mobileNo,
                      keyboardType: TextInputType.number,
                      onChange: (text) async {
                        if (await checkNumberChange() != false) {
                          setState(() {
                            onEdit = true;
                            showVerify = true;
                            isVerify = false;
                            isRequestOTP = true;
                          });
                        } else {
                          setState(() {
                            showVerify = false;
                            isVerify = false;
                            isRequestOTP = false;
                            isRequestOTPAgain = false;
                          });
                        }
                      },
                      leader: Container(
                        margin: EdgeInsets.only(right: 5),
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        child: TextBuilder.build(title: "+ ${prefix ?? ""}"),
                      ),
                    ),
                    showVerify == true
                        ? showDetail(
                            title: "Verify Number",
                            controller: _verifyNumber,
                            maxLength: 4,
                            onValidate: (text) {},
                            keyboardType: TextInputType.number,
                            onChange: (text) => setState(() => onEdit = true),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: onEdit == true
                          ? ButtonBuilder.buttonCustom(
                              context: context,
                              paddingValue: 5,
                              label: labelButton(),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  if (await checkNumberChange() == false) {
                                    //No Change Number To do something
                                    print("No Change Number");

                                    print("FullName : ${_fullName.text}");
                                    print("email : ${_email.text}");
                                    print("address : ${_address.text}");
                                    print("mobile : ${_mobileNo.text}");
                                  } else {
                                    //Change nubmer, Could verify number before edit
                                    if (isVerify == true) {
                                      onVerifyNumber();
                                    } else {
                                      onRequestOTP();
                                    }
                                  }
                                }
                              })
                          : Container(),
                    ),
                    isRequestOTPAgain == true
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: onEdit == true
                                ? ButtonBuilder.buttonCustom(
                                    context: context,
                                    paddingValue: 5,
                                    labelStyle: TextStyleCustom.STYLE_LABEL_BOLD
                                        .copyWith(color: Colors.white),
                                    colorsButton: Colors.red.withOpacity(0.4),
                                    label: "Try Request OTP",
                                    onPressed: () async {
                                      var body = {
                                        "MobilePhone":
                                            "${prefix + ecsLib.chenkNumberStartWith(_mobileNo.text)}",
                                        "Country":
                                            await MethodHelper.countryCode,
                                        "TimeZone": await MethodHelper.timeZone,
                                      };
                                      ecsLib.showDialogLoadingLib(context,
                                          content: "Try Request OTP");
                                      Repository.apiVerifyNumberUsedEditAccount(
                                              body: body)
                                          .then((response) {
                                        if (response.status == true) {
                                          modelVerifyNumber = response;
                                          setState(() {
                                            isVerify = true;
                                            isRequestOTP = false;
                                            isRequestOTPAgain = true;
                                          });
                                        } else if (response.status == false) {
                                          setState(() {
                                            isVerify = false;
                                            isRequestOTP = true;
                                            isRequestOTPAgain = true;
                                          });
                                          alert(
                                              title: "REQUEST OTP FAIL",
                                              content: response.message);
                                        } else {
                                          alert(content: response.message);
                                        }
                                      });
                                    })
                                : Container(),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String labelButton() {
    if (onEdit == true && isRequestOTP == true && isVerify == false) {
      return "Request OTP";
    } else if (onEdit == true && isRequestOTP == false && isVerify == true) {
      return "Verify and Edit";
    } else
      return "Edit";
  }

  Text headLine(String title) {
    return TextBuilder.build(
        title: title ?? "", style: TextStyleCustom.STYLE_CONTENT);
  }

  Widget showDetail(
      {String title,
      TextEditingController controller,
      bool readOnly = false,
      Function(String) onChange,
      Function(String) onSave,
      Function(String) onValidate,
      int maxLength,
      TextInputType keyboardType = TextInputType.text,
      Widget leader}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: TextFieldBuilder.textFormFieldCustom(
              controller: controller,
              borderOutLine: false,
              maxLength: maxLength,
              leader: leader,
              validate: true,
              readOnly: readOnly,
              keyboardType: keyboardType,
              onValidate: onValidate,
              onChange: (text) => onChange(text),
              title: title ?? "",
              titleStyle: TextStyleCustom.STYLE_CONTENT),
        )
      ],
    );
  }

  alert({String title, String content}) {
    ecsLib.showDialogLib(context,
        content: content ?? "",
        textOnButton: allTranslations.text('close'),
        title: title ?? "");
  }

  Future<bool> checkNumberChange() async {
    String inputNumber = ecsLib.chenkNumberStartWith(_mobileNo.text);

    String oldNumber = modelCustomers.mobilePhone
        .substring(prefix.length, modelCustomers.mobilePhone.length);
    // print("inputNumber : $inputNumber");
    // print("oldNumber : $oldNumber");
    if (inputNumber == oldNumber)
      return false; // No change
    else
      return true; // Change
  }

  onVerifyNumber() {
    if (ecsLib.checkOTPTimeOut(dateFormatted: modelVerifyNumber.createDate) ==
        false) {
      if (_verifyNumber.text == modelVerifyNumber.codeVerify.toString()) {
        //api Edit account
        print("Pass");
      } else {
        alert(title: "Verify OTP", content: "OTP Incorrect.");
      }
    } else {
      alert(title: "OTP TIME OUT.", content: "Please try requset OTP again.");
    }
  }

  onRequestOTP() async {
    print("Change Number");
    ecsLib
        .showDialogAction(context,
            title: "Edit Account",
            content:
                "The Mobile No. has changed, You should verify Number before editing.\n\nDo you need to Request OTP ?",
            textOk: allTranslations.text("ok"),
            textCancel: allTranslations.text("cancel"))
        .then((onClick) async {
      if (onClick == true) {
        print("verify Number");

        var body = {
          "MobilePhone":
              "${prefix + ecsLib.chenkNumberStartWith(_mobileNo.text)}",
          "Country": await MethodHelper.countryCode,
          "TimeZone": await MethodHelper.timeZone,
        };
        print(body);
        ecsLib.showDialogLoadingLib(context, content: "Request OTP");
        await Repository.apiVerifyNumberUsedEditAccount(body: body)
            .then((response) {
          ecsLib.cancelDialogLoadindLib(context);
          if (response.status == true) {
            setState(() {
              isVerify = true;
              isRequestOTP = false;
              isRequestOTPAgain = true;
            });
            modelVerifyNumber = response;
          } else if (response.status == false) {
            setState(() {
              isVerify = false;
              isRequestOTP = true;
              isRequestOTPAgain = true;
            });
            alert(title: "REQUEST OTP FAIL", content: response.message);
          } else {
            alert(content: response.message);
          }
        });
        // apiVerify
      }
    });
  }
}
