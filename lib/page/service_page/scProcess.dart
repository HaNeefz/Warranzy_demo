import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/models/model_claim_asset.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import 'scDetail_product_claim.dart';

class ProcessPage extends StatefulWidget {
  @override
  _ProcessPageState createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
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
          margin: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: listClaimProductAssetData.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 160,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: InkWell(
                    onTap: () {
                      ecsLib.pushPage(
                        context: context,
                        pageWidget: DetailProductClaim(
                            productClaimData: listClaimProductAssetData[index],
                            assetsData: listAssetsData[index]),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        buildImage(index),
                        buildDetailService(index),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
          ),
    );
  }

  Expanded buildImage(int index) {
    var listData = listClaimProductAssetData[index];
    return Expanded(
      child: Container(
        width: 120,
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
                width: 120,
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

  Expanded buildDetailService(int index) {
    var listData = listClaimProductAssetData[index];
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextBuilder.build(
                title: listData.assetsName,
                style: TextStyleCustom.STYLE_LABEL_BOLD),
            TextBuilder.build(
                title: listData.assetsDetailData,
                style: TextStyleCustom.STYLE_CONTENT,
                textOverflow: TextOverflow.ellipsis,
                maxLine: 2),
            SizedBox(
              height: 5.0,
            ),
            TextDescriptions(
                title: "Type service", description: listData.serviceType),
            TextDescriptions(
                title: "Request Date", description: listData.requsetDate),
            TextDescriptions(title: "Status", description: listData.status),
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
