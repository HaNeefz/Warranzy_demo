import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class TradeContact extends StatefulWidget {
  @override
  _TradeContactState createState() => _TradeContactState();
}

class _TradeContactState extends State<TradeContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextBuilder.build(
            title: "Trade Contact", style: TextStyleCustom.STYLE_APPBAR),
        actions: <Widget>[
          FlatButton(
            child: TextBuilder.build(
                title: "Save",
                style:
                    TextStyleCustom.STYLE_LABEL.copyWith(color: COLOR_WHITE)),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: ListView(
          children: <Widget>[
            TextBuilder.build(
                title: "Contact information",
                style: TextStyleCustom.STYLE_TITLE
                    .copyWith(color: COLOR_THEME_APP)),
            SizedBox(
              height: 20,
            ),
            formInformation(title: "Number for trade", data: "Sandy Kim"),
            formInformation(title: "UserID", data: "WR867145"),
            formInformation(title: "Email", data: "sandy@gmail.com"),
            formInformation(title: "Mobile No.", data: "082-123-1234"),
          ],
        ),
      ),
    );
  }

  Widget formInformation({title, data}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 0.3, color: COLOR_GREY)),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: title + "\n", style: TextStyleCustom.STYLE_CONTENT),
            TextSpan(text: data, style: TextStyleCustom.STYLE_LABEL),
          ],
        ),
      ),
    );
  }
}
