import 'package:flutter/material.dart';
import 'package:warranzy_demo/page/pin_code/scPinCode.dart';
import 'package:warranzy_demo/page/pin_code/scPin_code.dart';
import 'package:warranzy_demo/tools/const.dart';
import '../../page/register/scRegister.dart';
import '../../tools/config/text_style.dart';
import '../../tools/export_lib.dart';
import '../../tools/theme_color.dart';
import '../../tools/widget_ui_custom/button_builder.dart';
import '../../tools/widget_ui_custom/text_builder.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(child: ecsLib.logoApp()),
              TextBuilder.build(
                title: "Wellcome!",
                style: TextStyleCustom.STYLE_APPBAR
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              TextBuilder.build(
                title: "Sign into your Account",
                style: TextStyleCustom.STYLE_CONTENT,
              ),
              SizedBox(
                height: 100.0,
              ),
              ButtonBuilder.buttonCustom(
                  context: context,
                  label: allTranslations.text("login"),
                  onPressed: () {
                    ecsLib.pushPage(
                      context: context,
                      pageWidget: PinCodePageUpdate(
                        type: PageType.login,
                        usedPin: false,
                      ),
                    );
                  }),
              SizedBox(
                height: 20.0,
              ),
              ButtonBuilder.buttonCustom(
                  context: context,
                  label: allTranslations.text("register"),
                  colorsButton: COLOR_WHITE,
                  onPressed: () {
                    ecsLib.pushPage(
                      context: context,
                      pageWidget: Register(),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
