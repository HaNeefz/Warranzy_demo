import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class AddMoreInformationAsset extends StatefulWidget {
  @override
  _AddMoreInformationAssetState createState() =>
      _AddMoreInformationAssetState();
}

class _AddMoreInformationAssetState extends State<AddMoreInformationAsset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextBuilder.build(
            title: "New Asset", style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
        child: ListView(
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "Add more information\n",
                      style: TextStyleCustom.STYLE_TITLE
                          .copyWith(color: COLOR_THEME_APP)),
                  TextSpan(
                      text:
                          "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.",
                      style: TextStyleCustom.STYLE_CONTENT),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
