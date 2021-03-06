import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import 'scMy_trade.dart';
import 'scSearch_trade.dart';
import 'scTrade_detail.dart';

class TradePage extends StatefulWidget {
  const TradePage({Key key}) : super(key: key);
  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  int _currentPage = 0;
  ModelAssetsData _assetsData = ModelAssetsData();
  List<ModelAssetsData> listDataAsset = [];

  @override
  void initState() {
    super.initState();
    listDataAsset = _assetsData.pushData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 10,
      initialIndex: _currentPage,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            height: 100,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              ThemeColors.COLOR_THEME_APP,
              ThemeColors.COLOR_WHITE
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          centerTitle: true,
          backgroundColor: ThemeColors.COLOR_WHITE,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: IconButton(
              icon: Icon(
                Icons.account_balance_wallet,
                color: ThemeColors.COLOR_THEME_APP,
                size: 40,
              ),
              onPressed: () {
                ecsLib.pushPage(
                  context: context,
                  pageWidget: MyTrade(),
                );
              },
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  size: 40,
                  color: ThemeColors.COLOR_THEME_APP,
                ),
                onPressed: () {
                  ecsLib.pushPage(
                    context: context,
                    pageWidget: SearchTrade(),
                  );
                },
              ),
            )
          ],
          title: TextBuilder.build(
              title: "Trade Market",
              style: TextStyleCustom.STYLE_APPBAR
                  .copyWith(color: ThemeColors.COLOR_BLACK)),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: ThemeColors.COLOR_THEME_APP,
            onTap: (i) {
              setState(() {
                _currentPage = i;
              });
            },
            labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            tabs: <Widget>[
              TextBuilder.build(
                  title: "Popular",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Electronics",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Tablet",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Cleaning",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Kitchen",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Others",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Tablet",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Cleaning",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Kitchen",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Others",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
            ],
          ),
        ),
        body: Container(
          child: TabBarView(
            children: <Widget>[
              Scaffold(
                backgroundColor: ThemeColors.COLOR_GREY.withOpacity(0.3),
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    itemCount: listDataAsset.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 6 / 9),
                    itemBuilder: (BuildContext context, int index) {
                      var data = listDataAsset[index];
                      return ModelTradeWidget(
                        id: index,
                        image: Image.asset(
                          Assets.BACK_GROUND_APP,
                          fit: BoxFit.cover,
                        ),
                        price: data.productPrice,
                        title: data.manuFacturerName,
                        subTitle: data.productDetail,
                        category: data.productCategory,
                        onPressed: () {
                          ecsLib.pushPage(
                            context: context,
                            pageWidget: TradeDetail(
                              assetsData: data,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              TextBuilder.build(
                  title: "Electronics",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Tablet",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Cleaning",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Electronics",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Tablet",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Cleaning",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Electronics",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Tablet",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Cleaning",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class ModelTradeWidget extends StatelessWidget {
  final Widget image;
  final int id;
  final String price;
  final String title;
  final String subTitle;
  final String category;
  final Function onPressed;

  const ModelTradeWidget(
      {Key key,
      this.image,
      this.price,
      this.title,
      this.subTitle,
      this.category,
      this.id,
      this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.COLOR_WHITE,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(),
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
                    child: Hero(
                      child: image,
                      tag: "Image$id",
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextBuilder.build(
                      title: price, style: TextStyleCustom.STYLE_CONTENT),
                  TextBuilder.build(
                      title: title, style: TextStyleCustom.STYLE_LABEL_BOLD),
                  TextBuilder.build(
                      title: subTitle,
                      style:
                          TextStyleCustom.STYLE_CONTENT.copyWith(fontSize: 14),
                      textOverflow: TextOverflow.ellipsis,
                      maxLine: 2),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    // padding: EdgeInsets.only(top: 10.0),
                    width: 100,
                    height: 25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ThemeColors.COLOR_GREY.withOpacity(0.3)),
                    child: Center(
                      child: TextBuilder.build(
                          title: category,
                          style: TextStyleCustom.STYLE_LABEL
                              .copyWith(fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
