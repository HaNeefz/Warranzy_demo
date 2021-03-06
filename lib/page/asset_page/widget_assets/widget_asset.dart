import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/page/asset_page/detail_asset_page/scDetailAsset.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class ModelAssetWidget extends StatelessWidget {
  final ModelAssetsData assetData;
  final ecsLib = getIt.get<ECSLib>();
  ModelAssetWidget(this.assetData);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          splashColor: Colors.teal[200],
          onTap: () {
            ecsLib.pushPage(
                context: context,
                pageWidget: DetailAsset(
                  heroTag: "thumbnail_${assetData.id}",
                ));
          },
          child: Row(
            children: <Widget>[
              Expanded(
                //------------------Image------------
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  width: 100.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                      child: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: 100.0,
                          height: 150,
                          child: Hero(
                            tag: "thumbnail_${assetData.id}",
                            child: assetData.image ??
                                FlutterLogo(
                                  colors: ThemeColors.COLOR_THEME_APP,
                                ),
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
              ),
              Expanded(
                //------------------Detail------------
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextBuilder.build(
                          //------------------Title------------
                          title: assetData.manuFacturerName ?? "null",
                          style: TextStyleCustom.STYLE_LABEL_BOLD),
                      TextBuilder.build(
                          //------------------detail------------
                          title: assetData.productDetail ?? "null",
                          style: TextStyleCustom.STYLE_CONTENT.copyWith(
                            fontSize: 14,
                          ),
                          maxLine: 2,
                          textOverflow: TextOverflow.ellipsis),
                      Padding(
                        //------------------Expire------------
                        padding: const EdgeInsets.only(top: 8),
                        child: TextBuilder.build(
                            title: "Expire Date : " + assetData.expireDate ??
                                "null",
                            style: TextStyleCustom.STYLE_CONTENT
                                .copyWith(fontSize: 12, letterSpacing: 0),
                            textOverflow: TextOverflow.ellipsis,
                            maxLine: 2),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          //------------------Categotry------------
                          width: 80,
                          height: 30,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: ThemeColors.COLOR_GREY.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15.0)),
                          key: Key("Category"),
                          child: Center(
                            child: TextBuilder.build(
                                title: assetData.productCategory ?? "Category",
                                style: TextStyleCustom.STYLE_LABEL
                                    .copyWith(letterSpacing: 0)
                                    .copyWith(fontSize: 12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
