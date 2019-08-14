import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import 'scAdd_image.dart';

class FillInformation extends StatefulWidget {
  final PageAction onClickAddAssetPage;
  final bool hasDataAssetAlready;

  FillInformation(
      {Key key, this.onClickAddAssetPage, this.hasDataAssetAlready = false})
      : super(key: key);
  @override
  _FillInformationState createState() => _FillInformationState();
}

class _FillInformationState extends State<FillInformation> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  var valueBrandName = "DysonElectric";
  List<String> _dataBrandNameDD = [
    "Dyson Electric",
    "Dyson Phone",
    "Doyson TV"
  ];
  var valueMenufacturer = "Dyson V7 Trigger";
  List<String> _dataMenufacturerDD = [
    "Dyson V7 Trigger",
    "Dyson V6 Trigger",
    "Dyson V5 Trigger"
  ];

  PageAction get page => widget.onClickAddAssetPage;
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
        centerTitle: true,
        title: TextBuilder.build(
            title:
                widget.hasDataAssetAlready == true ? "Edit Asset" : "New Asset",
            style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 10, top: 20),
        child: ListView(
          children: <Widget>[
            buildTitle(),
            SizedBox(
              height: 20,
            ),
            if (page == PageAction.SCAN_QR_CODE)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildInformation(title: "Brand Name", data: "Dyson Electric"),
                  buildInformation(
                      title: "Manufacturer Name", data: "Dyson V7 Trigger"),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildInformation(
                      title: "Brand Name Change is ", data: "Dyson Electric"),
                  buildInformation(
                      title: "Manufacturer Name", data: "Dyson V7 Trigger"),
                ],
              ),
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
            if (page == PageAction.SCAN_QR_CODE)
              Column(
                children: <Widget>[
                  buildProductImage(),
                  buildDetailProduct(),
                ],
              ),
            buildContinue(context)
          ],
        ),
      ),
    );
  }

  Widget buildBrandAndMenufacturer() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(width: 0.3, color: ThemeColors.COLOR_GREY),
              borderRadius: BorderRadius.circular(5)),
          child: DropdownButton<String>(
            isExpanded: true,
            value: valueBrandName,
            items: ["Dyson Electric", "Dyson Phone", "Doyson TV"]
                .map<DropdownMenuItem<String>>((data) {
              return DropdownMenuItem<String>(
                value: data,
                child: TextBuilder.build(title: data),
              );
            }).toList(),
            onChanged: (value) {
              valueBrandName = value;
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(width: 0.3, color: ThemeColors.COLOR_GREY),
              borderRadius: BorderRadius.circular(5)),
          child: DropdownButton<String>(
            isExpanded: true,
            value: valueMenufacturer,
            items: ["Dyson V7 Trigger", "Dyson V6 Trigger", "Dyson V5 Trigger"]
                .map<DropdownMenuItem<String>>((data) {
              return DropdownMenuItem<String>(
                value: data,
                child: TextBuilder.build(title: data),
              );
            }).toList(),
            onChanged: (value) {
              valueMenufacturer = value;
            },
          ),
        ),
      ],
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
              pageWidget: AddImage(
                hasDataAssetAlready: widget.hasDataAssetAlready,
              ),
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
            style: TextStyleCustom.STYLE_TITLE
                .copyWith(color: ThemeColors.COLOR_THEME_APP),
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
