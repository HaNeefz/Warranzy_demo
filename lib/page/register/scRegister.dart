import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_cupertino.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warranzy_demo/models/model_country_birth_year.dart';
import 'package:warranzy_demo/models/model_cust_temp_data.dart';
import 'package:warranzy_demo/models/model_verify_phone.dart';
import 'package:warranzy_demo/page/pin_code/scPinCode.dart';
import 'package:warranzy_demo/services/api/api_services_user.dart';
import 'package:warranzy_demo/services/providers/notification_state.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/app_bar_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_field_builder.dart';
import 'package:device_info/device_info.dart';

import 'scReceive_otp.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final FixedExtentScrollController fixController =
      FixedExtentScrollController();
  final ModelDataCountry modelCountry = ModelDataCountry();
  final ModelDataBirthYear modelBirthYear = ModelDataBirthYear();
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  NotificationState noti = NotificationState();
  String _dvID = '';
  String _notiID = '';

  getDvIDwithNotiID() async {
    var pref = await _pref;
    _dvID = pref?.getString("DeviceID");
    _notiID = pref?.getString("NotificationID");
    print("DeviceID => $_dvID");
    print("NotificationID => $_notiID");
    print("get pref complete");
  }

  @override
  void initState() {
    super.initState();
    getDvIDwithNotiID();
  }

  bool agree = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarThemes.appBarStyle(context: context),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _fbKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ecsLib.logoApp(width: 200, height: 200),
              TextBuilder.build(
                  title: "Registeration", style: TextStyleCustom.STYLE_TITLE),
              space(10),
              TextBuilder.build(
                  title: "Create your account to member",
                  style: TextStyleCustom.STYLE_CONTENT),
              space(10),
              buildCountryCode(),
              buildFormFullName(),
              buildFormGender(),
              buildBirthYear(context),
              buildFormAddress(),
              buildFormEmail(),
              buildFormMobileNumber(),
              buildChackAgree(),
              space(20),
              ButtonBuilder.buttonCustom(
                  paddingValue: 20.0,
                  context: context,
                  colorsButton: agree == false ? Colors.grey.shade200 : null,
                  label: allTranslations.text("continue"),
                  onPressed: agree == true ? registerContinue : null),
              space(50),
            ],
          ),
        ),
      ),
    );
  }

  registerContinue() async {
    _fbKey.currentState.save();
    if (_fbKey.currentState.validate()) {
      if (checkSelectCountryAndBirthYear(context)) {
        String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
        var deviceIDAndPlayerIDAndTimeZone = {
          "DeviceID": _dvID,
          "NotificationID": _notiID,
          "TimeZone": currentTimeZone
        };
        _fbKey.currentState.value["MobilePhone"] =
            chenkNumberStartWith(_fbKey.currentState.value["MobilePhone"]);
        var masCustomersData = _fbKey.currentState.value
          ..addAll(modelCountry.toMap())
          ..addAll(modelBirthYear.toMap())
          ..addAll(deviceIDAndPlayerIDAndTimeZone);
        print(masCustomersData);

        var dataCustomers = ModelMasCustomer.fromJson(masCustomersData);
        ecsLib.showDialogLoadingLib(
            context: context, content: "Verifying", barrierDismissible: false);
        var data = {
          "Email": dataCustomers.email,
          "MobilePhone":
              "${dataCustomers.countryNumberPhoneCode}${dataCustomers.mobilePhone}",
          "Country": dataCustomers.countryCode,
          "TimeZone": dataCustomers.timeZone,
        };
        // ecsLib.pushPage(
        //   context: context,
        //   pageWidget: PinCodePageUpdate(
        //     type: PageType.setPin,
        //     modelMasCustomer: dataCustomers,
        //   ),
        // ); // Skip verify phone number

        APIServiceUser.apiVerifyNumber(postData: data).then((response) async {
          print(response);
          if (response?.status == true) {
            ecsLib.cancelDialogLoadindLib(context);
            ecsLib.pushPage(
                context: context,
                pageWidget: ReceiveOTP(
                  modelMasCustomer: dataCustomers,
                  modelVerifyNumber: response,
                ));
          } else if (response?.status == false) {
            ecsLib.cancelDialogLoadindLib(context);
            ecsLib.showDialogLib(
                content: response?.message ?? "Duplicate number",
                context: context,
                textOnButton: allTranslations.text("close"),
                title: "DUPLICATE PHONE NUMBER");
          } else {
            ecsLib.cancelDialogLoadindLib(context);
            ecsLib.showDialogLib(
                content: response?.message,
                context: context,
                textOnButton: allTranslations.text("close"),
                title: "SERVER ERROR");
          }
        });
      }
    }
  }

  String chenkNumberStartWith(String numb) {
    String numbNew = numb;
    if (numbNew.startsWith(RegExp(r'0')) == true) {
      print("numberStartWith Zero is true");
      numbNew = numbNew.replaceFirst(RegExp(r'0'), '');
    }
    return numbNew;
  }

  Container buildBirthYear(BuildContext context) {
    return Container(
      child: paddingWidget(
          child: ButtonBuilder.buttonCustom(
              colorsButton: ThemeColors.COLOR_TRANSPARENT,
              labelStyle: TextStyleCustom.STYLE_LABEL_BOLD
                  .copyWith(color: ThemeColors.COLOR_GREY),
              paddingValue: 0,
              context: context,
              label: modelBirthYear.selectedBirthYears
                  ? "Birth year is " + modelBirthYear.birthYear
                  : modelBirthYear.birthYear,
              onPressed: () {
                Picker(
                    itemExtent: 40,
                    adapter: NumberPickerAdapter(data: [
                      NumberPickerColumn(
                        begin: 1900,
                        end: 2010,
                        initValue: 1950,
                      )
                    ]),
                    /*PickerDataAdapter<String>(
                                pickerdata: ["English", "Thai"]) */
                    delimiter: [PickerDelimiter(child: Container())],
                    hideHeader: true,
                    confirmText: allTranslations.text("confirm"),
                    cancelText: allTranslations.text("cancel"),
                    title: new Text("Please Select"),
                    onConfirm: (Picker picker, List value) {
                      print("Picker value : ${picker.getSelectedValues()}");
                      setState(() {
                        modelBirthYear.birthYear =
                            "${picker.getSelectedValues().first.toString()}";
                        modelBirthYear.setSelectedBirthYear = true;
                      });
                    }).showDialog(context);
              })),
    );
  }

  bool checkSelectCountryAndBirthYear(BuildContext context) {
    bool dataCorrect = false;
    if (modelCountry.selectedCountry == true &&
        modelBirthYear.selectedBirthYear == true) {
      dataCorrect = true;
    } else if (modelCountry.selectedCountry == false)
      ecsLib.showDialogLib(
        context: context,
        title: "SELECT COUNTRY",
        content: "Please select country.",
        textOnButton: allTranslations.text("close"),
      );
    else //(modelBirthYear.selectedBirthYear == false)
      ecsLib.showDialogLib(
        context: context,
        title: "SELECT BIRTH YEAR",
        content: "Please select birth year.",
        textOnButton: allTranslations.text("close"),
      );
    return dataCorrect;
  }

  Widget buildFormGender() {
    return paddingWidget(
        child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(width: 0.7, color: ThemeColors.COLOR_GREY),
          borderRadius: BorderRadius.circular(25)),
      child: FormBuilderRadio(
        attribute: "CustGender",
        leadingInput: true,
        validators: [FormBuilderValidators.required()],
        decoration: InputDecoration(
            labelText: "Gender",
            labelStyle: TextStyleCustom.STYLE_CONTENT.copyWith(fontSize: 20)),
        options: ["Male", "Female"]
            .map((gender) => FormBuilderFieldOption(
                label: gender, value: gender.substring(0, 1)))
            .toList(growable: false),
      ),
    ));
  }

  Widget space(double spaceValue) {
    return SizedBox(
      height: spaceValue,
    );
  }

  Widget buildChackAgree() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Checkbox(
            onChanged: (bool value) {
              setState(() {
                agree = value;
              });
            },
            value: agree,
          ),
          TextBuilder.build(title: "I accept"),
          SizedBox(
            width: 10,
          ),
          TextBuilder.build(
              title: "Terms and Conditions",
              style: TextStyleCustom.STYLE_LABEL
                  .copyWith(color: ThemeColors.COLOR_THEME_APP))
        ],
      ),
    );
  }

  Widget paddingWidget({@required Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: child,
    );
  }

  Widget countryCodeWidget() {
    return CountryPickerCupertino();
  }

  Widget buildCountryCode() {
    return paddingWidget(
        child: Container(
      height: 50,
      child: ButtonBuilder.buttonCustom(
          context: context,
          paddingValue: 0,
          label: modelCountry.countryName,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => Theme(
                  data: Theme.of(context).copyWith(primaryColor: Colors.pink),
                  child: CountryPickerDialog(
                      titlePadding: EdgeInsets.all(8.0),
                      searchCursorColor: Colors.pinkAccent,
                      searchInputDecoration:
                          InputDecoration(hintText: 'Search...'),
                      isSearchable: true,
                      title: Text('Select your country code'),
                      onValuePicked: (Country country) {
                        // print(country.isoCode);
                        setState(() {
                          modelCountry.countryName = country.name;
                          modelCountry.countryCode = country.isoCode;
                          modelCountry.countryNumberPhoneCode =
                              country.phoneCode;
                          modelCountry.setSelectedCountry = true;
                        });
                      })),
            );
          }),
    ));
  }

  Widget buildFormFullName() {
    return paddingWidget(
      child: TextFieldBuilder.enterInformation(
          key: "CustName",
          hintText: "Full Name",
          validators: [
            FormBuilderValidators.required(errorText: "Invalide Full name")
          ]),
    );
  }

  Widget buildFormAddress() {
    return paddingWidget(
      child: TextFieldBuilder.enterInformation(
          key: "CustAddress",
          hintText: "Address",
          validators: [
            FormBuilderValidators.required(errorText: "Invalide Address")
          ]),
    );
  }

  Widget buildFormEmail() {
    return paddingWidget(
      child: TextFieldBuilder.enterInformation(
          key: "CustEmail",
          hintText: "${allTranslations.text("email")}",
          keyboardType: TextInputType.emailAddress,
          validators: [
            FormBuilderValidators.email(),
            FormBuilderValidators.pattern(pattern),
            FormBuilderValidators.required(errorText: "Invalide email address.")
          ]),
    );
  }

  Widget buildFormMobileNumber() {
    return paddingWidget(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 0.7, color: ThemeColors.COLOR_THEME_APP),
                  borderRadius: BorderRadius.circular(25)),
              height: 50,
              child: Center(
                  child: TextBuilder.build(
                      title: "+ ${modelCountry.countryNumberPhoneCode}")),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 4,
            child: TextFieldBuilder.enterInformation(
                key: "MobilePhone",
                hintText: "Mobile Number",
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validators: [
                  FormBuilderValidators.required(
                      errorText: "Invalide Mobile Number")
                ]),
          ),
        ],
      ),
    );
  }
}
