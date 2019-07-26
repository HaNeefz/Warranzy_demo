import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/models/model_claim_asset.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import 'scDetail_product_claim.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  ModelClaimProductAsset _modelClaimProductAsset = ModelClaimProductAsset();
  ModelAssetsData assetsData = ModelAssetsData();
  List<ModelAssetsData> listAssetsData = [];
  List<ModelClaimProductAsset> listClaimProductAssetData = [];

  @override
  void initState() {
    super.initState();
    listClaimProductAssetData = _modelClaimProductAsset.pushData();
    listAssetsData = assetsData.pushData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 160,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  splashColor: Colors.teal[200],
                  onTap: () {
                    ecsLib.pushPage(
                      context: context,
                      pageWidget: DetailProductClaim(
                        assetsData: listAssetsData[index],
                        productClaimData: listClaimProductAssetData[index],
                        isHistory: true,
                      ),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      buildImage(index),
                      buildProductDetailHistory(index),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Expanded buildImage(int index) {
    var listData = listClaimProductAssetData[index];
    return Expanded(
      child: Container(
        width: 130,
        height: 130,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            // border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(10.0)),
        child: Stack(children: <Widget>[
          Hero(
            tag: "thumnail_sv_$index",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: AssetImage(Assets.BACK_GROUND_APP),
                        fit: BoxFit.cover)),
                child: Image.asset(Assets.BACK_GROUND_APP, fit: BoxFit.cover),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: Colors.teal[200],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      Icons.directions_car,
                      color: COLOR_WHITE,
                    ),
                    TextBuilder.build(
                        title: "Delivery",
                        style: TextStyleCustom.STYLE_LABEL
                            .copyWith(fontSize: 14, color: COLOR_WHITE))
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Expanded buildProductDetailHistory(int index) {
    var listDataCliam = listClaimProductAssetData[index];
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextBuilder.build(
                title: listDataCliam.assetsName,
                style: TextStyleCustom.STYLE_LABEL_BOLD),
            TextBuilder.build(
                title: listDataCliam.assetsDetailData,
                style: TextStyleCustom.STYLE_CONTENT,
                textOverflow: TextOverflow.ellipsis,
                maxLine: 2),
            SizedBox(
              height: 5.0,
            ),
            TextDescriptions(
                title: "Type service", description: listDataCliam.serviceType),
            TextDescriptions(
                title: "Request Date", description: listDataCliam.requsetDate),
            TextDescriptions(
                title: "Status",
                description: "${allTranslations.text("success")} (30.05.2019)"),
          ],
        ),
      ),
    );
  }
}

class TextDescriptions extends StatelessWidget {
  final String title;
  final String description;

  const TextDescriptions({Key key, this.title, this.description})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: TextStyleCustom.STYLE_CONTENT.copyWith(fontSize: 14),
          text: "$title : ",
          children: [
            TextSpan(
                text: "$description",
                style: TextStyleCustom.STYLE_CONTENT
                    .copyWith(fontSize: 14, color: COLOR_MAJOR))
          ]),
    );
  }
}
