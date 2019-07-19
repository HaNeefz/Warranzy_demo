import 'package:flutter/material.dart';
import 'package:warranzy_demo/page/asset_page/scAssets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import 'widget_assets/widget_asset.dart';

class AssetsAll extends StatefulWidget {
  final List<ModelAssetData> listData;

  const AssetsAll({Key key, this.listData}) : super(key: key);
  @override
  _AssetsAllState createState() => _AssetsAllState();
}

class _AssetsAllState extends State<AssetsAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextBuilder.build(
            title: "All Assets", style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: Container(
          child: ListView.separated(
        itemCount: widget.listData.length,
        itemBuilder: (BuildContext context, int index) {
          return ModelAssetWidget(widget.listData[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      )),
    );
  }
}
