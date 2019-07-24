import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import 'scMoreInfoAsset.dart';

class AddImage extends StatefulWidget {
  final bool hasDataAssetAlready;

  AddImage({Key key, this.hasDataAssetAlready = false}) : super(key: key);
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  int counterImage = 0;
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();

  bool get hasDataAssetAlready => widget.hasDataAssetAlready == true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextBuilder.build(
            title: hasDataAssetAlready ? "Edit Asset" : "New Asset",
            style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            buildHeader(),
            SizedBox(
              height: 10,
            ),
            buildImage(context),
            buildButtonAddImage(context),
            buildDetailImage()
          ],
        ),
      ),
    );
  }

  Padding buildButtonAddImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ButtonBuilder.buttonCustom(
          context: context,
          label: counterImage < 10
              ? "Add Image"
              : allTranslations.text("continue"),
          paddingValue: 5,
          onPressed: () {
            setState(() {
              if (counterImage < 10)
                counterImage++;
              else {
                counterImage = 0;
                ecsLib.pushPage(
                  context: context,
                  pageWidget: AddMoreInformationAsset(
                    hasDataAssetAlready: widget.hasDataAssetAlready,
                  ),
                );
              }
            });
          }),
    );
  }

  Padding buildDetailImage() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      child: TextBuilder.build(
          title:
              "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text.",
          style: TextStyleCustom.STYLE_CONTENT),
    );
  }

  Container buildImage(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(style: BorderStyle.solid)),
      child: Center(
        child: FlutterLogo(),
      ),
    );
  }

  Row buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextBuilder.build(
            title: "Product Photo(By Customer)",
            style: TextStyleCustom.STYLE_CONTENT),
        TextBuilder.build(title: "$counterImage/10")
      ],
    );
  }
}
