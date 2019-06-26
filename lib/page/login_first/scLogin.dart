import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

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
        child: Column(        
          children: <Widget>[
            Container(child: ecsLib.logoApp()),
            TextBuilder.build(
              title: "Wellome!",
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
                  print("Tap");
                }),
            SizedBox(
              height: 20.0,
            ),
            ButtonBuilder.buttonCustom(
                context: context,
                label: allTranslations.text("register"),
                colorsButton: COLOR_WHITE,
                onPressed: () {
                  print("Tap");
                }),
          ],
        ),
      ),
    );
  }
}
