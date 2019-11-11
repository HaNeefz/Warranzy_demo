import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:warranzy_demo/models/model_image_data_each_group.dart';
import 'package:warranzy_demo/models/model_repository_asset_scan.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/page/asset_page/add_assets_page/scAdd_image_demo.dart';
import 'package:warranzy_demo/page/asset_page/add_edit_asset.dart';
import 'package:warranzy_demo/page/main_page/scMain_page.dart';
import 'package:warranzy_demo/services/api/repository.dart';
import 'package:warranzy_demo/services/api_provider/api_bloc.dart';
import 'package:warranzy_demo/services/api_provider/api_response.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';
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
                        dataScan: snapshot.data.data.dataScan,
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
  final ModelDataScan dataScan;
  final List<Map<String, List<String>>> listImage;

  const DetailAsset(
      {Key key,
      this.heroTag,
      this.editAble = true,
      this.dataAsset,
      this.showDetailOnline,
      this.dataScan,
      this.listImage})
      : super(key: key);

  @override
  _DetailAssetState createState() => _DetailAssetState();
}

class _DetailAssetState extends State<DetailAsset> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  ModelDataAsset get _data => widget.dataAsset;
  List<ImageDataEachGroup> imageDataEachGroup = [];
  List<ImageDataEachGroup> imageGroup = [];
  List<String> listImageUrl = [];
  List<String> imageData = [];
  List<String> imageKey = [];
  String catName = '';
  String brandName = '';

  getProductCateName() async {
    // print(
    //     "carID : ${_data.pdtCatCode} | lang: ${allTranslations.currentLanguage}");
    var _catName = await DBProviderInitialApp.db.getProductCatName(
        id: _data.pdtCatCode, lang: allTranslations.currentLanguage);

    catName = _catName;
    print("catName ====================> $catName");
  }

  getBrandName() async {
    var _brandName = await DBProviderAsset.db.getBrandName(_data.brandCode);
    setState(() {
      brandName = _brandName;
    });
  }

  getImage() async {
    //keep all tempKey
    List<String> _key = [];
    // print("widget.listImage => ${widget.listImage}");
    //loop for get data type list<Map<..,..>>
    widget.listImage.map((map) {
      // loop get data type Map for output to key,value . To continue to use.
      map.forEach((k, v) {
        // print("k : $k | v : $v");
        //add data image each group
        imageDataEachGroup.add(ImageDataEachGroup(title: k, imageBase64: v));
        // loop cause v (as Value) isList for getAllKey
        v.forEach((v) {
          //add imageKey
          _key.add(v);
        });
      });
      // print("_key => $_key");

      //loop all key in loop of Type each Image ex. "Image_Product"
      _key.forEach((key) async {
        // keep All KEY_IMAGE for delete each image.
        imageKey.add(key);
        //getAllImage by keyImage
        await DBProviderAsset.db.getImagePoolReturn(key).then((filePool) {
          //addImage for show in widget
          imageData.add(filePool.first.fileData);
        });
      });
      //clear tempKey cause duplicate in loop
      _key = [];
    }).toList();
    print("imageKey => $imageKey");
    // imageDataEachGroup.forEach((v) {
    //   print("title : ${v.title} | base64 : ${v.imageBase64}");
    // });
  }

  _testGetImage() {
    print("widget.listImage : ${widget.listImage}");
    widget?.listImage?.forEach((v) {
      v.forEach((k, v) {
        imageDataEachGroup
            .add(ImageDataEachGroup(title: k, imageBase64: v, tempBase64: []));
        // imageGroup
        //     .add(ImageDataEachGroup(title: k, imageBase64: v, tempBase64: []));
      });
    });
    imageDataEachGroup.forEach((v) async {
      // print("v : ${v.imageBase64}");
      v.imageBase64.forEach((key) async {
        imageKey.add(key);
        await ImageDataEachGroup.changeImageKeyToBase64(key).then((_base64) {
          //addImage for show in widget
          // print("filePool : $filePool");
          imageData.add(_base64);
          imageDataEachGroup[imageDataEachGroup.indexOf(v)]
              .tempBase64
              .add(_base64);
          // print(
          //     "<<<< TempBase64 : ${imageGroup[imageGroup.indexOf(v)].tempBase64.length} >>>>");
        });
      });
    });

    // imageGroup.forEach((b) {
    //   print("b : ${b.tempBase64.length}");
    // });
  }

  void initState() {
    super.initState();
    // getImage();
    _testGetImage();
    getProductCateName();
    getBrandName();
  }

  goToEditPageForEditImage(bool editImage) {
    // if (editImage == true)
    Map<String, List<String>> _tempFileAttach = {};
    widget?.listImage?.forEach((v) {
      _tempFileAttach.addAll(v);
    });
    // print("<DetailAsset> fileAttach => $_tempFileAttach");
    print("---------DetailPage : WTokenID : ${_data.wTokenID}");
    ecsLib.pushPage(
      context: context,
      pageWidget: EditDetailAsset(
        editingImage: editImage,
        modelDataAsset: _data,
        imageDataEachGroup: imageDataEachGroup,
        fileAttach: widget.listImage,
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
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 15,
            blurRadius: 1,
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
                  ? widget.showDetailOnline == true && _data.createType == "C"
                      ? containerButton(Icons.mode_edit,
                          onPressed: () => goToEditPageForEditImage(true))
                      : Container()
                  : Container()
            ],
            flexibleSpace: CarouselWithIndicator(
                autoPlay: false,
                height: 400,
                viewportFraction: 1.0,
                items: widget.dataScan == null &&
                        widget.dataAsset.createType == "C"
                    ? imageData != null && imageData.length > 0
                        ? showProductImage(
                            imgPath: imageData, isImageBase64: true)
                        : Iterable.generate(4, (i) => testImage()).toList()
                    : showProductImage(
                        imgPath: widget?.dataScan?.fileImageID ?? null)),
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
    // print("TypeAsset -> $typeAsset");
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
            buildLastAssetInformation(),
            if (widget.showDetailOnline == true)
              Column(
                children: <Widget>[
                  buildButtonDuplicate(context),
                  SizedBox(height: 10),
                  buildButtonDelete(context),
                  SizedBox(height: 10),
                ],
              )
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
            context,
            title: "DELETE ASSET",
            content: "Are you sure to delete asset ?",
            textOk: allTranslations.text("ok"),
            textCancel: allTranslations.text("cancel"),
          )
              .then((response) async {
            if (response == true) {
              try {
                ecsLib.showDialogLoadingLib(context);
                await Repository.deleteAseet(
                    body: {"WTokenID": "${_data.wTokenID}"}).then((res) async {
                  ecsLib.cancelDialogLoadindLib(context);
                  if (res?.status == true) {
                    print("Data => ${res.data}");
                    await DBProviderAsset.db.deleteAssetByWToken(
                        wTokenID: _data.wTokenID, imageKey: imageKey);
                    // await DBProviderAsset.db.
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
          _data.wTokenID = "";
          _data.createType = "C";
          if (imageDataEachGroup.length > 0) {
            imageDataEachGroup.forEach((v) {
              print(
                  "<<<< ${v.title} have base64 : ${v.tempBase64.length} >>>>");
            });
          } else {
            print("<<<< imageGroup.length < 0 >>>>");
          }
          ecsLib.pushPage(
            context: context,
            pageWidget: FormDataAssetTest(
                modelDataAsset: _data,
                categoryID: null,
                actionPageForAdd: true,
                pageType:
                    _data.createType == "C" ? PageType.MANUAL : PageType.SCANQR,
                listImageDataEachGroup: imageDataEachGroup),
          );
        });
  }

  Widget buildLastAssetInformation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (_data.createType == "T" && widget.showDetailOnline == true)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextBuilder.build(
                    title: "Warranty used", style: TextStyleCustom.STYLE_TITLE),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    goToEditPageForEditImage(false);
                  },
                )
              ],
            ),
          RichText(
            text: TextSpan(
              children: [
                textTitleWithData(title: "Asset Name", data: "${_data.title}"),
                textTitleWithData(
                    title: "Brand Name",
                    data: "${brandName ?? "BrandName is Empty"}"),
                textTitleWithData(
                    title: "Product Category",
                    data: "${_data.modelCatName?.eN ?? catName}"),
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
                textTitleWithData(
                    title: "Serial No.", data: "${_data.serialNo}"),
                textTitleWithData(title: "Lot No.", data: "${_data.lotNo}"),
                textTitleWithData(
                    title: "Note (Optional)", data: "${_data.custRemark}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildProductPhotoByCustomer() {
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
                      text: "Purchase Information\n",
                      style: TextStyleCustom.STYLE_TITLE
                          .copyWith(letterSpacing: 1.5)),
                  TextSpan(
                      text: "Product Photo(By Customer)",
                      style: TextStyleCustom.STYLE_CONTENT),
                ]),
              ),
              if (widget.showDetailOnline == true)
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      goToEditPageForEditImage(true);
                    }),
            ],
          ),
          Container(
            height: 300,
            padding: EdgeInsets.only(top: 10),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: showProductImage(
                  imgPath: imageData,
                  isImageBase64: true,
                  width: 250,
                  height: 250,
                  padding: EdgeInsets.only(right: 5, top: 5)),
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
    var _manName = "-";
    var _detail = "-";
    if (widget.dataScan?.manName != null &&
        widget.dataScan?.description != null) {
      _manName = jsonDecode(widget.dataScan?.manName)["EN"];
      _detail = jsonDecode(widget.dataScan?.description)["EN"];
    }
    return RichText(
      text: TextSpan(
        style: TextStyleCustom.STYLE_CONTENT,
        children: [
          textTitleWithData(
              title: "Menufacturer ID", data: widget.dataScan?.manCode ?? "-"),
          textTitleWithData(title: "Menufacturer Name", data: _manName ?? "-"),
          textTitleWithData(
              title: "Warranty Date",
              data: "${_data.warrantyExpire ?? "warrantyExpireDate"}"),
          textTitleWithData(
              title: "Brand Name", data: brandName ?? "BrandName is Empty"),
          textTitleWithData(
              title: "MFG Date", data: widget.dataScan?.mFGDate ?? "-"),
          textTitleWithData(
              title: "Warranty Date", data: "${_data.warrantyExpire ?? "-"}"),
          textTitleWithData(title: "Product Detail", data: "${_detail ?? "-"}"),
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

  List<ImageDataEachGroup> getImageUrl(ModelDataAsset images) {
    Map<String, dynamic> tempImages;
    List<ImageDataEachGroup> tempImageDataEachGroup = [];
    if (images.images != null) {
      tempImages = jsonDecode(images.images);
      tempImages.forEach((String k, dynamic v) {
        var listTemp = v as List;
        List<String> tempUrl = [];
        for (var item in listTemp) {
          tempUrl.add(item);
          // setState(() {
          listImageUrl.add(item);
          // });
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

  List showProductImage(
      {List<dynamic> imgPath = const [],
      double width = 150,
      double height = 150,
      EdgeInsetsGeometry padding,
      bool isImageBase64 = false}) {
    // print("imgPath : $imgPath");
    if (imgPath.isNotEmpty && imgPath.length > 0 && imgPath != null) {
      return Iterable.generate(
        imgPath.length,
        (i) => GestureDetector(
            onTap: () {
              Navigator.of(context).push(TransparentMaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (BuildContext context) => PhotoViewPage(
                        image: imgPath,
                        heroTag: "image$i",
                        currentIndex: i,
                        isImageBase64: isImageBase64,
                      )));
            },
            child: isImageBase64 == false
                ? CachedNetworkImage(
                    imageUrl: imgPath[i],
                    imageBuilder: (context, imageProvider) => Container(
                      width: width,
                      height: height,
                      margin: padding,
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
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )
                : Container(
                    width: width,
                    height: height,
                    margin: padding,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.memory(
                        base64Decode(imgPath[i]),
                        width: width,
                        height: height,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
      ).toList();
    } else
      return Iterable.generate(4, (i) => testImage()).toList();
  }
}

class ImagesParse {}
