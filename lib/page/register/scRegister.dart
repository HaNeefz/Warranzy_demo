import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/app_bar_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_field_builder.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  bool agree = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarThemes.appBarStyle(context: context),
      body: Container(
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _fbKey,
            autovalidate: false,
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
                space(50),
                buildFormUserID(),
                buildFormFullName(),
                buildFormAddress(),
                buildFormCountryCode(),
                buildFormEmail(),
                buildFormMobileNumber(),
                buildChackAgree(),
                space(40),
                ButtonBuilder.buttonCustom(
                    paddingValue: 20.0,
                    context: context,
                    label: allTranslations.text("continue"),
                    onPressed: () {
                      _fbKey.currentState.save();
                      if (_fbKey.currentState.validate()) {
                        print("OK");
                      }
                    }),
                space(50),
              ],
            ),
          ),
        ),
      ),
    );
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
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
      child: child,
    );
  }

  Widget buildFormUserID() {
    return paddingWidget(
      child: TextFieldBuilder.enterInformation(
          key: "userID",
          hintText: "User ID",
          validators: [
            FormBuilderValidators.required(errorText: "Invalide User ID")
          ]),
    );
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

  Widget buildFormCountryCode() {
    return paddingWidget(
      child: TextFieldBuilder.enterInformation(
          key: "countryCode",
          hintText: "Country Code",
          validators: [
            FormBuilderValidators.required(errorText: "Invalide Country Code")
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
      child: TextFieldBuilder.enterInformation(
          key: "mobileNumber",
          hintText: "Mobile Number",
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          validators: [
            FormBuilderValidators.required(errorText: "Invalide Mobile Number")
          ]),
    );
  }
}
