import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warranzy_demo/models/model_country_birth_year.dart';
import 'package:warranzy_demo/models/model_cust_temp_data.dart';
import 'package:warranzy_demo/page/change_device_page/scVerify_change.dart';
import 'package:warranzy_demo/services/api/api_services_user.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/app_bar_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_field_builder.dart';

class ChangeDevice extends StatefulWidget {
  @override
  _ChangeDeviceState createState() => _ChangeDeviceState();
}

class _ChangeDeviceState extends State<ChangeDevice> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  final ModelDataCountry modelCountry = ModelDataCountry();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
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
              Padding(
                padding: EdgeInsets.only(bottom: 70),
                child: TextBuilder.build(
                    title: "Change Device", style: TextStyleCustom.STYLE_TITLE),
              ),
              buildCountryCode(),
              buildFormMobileNumber(),
              buildFormPINcode(),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: ButtonBuilder.buttonCustom(
                    colorsButton: modelCountry.selectedCountry == false
                        ? ThemeColors.COLOR_WHITE
                        : null,
                    paddingValue: 30,
                    context: context,
                    label: "Send",
                    onPressed: onClickSend),
              )
            ],
          ),
        ),
      ),
    );
  }

  savePinCode() async {
    var pref = await _pref;
    pref.setString("PINcode", "${_fbKey.currentState.value['PINcode']}");
    print("Save PINcode => ${pref.getString("PINcode")}");
  }

  onClickSend() async {
    _fbKey.currentState.save();
    if (_fbKey.currentState.validate()) {
      if (modelCountry.selectedCountry == true) {
        savePinCode();
        String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
        _fbKey.currentState.value["MobilePhone"] =
            chenkNumberStartWith(_fbKey.currentState.value["MobilePhone"]);
        var masCustomersData = _fbKey.currentState.value
          ..addAll(modelCountry.toMap())
          ..addAll({"TimeZone": currentTimeZone});
        var dataCustomers = ModelMasCustomer.fromJson(masCustomersData);
        var dataSendToAPIChangeDevice = {
          "MobilePhone":
              "${dataCustomers.countryNumberPhoneCode}${dataCustomers.mobilePhone}",
          "PINcode": dataCustomers.pinCode,
          "Country": dataCustomers.countryCode,
          "TimeZone": dataCustomers.timeZone
        };
        print("Data before send => $dataSendToAPIChangeDevice");
        ecsLib.showDialogLoadingLib(
          context: context,
          content: "Verifying",
        );
        APIServiceUser.apiChangeDevice(postData: dataSendToAPIChangeDevice)
            .then((response) async {
          if (response?.status == true) {
            ecsLib.cancelDialogLoadindLib(context);
            ecsLib.pushPage(
              context: context,
              pageWidget: VerifyChangeDevice(
                modelVerifyNumber: response,
                modelMasCustomer: dataCustomers,
              ),
            );
          } else if (response?.status == false) {
            ecsLib
                .showDialogLib(
              context: context,
              title: "CAN'T FIND PHONE NUMBER",
              content: response?.message ?? "",
              textOnButton: allTranslations.text("close"),
            )
                .then((res) {
              ecsLib.cancelDialogLoadindLib(context);
            });
          } else {
            ecsLib
                .showDialogLib(
              context: context,
              title: "SERVER ERROR",
              content: response?.message,
              textOnButton: allTranslations.text("close"),
            )
                .then((res) {
              ecsLib.cancelDialogLoadindLib(context);
            });
          }
        });
      } else {
        ecsLib.showDialogLib(
          context: context,
          title: "SELECT COUNTRY",
          content: "Please select country.",
          textOnButton: allTranslations.text("close"),
        );
      }
    }
  }

  Widget buildFormPINcode() {
    return paddingWidget(
      child: TextFieldBuilder.enterInformation(
          key: "PINcode",
          hintText: "PIN Code",
          keyboardType: TextInputType.number,
          maxLength: 6,
          obsecure: true,
          validators: [
            FormBuilderValidators.required(errorText: "Invalide PIN Code")
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
                          modelCountry.selectedCountry = true;
                        });
                      })),
            );
          }),
    ));
  }

  Widget paddingWidget({@required Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: child,
    );
  }

  String chenkNumberStartWith(String numb) {
    String numbNew = numb;
    if (numbNew.startsWith(RegExp(r'0')) == true) {
      print("numberStartWith Zero is true");
      numbNew = numbNew.replaceFirst(RegExp(r'0'), '');
    }
    return numbNew;
  }
}
