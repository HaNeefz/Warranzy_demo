import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/page/asset_page/add_assets_page/scAdd_image_demo.dart';
import 'package:warranzy_demo/page/asset_page/add_edit_asset.dart';
import 'package:warranzy_demo/page/main_page/scMain_page.dart';
import 'package:warranzy_demo/services/api/api_service_assets.dart';
import 'package:warranzy_demo/services/api_provider/api_bloc.dart';
import 'package:warranzy_demo/services/api_provider/api_response.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/carouselImage.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/image_list_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/loading_api.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/error_api.dart';

import 'scEditDetailAsset.dart';

class LoadingDetailAsset extends StatefulWidget {
  final ModelDataAsset dataAsset;
  final bool online;

  LoadingDetailAsset({Key key, this.dataAsset, this.online}) : super(key: key);

  @override
  _LoadingDetailAssetState createState() => _LoadingDetailAssetState();
}

class _LoadingDetailAssetState extends State<LoadingDetailAsset> {
  ApiBlocGetDetailAsset<ResponseDetailOfAsset> _detailAssetBloc;

  var url = "/Asset/getDetailAsset";
  @override
  void initState() {
    super.initState();
    _detailAssetBloc = ApiBlocGetDetailAsset<ResponseDetailOfAsset>(
        url: url, body: {"WTokenID": widget.dataAsset.wTokenID});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ApiResponse<ResponseDetailOfAsset>>(
        stream: _detailAssetBloc.stmStream,
        builder: (BuildContext context,
            AsyncSnapshot<ApiResponse<ResponseDetailOfAsset>> snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return LoadingApi(
                    // loadingMessage: snapshot.data.message,
                    );
                break;
              case Status.COMPLETED:
                return ControlledAnimation(
                  duration: Duration(milliseconds: 200),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  builder: (context, animation) {
                    return Opacity(
                      opacity: animation,
                      child: DetailAsset(
                        dataAsset: snapshot.data.data.data,
                        showDetailOnline: true,
                      ),
                    );
                  },
                );
                //
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _detailAssetBloc.fetchData(),
                );
                break;
            }
          }
          return Container();
        },
      ),
    );
  }
}

class DetailAsset extends StatefulWidget {
  final String heroTag;
  final bool editAble;
  final bool showDetailOnline;
  final ModelDataAsset dataAsset;

  const DetailAsset(
      {Key key,
      this.heroTag,
      this.editAble = true,
      this.dataAsset,
      this.showDetailOnline})
      : super(key: key);

  @override
  _DetailAssetState createState() => _DetailAssetState();
}

class _DetailAssetState extends State<DetailAsset> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  ModelDataAsset get _data => widget.dataAsset;
  List<ImageDataEachGroup> imageDataEachGroup = [];
  List<String> listImageUrl = [];
  String catName = "";

  void initState() {
    super.initState();

    getProductCateName();
    if (_data.createType == "C") {
      imageDataEachGroup = getImage(_data);
    }
  }

  getProductCateName() async {
    var _catName = await DBProviderInitialApp.db.getProductCatName(
        id: _data.pdtCatCode, lang: allTranslations.currentLanguage);
    setState(() {
      catName = _catName;
    });
  }

  goToEditPageForEditImage(bool editImage) {
    // if (editImage == true)
    ecsLib.pushPage(
      context: context,
      pageWidget: EditDetailAsset(
        editingImage: editImage,
        modelDataAsset: _data,
        imageDataEachGroup: imageDataEachGroup,
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: buildDetailAsset(context),
    );
  }

  Widget containerButton(IconData icons, {Function onPressed}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.teal,
            spreadRadius: 2,
            blurRadius: 30,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icons),
        color: Colors.white,
        onPressed: onPressed,
      ),
    );
  }

  Container buildDetailAsset(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            expandedHeight: 300,
            backgroundColor: ThemeColors.COLOR_WHITE,
            automaticallyImplyLeading: false,
            leading: containerButton(Icons.arrow_back_ios,
                onPressed: () => Navigator.pop(context)),
            actions: <Widget>[
              widget.editAble == true
                  ? widget.showDetailOnline == true
                      ? containerButton(Icons.mode_edit,
                          onPressed: () => goToEditPageForEditImage(true))
                      : Container()
                  : Container()
            ],
            flexibleSpace: CarouselWithIndicator(
                autoPlay: false,
                height: 400,
                viewportFraction: 1.0,
                items: listImageUrl != null && listImageUrl.length > 0
                    ? Iterable.generate(
                        listImageUrl.length,
                        (i) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                TransparentMaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (BuildContext context) =>
                                        PhotoViewPage(
                                          image: listImageUrl,
                                          heroTag: "image$i",
                                          currentIndex: i,
                                        )));
                          },
                          child: CachedNetworkImage(
                            imageUrl: listImageUrl[i],
                            imageBuilder: (context, imageProvider) => Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                        Colors.red, BlendMode.dstATop)),
                              ),
                            ),
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ).toList()
                    : Iterable.generate(4, (i) => testImage()).toList()),
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
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  Widget checkTypeAsset(String typeAsset) {
    Widget child = Container();
    switch (typeAsset) {
      case "C":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildProductPhotoByCustomerEdit(),
            buildLastAssetInformation(),
            if (widget.showDetailOnline == true)
              Column(
                children: <Widget>[
                  buildButtonDuplicate(context),
                  SizedBox(height: 10),
                  buildButtonDelete(context),
                ],
              )
          ],
        );
        break;
      case "T":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
        paddingValue: 0,
        colorsButton: Colors.red[200],
        labelStyle:
            TextStyleCustom.STYLE_LABEL_BOLD.copyWith(color: Colors.white),
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

  Widget buildButtonDuplicate(BuildContext context) {
    return ButtonBuilder.buttonCustom(
        paddingValue: 0,
        context: context,
        label: "Duplicate",
        onPressed: () async {
          print("Duplicate");
          ecsLib.pushPage(
            context: context,
            pageWidget: FormDataAssetTest(
                modelDataAsset: _data,
                categoryID: null,
                actionPageForAdd: true,
                pageType: PageType.MANUAL,
                listImageDataEachGroup: []),
          );
        });
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
            textTitleWithData(title: "Asset Name", data: "${_data.title}"),
            textTitleWithData(title: "Brand Name", data: "${_data.brandCode}"),
            textTitleWithData(title: "Product Category", data: catName),
            textTitleWithData(
                title: "Product Group", data: "${_data.pdtGroup}"),
            textTitleWithData(
                title: "Product Place", data: "${_data.pdtPlace}"),
            textTitleWithData(title: "SLCName", data: "${_data.slcName}"),
            textTitleWithData(
                title: "Product Price", data: "${_data.salesPrice}"),
            textTitleWithData(
                title: "Warranty No", data: "${_data.warrantyNo}"),
            textTitleWithData(
                title: "Warranty Expire Date",
                data: _data.warrantyExpire.split(" ").first),
            textTitleWithData(
                title: "AlerDate",
                data: _data.alertDate != null
                    ? _data.alertDate.split(" ").first
                    : "-"),
            textTitleWithData(
                title: "Alert Date No.", data: "${_data.alertDateNo}"),
            textTitleWithData(title: "Serial No.", data: "${_data.serialNo}"),
            textTitleWithData(title: "Lot No.", data: "${_data.lotNo}"),
            textTitleWithData(
                title: "Note (Optional)", data: "${_data.custRemark}"),
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

  Container buildProductPhotoByCustomerEdit() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Information\n",
                      style: TextStyleCustom.STYLE_TITLE),
                  TextSpan(
                      text: "Product (By Customer)",
                      style: TextStyleCustom.STYLE_CONTENT),
                ]),
              ),
              widget.showDetailOnline == true
                  ? IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        goToEditPageForEditImage(false);
                        // ecsLib.pushPage(
                        //     context: context,
                        //     pageWidget: FormDataAssetTest(
                        //       actionPageForAdd: false,
                        //       modelDataAsset: _data,
                        //       pageType: PageType.MANUAL,
                        //       listImageDataEachGroup: imageDataEachGroup,
                        //     ));
                      },
                    )
                  : Container()
            ],
          ),
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
                  "_assetsData?.productDetail ??"), //_data.custRemark
          // Product Detail
        ],
      ),
    );
  }

  TextSpan textTitleWithData({title, data}) {
    if (data == "" || data == "null" || data == null) data = "-";
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

  Widget testImage({Widget child, bool hasWidget = false}) {
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
        child: hasWidget == false
            ? FlutterLogo(
                size: 200,
                colors: ThemeColors.COLOR_THEME_APP,
              )
            : child,
      ),
    );
  }

  List<ImageDataEachGroup> getImage(ModelDataAsset images) {
    Map<String, dynamic> tempImages;
    List<ImageDataEachGroup> tempImageDataEachGroup = [];
    if (images.images != null) {
      tempImages = jsonDecode(images.images);
      tempImages.forEach((String k, dynamic v) {
        var listTemp = v as List;
        List<String> tempUrl = [];
        for (var item in listTemp) {
          tempUrl.add(item);
          setState(() {
            listImageUrl.add(item);
          });
        }
        tempImageDataEachGroup
            .add(ImageDataEachGroup(title: k, imageUrl: tempUrl));
      });
      tempImageDataEachGroup.forEach((v) {
        print("Title : ${v.title} | url[${v.imageUrl.length}] ${v.imageUrl}");
      });
    }
    return tempImageDataEachGroup;
  }
}

class ImagesParse {}
