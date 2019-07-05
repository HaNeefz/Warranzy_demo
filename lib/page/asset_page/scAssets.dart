import 'package:flutter/material.dart';
import 'package:warranzy_demo/page/profile_page/scProfile.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/method/scan_qr.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import 'detail_asset_page/scDetailAsset.dart';

class AssetPage extends StatefulWidget {
  @override
  _AssetPageState createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  List<ModelAssetData> modelAsset = List<ModelAssetData>();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 10; i++) {
      modelAsset.add(ModelAssetData(
          id: i,
          title: "Dyson V7 Trigger",
          content:
              "Simply dummy text of the printing and typeseting industy asduasdljb u iuabsldkj ",
          expire: "Warranty Date : 24.05.2019 - 24.05.2020",
          category: "Category",
          image: null));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          buildHeaderAndProfile(),
          buildAds(),
          buildLabelAndSeeAll(),
          buildYourAssets()
        ],
      ),
    );
  }

  Column buildYourAssets() {
    return Column(
      children: Iterable.generate(modelAsset.length, (index) {
        return ModelAssetWidget(modelAsset[index]);
      }).toList(),
    );
  }

  Row buildLabelAndSeeAll() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: TextBuilder.build(
              title: "Your Asset", style: TextStyleCustom.STYLE_TITLE),
        )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextBuilder.build(
                  title: "See All", style: TextStyleCustom.STYLE_CONTENT),
              SizedBox(
                width: 10.0,
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2,
                      color: COLOR_THEME_APP,
                    )),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                    color: COLOR_THEME_APP,
                  ),
                ),
              )
            ],
          ),
        )),
      ],
    );
  }

  Container buildAds() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        // color: Colors.red
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
              width: MediaQuery.of(context).size.width - 50,
              height: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 5),
                      blurRadius: 8.0,
                      spreadRadius: 2.0,
                      color: COLOR_GREY,
                    )
                  ]),
            ),
          );
        },
      ),
    );
  }

  Widget buildHeaderAndProfile() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextBuilder.build(title: "Wed, 24 May"),
                TextBuilder.build(
                    title: "Hello, Username",
                    style:
                        TextStyleCustom.STYLE_TITLE.copyWith(color: COLOR_GREY))
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                ecsLib.pushPage(
                  context: context,
                  pageWidget: ProfilePage(
                    heroTag: "PhotoProfile",
                  ),
                );
              },
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 3, color: COLOR_THEME_APP)),
                child: Center(
                  child: Hero(
                    child: FlutterLogo(
                      colors: COLOR_THEME_APP,
                    ),
                    tag: "PhotoProfile",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ModelAssetData {
  final int id;
  final String title;
  final String content;
  final String expire;
  final String category;
  final Widget image;

  ModelAssetData(
      {this.id,
      this.title,
      this.content,
      this.expire,
      this.category,
      this.image});
}

class ModelAssetWidget extends StatelessWidget {
  final assetData;
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
                  id: assetData.id,
                  title: assetData.title,
                  content: assetData.content,
                  expire: assetData.expire,
                  category: assetData.category,
                  image: null,
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
                                  colors: COLOR_THEME_APP,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextBuilder.build(
                          //------------------Title------------
                          title: assetData.title ?? "Dyson V7 Trigger",
                          style: TextStyleCustom.STYLE_LABEL_BOLD),
                      TextBuilder.build(
                          //------------------detail------------
                          title: assetData.content ??
                              "Simply dummy text of the printing and typeseting industy ...",
                          style: TextStyleCustom.STYLE_CONTENT
                              .copyWith(fontSize: 14, letterSpacing: 0)),
                      Padding(
                        //------------------Expire------------
                        padding: const EdgeInsets.only(top: 8),
                        child: TextBuilder.build(
                            title: assetData.expire ??
                                "Warranty Date : 24.05.2019 - 24.05.2020",
                            style: TextStyleCustom.STYLE_CONTENT
                                .copyWith(fontSize: 12, letterSpacing: 0)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(
                          //------------------Categotry------------
                          width: 80,
                          height: 30,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: COLOR_GREY.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15.0)),
                          key: Key("Category"),
                          child: Center(
                            child: TextBuilder.build(
                                title: assetData.category ?? "Category",
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
