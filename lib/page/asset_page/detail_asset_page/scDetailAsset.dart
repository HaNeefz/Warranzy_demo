import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/page/asset_page/add_assets_page/scFillInformation.dart';
import 'package:warranzy_demo/page/asset_page/detail_asset_page/scTranfer_asset.dart';
import 'package:warranzy_demo/page/main_page/scMain_page.dart';
import 'package:warranzy_demo/services/api/api_service_assets.dart';
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
  final ModelDataAsset dataAsset;

  const DetailAsset(
      {Key key,
      this.assetsData,
      this.heroTag,
      this.editAble = true,
      this.dataAsset})
      : super(key: key);

  @override
  _DetailAssetState createState() => _DetailAssetState();
}

class _DetailAssetState extends State<DetailAsset> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  ModelDataAsset get _data => widget.dataAsset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              centerTitle: true,
              expandedHeight: 300,
              backgroundColor: ThemeColors.COLOR_WHITE,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: ThemeColors.COLOR_BLACK,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: <Widget>[
                widget.editAble == true
                    ? FlatButton(
                        child: TextBuilder.build(
                            title: "Edit",
                            style: TextStyleCustom.STYLE_LABEL
                                .copyWith(color: ThemeColors.COLOR_WHITE)),
                        onPressed: () {
                          ecsLib.pushPage(
                              context: context,
                              pageWidget: FillInformation(
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
                      checkTypeAsset(_data.createType),
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

  Widget checkTypeAsset(String typeAsset) {
    Widget child = Container();
    switch (typeAsset) {
      case "C":
        return Column(
          children: <Widget>[
            buildProductPhotoByCustomer(),
            buildLastAssetInformation(),
          ],
        );
        break;
      case "T":
        return Column(
          children: <Widget>[
            buildHeader(context),
            buildAssetInformation(),
            buildProductPhotoByCustomer(),
            buildLastAssetInformation()
          ],
        );
        break;
      default:
        return child;
    }
  }

  Row buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextBuilder.build(
            title: "MenuFacturer", style: TextStyleCustom.STYLE_TITLE),
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
                                  // ecsLib.cancelDialogLoadindLib(context);
                                  // ecsLib.pushPage(
                                  //   context: context,
                                  //   pageWidget: RequestService(
                                  //       assetName:
                                  //           _assetsData.manuFacturerName),
                                  // );
                                }),
                            Divider(),
                            buildModelDataOfButtonSheet(
                                icons: Icons.store,
                                title: "Trade asset",
                                onTap: () {
                                  // ecsLib.cancelDialogLoadindLib(context);
                                  // ecsLib.pushPage(
                                  //   context: context,
                                  //   pageWidget: TradeInformation(
                                  //       assetsData: _assetsData),
                                  // );
                                  //TradeInformation
                                }),
                            Divider(),
                            buildModelDataOfButtonSheet(
                                icons: Icons.repeat,
                                title: "Tranfer asset",
                                onTap: () {
                                  // ecsLib.cancelDialogLoadindLib(context);
                                  // ecsLib.pushPage(
                                  //   context: context,
                                  //   pageWidget: TranfersInformation(
                                  //       assetsData: _assetsData),
                                  // );
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
              .then((response) async {
            if (response == true) {
              try {
                ecsLib.showDialogLoadingLib(context);
                await APIServiceAssets.deleteAseet(_data.wTokenID)
                    .then((res) async {
                  ecsLib.cancelDialogLoadindLib(context);
                  if (res?.status == true) {
                    print("Data => ${res.data}");
                    ecsLib.pushPageAndClearAllScene(
                      context: context,
                      pageWidget: MainPage(),
                    );
                  } else if (res.status == false) {
                    print("status == false");
                  } else {
                    print("something wrong");
                  }
                });
              } catch (e) {
                print("catch => $e");
              }
            }
          });
        });
  }

  Future deleteAsset() async {
    try {} on SocketException catch (e) {} on DioError catch (e) {} catch (e) {}
  }

  Widget buildLastAssetInformation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: RichText(
        text: TextSpan(
          children: [
            // textTitleWithData(
            //     title: "Shop for sales", data: "_assetsData.shopForSales"),
            // textTitleWithData(
            //     title: "Shop Branch", data: "_assetsData.brandName"),
            // textTitleWithData(
            //     title: "Shop Country", data: "_assetsData.shopCountry"),
            // textTitleWithData(
            //     title: "Purchase Date", data: "_assetsData.purchaseDate"),

            textTitleWithData(
                title: "Warranty No",
                data: _data.warrantyNo ?? "_assetsData.warrantyNo"),
            textTitleWithData(
                title: "Warranty Expire Date",
                data: _data.warrantyExpire ?? "_assetsData.warrantyExpireDate"),
            textTitleWithData(
                title: "Product Category",
                data: _data.pdtCatCode ?? "_assetsData.productCategory"),
            textTitleWithData(
                title: "Product Group",
                data: _data.pdtGroup ?? "_assetsData.productGroup"),
            textTitleWithData(
                title: "Product Place",
                data: _data.pdtPlace ?? "_assetsData.productPlace"),
            // textTitleWithData(
            //     title: "Product Price",
            //     data: _data.salesPrice ?? "_assetsData.productPrice"),
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
                    color: ThemeColors.COLOR_THEME_APP,
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
          TextSpan(
              text:
                  _data.custRemark ?? "_assetsData?.note ??" + "\n\n"), // Note
          TextSpan(
              text:
                  "Product Price : ${_data.salesPrice ?? "_assetsData?.productPrice ??"}" +
                      "\n"), // Product Price
          TextSpan(
              text: "Warranty Date : " +
                  "${_data.warrantyExpire + '\n' ?? "_assetsData?.warrantyExpireDate ??\n\n"}"), // Warranty Date

          textTitleWithData(
              title: "Brand Name",
              data: _data.brandCode ??
                  "_assetsData?.brandName ??" ""), // Brand Name
          textTitleWithData(
              title: "Menufacturer Name",
              data: "_assetsData?.manuFacturerName ??" ""), // MenuFacturerName
          textTitleWithData(
              title: "Menufacturer ID",
              data: "_assetsData?.manuFacturerID ??" ""),
          // MenuFacturerID
          textTitleWithData(
              title: "Serial No.",
              data: _data.serialNo ?? "_assetsData?.serialNo ??" ""),
          // Serial No
          textTitleWithData(
              title: "Lot No.",
              data: _data.lotNo ?? "_assetsData?.lotNo ??" ""),
          // Lot No
          // textTitleWithData(
          //     title: "MFG Date", data: "_assetsData?.mfgDate ??" ""),
          // // MFG Date
          textTitleWithData(
              title: "Expire Date",
              data: _data.warrantyExpire ??
                  "_assetsData?.expireDate ??" "" + "\n"),
          // Expire Date
          textTitleWithData(
              title: "Product Detail",
              data: "\n" + "${_data.custRemark}" ??
                  "_assetsData?.productDetail ??"),
          // Product Detail
        ],
      ),
    );
  }

  TextSpan textTitleWithData({title, data}) {
    return TextSpan(
      children: [
        TextSpan(text: title ?? "", style: TextStyleCustom.STYLE_CONTENT),
        TextSpan(
            text: " : " + data + "\n",
            style: TextStyleCustom.STYLE_CONTENT
                .copyWith(color: ThemeColors.COLOR_BLACK)),
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
        colors: <Color>[
          ThemeColors.COLOR_BLACK.withOpacity(0.6),
          ThemeColors.COLOR_TRANSPARENT
        ],
      )),
      child: Center(
        child: _data.imageMain != null
            ? CachedNetworkImage(
                imageUrl: _data.imageMain,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter:
                            ColorFilter.mode(Colors.red, BlendMode.dstATop)),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
            : FlutterLogo(
                size: 200,
                colors: ThemeColors.COLOR_THEME_APP,
              ),
      ),
    );
  }
}
