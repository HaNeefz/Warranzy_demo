import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class TradeInformation extends StatefulWidget {
  final ModelAssetsData assetsData;
  final bool editAble;

  const TradeInformation({Key key, this.assetsData, this.editAble = false})
      : super(key: key);
  @override
  _TradeInformationState createState() => _TradeInformationState();
}

class _TradeInformationState extends State<TradeInformation> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  ModelAssetsData get assetData => widget.assetsData;
  String valueCategory = "Cleaning";
  int counterPhotos = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextBuilder.build(
            title: widget.editAble ? "Edit trade asset" : "Add trade asset",
            style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: ecsLib.dismissedKeyboard(
        context,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: ListView(
            children: <Widget>[
              TextBuilder.build(
                  title: "Trade Information",
                  style: TextStyleCustom.STYLE_TITLE
                      .copyWith(color: ThemeColors.COLOR_THEME_APP)),
              buildInformationAsset(),
              buildAddPhotos(context),
              buildDetailReadMore(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ButtonBuilder.buttonCustom(
                    context: context,
                    label: "Publish",
                    paddingValue: 0,
                    onPressed: () {
                      widget.editAble
                          ? ecsLib
                              .showDialogLib(
                                  context: context,
                                  title: "EDIT TRADE",
                                  content: "Edit Trade Success!",
                                  textOnButton: allTranslations.text("success"))
                              .then((response) {
                              if (response) Navigator.pop(context);
                            })
                          : ecsLib
                              .showDialogLib(
                                  context: context,
                                  title: "ADD TRADE",
                                  content: "Add Trade Success!",
                                  textOnButton: allTranslations.text("success"))
                              .then((response) {
                              if (response) Navigator.pop(context);
                            });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding buildDetailReadMore() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 10, top: 20),
      child: TextBuilder.build(
          title:
              "When publish to market, you confirm that this item is in accordance with the trade policy. And all relevant laws."),
    );
  }

  Container buildAddPhotos(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 10, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextBuilder.build(
                  title: "Product Photo (By Customer)",
                  style: TextStyleCustom.STYLE_CONTENT),
              TextBuilder.build(title: "$counterPhotos/10")
            ],
          ),
          Container(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemExtent: 200,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(right: 10, top: 10),
                  decoration: BoxDecoration(
                      color: ThemeColors.COLOR_THEME_APP,
                      borderRadius: BorderRadius.circular(20)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ButtonBuilder.buttonCustom(
                context: context,
                label: counterPhotos < 10 ? "Add Photos" : "Limit Photos",
                paddingValue: 0,
                onPressed: () {
                  setState(() {
                    if (counterPhotos < 10) counterPhotos++;
                  });
                }),
          ),
        ],
      ),
    );
  }

  Container buildInformationAsset() {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 10, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            formData(title: "Your Asset", data: assetData.manuFacturerName),
            formWidget(
                title: "Title Trade",
                child: TextField(
                  // maxLines: 3,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          "${assetData.manuFacturerName} มือสอง การใช้งาน 3 เดือน"),
                )),
            formData(title: "Price", data: assetData.productPrice),
            formData(title: "Location", data: assetData.productPlace),
            formData(title: "Location", data: assetData.productPlace),
            formWidget(
                title: "Category",
                child: DropdownButton(
                  isExpanded: true,
                  value: valueCategory,
                  items: ["Cleaning"].map((data) {
                    return DropdownMenuItem(
                      value: data,
                      child: TextBuilder.build(title: data),
                    );
                  }).toList(),
                  onChanged: (value) {},
                )),
            formWidget(
                title: "Explan about your asset",
                child: TextField(
                  decoration: InputDecoration(border: InputBorder.none),
                )),
          ],
        ));
  }

  Widget formData({String title, String data}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 0.3, color: ThemeColors.COLOR_GREY),
          borderRadius: BorderRadius.circular(5)),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "$title\n", style: TextStyleCustom.STYLE_CONTENT),
            TextSpan(text: "$data\n", style: TextStyleCustom.STYLE_LABEL),
          ],
        ),
      ),
    );
  }

  Widget formWidget({String title, Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(width: 0.3, color: ThemeColors.COLOR_GREY),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextBuilder.build(title: title, style: TextStyleCustom.STYLE_CONTENT),
          child
        ],
      ),
    );
  }
}
