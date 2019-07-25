import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/page/asset_page/add_assets_page/scShow_detail_product.dart';
import 'package:warranzy_demo/page/asset_page/detail_asset_page/scTranfer_asset.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/carouselImage.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import 'scRequest_service.dart';
import 'scTrade_asset.dart';

class DetailAsset extends StatefulWidget {
  final ModelAssetsData assetsData;
  final String heroTag;
  final bool editAble;

  const DetailAsset(
      {Key key, this.assetsData, this.heroTag, this.editAble = true})
      : super(key: key);

  @override
  _DetailAssetState createState() => _DetailAssetState();
}

class _DetailAssetState extends State<DetailAsset> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  ModelAssetsData get _assetsData => widget.assetsData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 300,
              backgroundColor: COLOR_WHITE,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: COLOR_BLACK,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: <Widget>[
                widget.editAble == true
                    ? FlatButton(
                        child: TextBuilder.build(
                            title: "Edit",
                            style: TextStyleCustom.STYLE_LABEL
                                .copyWith(color: COLOR_WHITE)),
                        onPressed: () {
                          ecsLib.pushPage(
                              context: context,
                              pageWidget: InputInformation(
                                onClickAddAssetPage: PageAction.SCAN_QR_CODE,
                                hasDataAssetAlready: true,
                              ));
                        },
                      )
                    : Container()
              ],
              flexibleSpace: CarouselWithIndicator(
                autoPlay: false,
                height: 400,
                viewportFraction: 1.0,
                items: <Widget>[
                  testImage(),
                  testImage(),
                  testImage(),
                  testImage(),
                  testImage(),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      buildHeader(context),
                      buildAssetInformation(),
                      buildProductPhotoByCustomer(),
                      buildLastAssetInformation(),
                      if (widget.editAble == true) buildButtonDelete(context)
                    ],
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Row buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextBuilder.build(
            title: _assetsData.manuFacturerName,
            style: TextStyleCustom.STYLE_TITLE),
        widget.editAble == true
            ? IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 250,
                        child: Column(
                          children: <Widget>[
                            buildModelDataOfButtonSheet(
                                icons: Icons.timeline,
                                title: "Request service",
                                onTap: () {
                                  Navigator.pop(context);
                                  ecsLib.pushPage(
                                    context: context,
                                    pageWidget: RequestService(
                                        assetName:
                                            _assetsData.manuFacturerName),
                                  );
                                }),
                            Divider(),
                            buildModelDataOfButtonSheet(
                                icons: Icons.store,
                                title: "Trade asset",
                                onTap: () {
                                  Navigator.pop(context);
                                  ecsLib.pushPage(
                                    context: context,
                                    pageWidget: TradeInformation(
                                        assetsData: _assetsData),
                                  );
                                  //TradeInformation
                                }),
                            Divider(),
                            buildModelDataOfButtonSheet(
                                icons: Icons.repeat,
                                title: "Tranfer asset",
                                onTap: () {
                                  Navigator.pop(context);
                                  ecsLib.pushPage(
                                    context: context,
                                    pageWidget: TranfersInformation(
                                        assetsData: _assetsData),
                                  );
                                  //TradeI
                                }),
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            : Container()
      ],
    );
  }

  ListTile buildModelDataOfButtonSheet(
      {IconData icons, String title, Function onTap}) {
    return ListTile(
      leading: Icon(icons),
      title: TextBuilder.build(title: title),
      onTap: onTap,
    );
  }

  Widget buildButtonDelete(BuildContext context) {
    return ButtonBuilder.buttonCustom(
        paddingValue: 5,
        context: context,
        label: allTranslations.text("delete"),
        onPressed: () async {
          await ecsLib
              .showDialogAction(
            context: context,
            title: "DELETE ASSET",
            content: "Are you sure to delete asset ?",
            textOk: allTranslations.text("ok"),
            textCancel: allTranslations.text("cancel"),
          )
              .then((response) {
            if (response == true) Navigator.pop(context);
          });
        });
  }

  Widget buildLastAssetInformation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: RichText(
        text: TextSpan(
          children: [
            textTitleWithData(
                title: "Shop for sales", data: _assetsData.shopForSales),
            textTitleWithData(
                title: "Shop Branch", data: _assetsData.brandName),
            textTitleWithData(
                title: "Shop Country", data: _assetsData.shopCountry),
            textTitleWithData(
                title: "Purchase Date", data: _assetsData.purchaseDate),
            textTitleWithData(
                title: "Warranty No", data: _assetsData.warrantyNo),
            textTitleWithData(
                title: "Warranty Expire Date",
                data: _assetsData.warrantyExpireDate),
            textTitleWithData(
                title: "Product Category", data: _assetsData.productCategory),
            textTitleWithData(
                title: "Product Group", data: _assetsData.productGroup),
            textTitleWithData(
                title: "Product Place", data: _assetsData.productPlace),
            textTitleWithData(
                title: "Product Price", data: _assetsData.productPrice),
          ],
        ),
      ),
    );
  }

  Container buildProductPhotoByCustomer() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "Purchase Information\n\n",
                  style: TextStyleCustom.STYLE_TITLE),
              TextSpan(
                  text: "Product Photo(By Customer)",
                  style: TextStyleCustom.STYLE_CONTENT),
            ]),
          ),
          Container(
            height: 300,
            child: ListView.builder(
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemExtent: 300,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: COLOR_THEME_APP,
                  ),
                  margin: EdgeInsets.fromLTRB(0, 15, 10, 10),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  RichText buildAssetInformation() {
    return RichText(
      text: TextSpan(
        style: TextStyleCustom.STYLE_CONTENT,
        children: [
          // MenuFacturerName
          TextSpan(text: _assetsData.note + "\n\n"), // Note
          TextSpan(
              text: "Product Price : " +
                  _assetsData.productPrice +
                  "\n"), // Product Price
          TextSpan(
              text: "Warranty Date : " +
                  _assetsData.warrantyExpireDate +
                  "\n\n"), // Warranty Date

          textTitleWithData(
              title: "Brand Name", data: _assetsData.brandName), // Brand Name
          textTitleWithData(
              title: "Menufacturer Name",
              data: _assetsData.manuFacturerName), // MenuFacturerName
          textTitleWithData(
              title: "Menufacturer ID", data: _assetsData.manuFacturerID),
          // MenuFacturerID
          textTitleWithData(title: "Serial No.", data: _assetsData.serialNo),
          // Serial No
          textTitleWithData(title: "Lot No.", data: _assetsData.lotNo),
          // Lot No
          textTitleWithData(title: "MFG Date", data: _assetsData.mfgDate),
          // MFG Date
          textTitleWithData(
              title: "Expire Date", data: _assetsData.expireDate + "\n"),
          // Expire Date
          textTitleWithData(
              title: "Product Detail", data: "\n" + _assetsData.productDetail),
          // Product Detail
        ],
      ),
    );
  }

  TextSpan textTitleWithData({title, data}) {
    return TextSpan(
      children: [
        TextSpan(text: title + " : ", style: TextStyleCustom.STYLE_CONTENT),
        TextSpan(
            text: data + "\n",
            style: TextStyleCustom.STYLE_CONTENT.copyWith(color: COLOR_BLACK)),
      ],
    );
  }

  Widget testImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[COLOR_BLACK.withOpacity(0.6), COLOR_TRANSPARENT],
      )),
      child: Center(
        child: FlutterLogo(
          size: 200,
          colors: COLOR_THEME_APP,
        ),
      ),
    );
  }
}
