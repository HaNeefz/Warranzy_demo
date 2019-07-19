import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warranzy_demo/page/profile_page/scProfile.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import 'detail_asset_page/scDetailAsset.dart';
import 'scAssetsAll.dart';
import 'widget_assets/widget_asset.dart';

class AssetPage extends StatefulWidget {
  @override
  _AssetPageState createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  ModelAssetData assetData = ModelAssetData();
  List<ModelAssetData> listAssetData;

  @override
  void initState() {
    super.initState();
    listAssetData = assetData.pushData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          buildHeaderAndProfile(),
          CarouselWithIndicator(),
          buildLabelAndSeeAll(),
          buildYourAssets()
        ],
      ),
    );
  }

  Column buildYourAssets() {
    return Column(
      children: listAssetData.map((i) {
        if (i.id < 6)
          return ModelAssetWidget(i);
        else
          return Container();
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
          child: GestureDetector(
            onTap: () => ecsLib.pushPage(
                context: context,
                pageWidget: AssetsAll(
                  listData: listAssetData,
                )),
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
          ),
        )),
      ],
    );
  }

  Widget buildHeaderAndProfile() {
    var dateTime = DateTime.now();
    String date = DateFormat('EEEE, d MMMM').format(dateTime);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextBuilder.build(
                    title: date, style: TextStyleCustom.STYLE_LABEL_BOLD),
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

  List<ModelAssetData> listModelData = [];
  List<ModelAssetData> pushData() {
    for (var i = 0; i < 10; i++) {
      listModelData.add(ModelAssetData(
          id: i,
          title: "Dyson V7 Trigger",
          content:
              "Simply dummy text of the printing and typeseting industy asduasdljb u iuabsldkj ",
          expire: "Warranty Date : 24.05.2019 - 24.05.2020",
          category: "Category",
          image: null));
    }
    return listModelData;
  }
}

class CarouselWithIndicator extends StatefulWidget {
  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CarouselSlider(
        items: [1, 2, 3, 4, 5].map((i) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            decoration: BoxDecoration(
                color: COLOR_THEME_APP,
                borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: TextBuilder.build(
                  title: "$i",
                  style:
                      TextStyleCustom.STYLE_LABEL.copyWith(color: COLOR_WHITE)),
            ),
          );
        }).toList(),
        autoPlay: true,
        aspectRatio: 2.0,
        viewportFraction: 0.9,
        enlargeCenterPage: true,
        height: 100,
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
      ),
      Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: Iterable.generate(5, (index) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4)),
              );
            }).toList(),
          ))
    ]);
  }
}
