import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/page/asset_page/scAssets.dart';
import 'package:warranzy_demo/page/asset_page/widget_assets/widget_asset.dart';
import 'package:warranzy_demo/services/method/scan_qr.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import 'add_assets_page/scShow_detail_product.dart';

class AssetsAll extends StatefulWidget {
  final List<ModelAssetsData> listData;

  const AssetsAll({Key key, this.listData}) : super(key: key);
  @override
  _AssetsAllState createState() => _AssetsAllState();
}

class _AssetsAllState extends State<AssetsAll> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: TextBuilder.build(
            title: "All Assets", style: TextStyleCustom.STYLE_APPBAR),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.playlist_add,
              size: 35,
            ),
            onPressed: () {
              buildShowModalBottomSheet(context);
            },
          )
        ],
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

  Future buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        height: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(Assets.ICON_SCANNER),
              ),
              title: TextBuilder.build(title: "Scan QR Code"),
              onTap: () async {
                var res = await MethodLib.scanQR(context);
                print("Scan QR Code");
                if (res.isNotEmpty) Navigator.pop(context);
                ecsLib.pushPage(
                  context: context,
                  pageWidget: InputInformation(
                    page: PageAction.SCAN_QR_CODE,
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.playlist_add,
                color: COLOR_BLACK,
                size: 35,
              ),
              title: TextBuilder.build(title: "Manaul Add Asset"),
              onTap: () {
                print("Manual Add Asset");
                Navigator.pop(context);
                ecsLib.pushPage(
                  context: context,
                  pageWidget: InputInformation(
                    page: PageAction.MANUAL_ADD,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
