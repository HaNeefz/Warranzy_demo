import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_cupertino.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warranzy_demo/models/model_country_birth_year.dart';
import 'package:warranzy_demo/page/pin_code/scPinCode.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/app_bar_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_field_builder.dart';
import 'package:device_info/device_info.dart';

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
  SharedPreferences _pref;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
  }

  getDeviceInfo() async {
    _pref = await SharedPreferences.getInstance();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.androidId}');
      _pref.setString("DeviceID", androidInfo.androidId);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print(iosInfo.identifierForVendor);
      _pref.setString("DeviceID", iosInfo.identifierForVendor);
      print('DeviceID : ${_pref.getString("DeviceID")}');
    } else {
      print("Another");
    }
  }

  bool agree = false;
  @override
  Widget build(BuildContext context) {
    // Locale myLocale = Localizations.localeOf(context);
    // print(myLocale);
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
                  onPressed: agree == true
                      ? () {
                          _fbKey.currentState.save();
                          if (_fbKey.currentState.validate()) {
                            if (checkSelectCountryAndBirthYear(context)) {
                              var deviceID = {
                                "deviceID": _pref.getString("DeviceID")
                              };
                              _fbKey.currentState.value["mobileNumber"] =
                                  chenkNumberStartWith(_fbKey
                                      .currentState.value["mobileNumber"]);
                              var data = _fbKey.currentState.value
                                ..addAll(modelCountry.toMap())
                                ..addAll(modelBirthYear.toMap())
                                ..addAll(deviceID);
                              print(data);
                              // ecsLib.pushPage(
                              //   context: context,
                              //   pageWidget: PinCodePageUpdate(
                              //     type: PageType.setPin,
                              //   ),
                              // );
                            }
                          }
                        }
                      : null),
              space(50),
            ],
          ),
        ),
      ),
    );
  }

  String chenkNumberStartWith(String numb) {
    String numbNew = numb;
    if (numbNew.startsWith("0")) {
      print("numberStartWith Zero is true");
      numbNew = numbNew.replaceFirst(RegExp(r'0'), '');
    }
    return numbNew;
  }

  Container buildBirthYear(BuildContext context) {
    return Container(
      child: paddingWidget(
          child: ButtonBuilder.buttonCustom(
              colorsButton: COLOR_TRANSPARENT,
              labelStyle:
                  TextStyleCustom.STYLE_LABEL_BOLD.copyWith(color: COLOR_GREY),
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
                      print(value.toString());
                      print(picker.getSelectedValues());
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
    else if (modelBirthYear.selectedBirthYear == false)
      ecsLib.showDialogLib(
        context: context,
        title: "SELECT BIRTH YEAR",
        content: "Please select birth year.",
        textOnButton: allTranslations.text("close"),
      );
    else
      print("unknow error");
    return dataCorrect;
  }

  Widget buildFormGender() {
    return paddingWidget(
        child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(width: 0.7, color: COLOR_GREY),
          borderRadius: BorderRadius.circular(25)),
      child: FormBuilderRadio(
        attribute: "Gender",
        leadingInput: true,
        validators: [FormBuilderValidators.required()],
        decoration: InputDecoration(
            labelText: "Gender",
            labelStyle: TextStyleCustom.STYLE_CONTENT.copyWith(fontSize: 20)),
        options: ["Male", "Female"]
            .map((gender) => FormBuilderFieldOption(value: gender))
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
              style:
                  TextStyleCustom.STYLE_LABEL.copyWith(color: COLOR_THEME_APP))
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
                      title: Text('Select your phone code'),
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
          key: "fullName",
          hintText: "Full Name",
          validators: [
            FormBuilderValidators.required(errorText: "Invalide Full name")
          ]),
    );
  }

  Widget buildFormAddress() {
    return paddingWidget(
      child: TextFieldBuilder.enterInformation(
          key: "address",
          hintText: "Address",
          validators: [
            FormBuilderValidators.required(errorText: "Invalide Address")
          ]),
    );
  }

  Widget buildFormEmail() {
    return paddingWidget(
      child: TextFieldBuilder.enterInformation(
          key: "email",
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
                  border: Border.all(width: 0.7, color: COLOR_THEME_APP),
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
                key: "mobileNumber",
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
