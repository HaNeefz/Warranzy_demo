import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import '../scAdd_image.dart';

class ShowDetailProductAfterScanQR extends StatefulWidget {
  @override
  _ShowDetailProductAfterScanQRState createState() =>
      _ShowDetailProductAfterScanQRState();
}

class _ShowDetailProductAfterScanQRState
    extends State<ShowDetailProductAfterScanQR> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  @override
  Widget build(BuildContext context) {
    List<String> _title = [
      "Brand Name",
      "Manufacturer Name",
      "Manufacturer Product ID",
      "Serial No.",
      "Lot No.",
      "MFG Date",
      "Expire Date"
    ];
    List<String> _data = [
      "Dyson Electric",
      "Dyson V7 Trigger",
      "Dyson123456",
      "DS12345678",
      "DS000001",
      "${DateFormat("d.MM.yy").format(DateTime.now())}",
      "${DateFormat("dd.MM.yy").format(DateTime.utc(2019, 9, 12))}"
    ];
    return Scaffold(
      appBar: AppBar(
        title: TextBuilder.build(
            title: "New Asset", style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 10, top: 20),
        child: ListView(
          children: <Widget>[
            buildTitle(),
            SizedBox(
              height: 20,
            ),
            // for (var _title in title)
            //   buildInformation(title: _title, data: data[_title.]),
            buildInformation(title: "Brand Name", data: "Dyson Electric"),
            buildInformation(
                title: "Manufacturer Name", data: "Dyson V7 Trigger"),
            buildInformation(
                title: "Manufacturer Product ID", data: "Dyson123456"),
            buildInformation(title: "Serial No.", data: "DS12345678"),
            buildInformation(title: "Lot No.", data: "DS000001"),
            buildInformation(
                title: "MFG Date",
                data: DateFormat("d.MM.yy").format(DateTime.now())),
            buildInformation(
                title: "Expire Date",
                data: DateFormat("dd.MM.yy").format(DateTime.utc(2019, 9, 12))),

            buildProductImage(),
            buildDetailProduct(),
            buildContinue(context)
          ],
        ),
      ),
    );
  }

  Padding buildContinue(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
      child: ButtonBuilder.buttonCustom(
          paddingValue: 10,
          context: context,
          label: allTranslations.text("continue"),
          onPressed: () {
            print("tap");
            ecsLib.pushPage(
              context: context,
              pageWidget: AddImage(),
            );
          }),
    );
  }

  Padding buildDetailProduct() {
    return Padding(
        padding: const EdgeInsets.only(left: 15, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 10, 15),
              child: TextBuilder.build(
                  title: "Product Detail",
                  style: TextStyleCustom.STYLE_CONTENT),
            ),
            RichText(
              text: TextSpan(
                style: TextStyleCustom.STYLE_LABEL,
                children: [
                  TextSpan(
                    text:
                        "Lorem Ipsum\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s\n\nThe standard Lorem\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,\n\nExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Container buildProductImage() {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, right: 10, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextBuilder.build(
              title: "Product Image", style: TextStyleCustom.STYLE_CONTENT),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              // itemExtent: 200,
              itemBuilder: (BuildContext context, int index) => Container(
                margin: EdgeInsets.all(5),
                width: 300,
                decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(20)),
                child: Center(child: FlutterLogo()),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildInformation({String title, String data}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, bottom: 30),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: "$title\n",
            style: TextStyleCustom.STYLE_CONTENT,
          ),
          TextSpan(
              text: data,
              style: TextStyleCustom.STYLE_TITLE.copyWith(fontSize: 25)),
        ]),
      ),
    );
  }

  RichText buildTitle() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Product Detail\n",
            style: TextStyleCustom.STYLE_TITLE.copyWith(color: COLOR_THEME_APP),
          ),
          TextSpan(
              text:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, ",
              style: TextStyleCustom.STYLE_CONTENT),
        ],
      ),
    );
  }
}
