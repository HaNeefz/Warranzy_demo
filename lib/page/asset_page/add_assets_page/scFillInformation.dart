import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_repository_asset_scan.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/models/model_user.dart';
import 'package:warranzy_demo/page/asset_page/add_edit_asset.dart' as Asset;
import 'package:warranzy_demo/services/sqflit/db_asset.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/carouselImage.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/form_data_asset.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/image_list_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import '../add_edit_asset.dart';

class FillInformation extends StatefulWidget {
  final PageAction onClickAddAssetPage;
  final bool hasDataAssetAlready;
  final RepositoryAssetScan dataScan;

  FillInformation(
      {Key key,
      this.onClickAddAssetPage,
      this.hasDataAssetAlready = false,
      this.dataScan})
      : super(key: key);
  @override
  _FillInformationState createState() => _FillInformationState();
}

class _FillInformationState extends State<FillInformation> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();

  PageAction get page => widget.onClickAddAssetPage;
  RepositoryAssetScan get dataScan => widget.dataScan;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: checkActionPage(page),
    );
  }

  Widget checkActionPage(PageAction page) {
    switch (page) {
      case PageAction.MANUAL_ADD:
        return FormDataAssetTest(
            modelDataAsset: null,
            categoryID: null,
            actionPageForAdd: true,
            pageType: Asset.PageType.MANUAL,
            listImageDataEachGroup: []);
        // FormDataAsset(
        //   onClickAddAssetPage: page,
        //   actionPageForAdd: true,
        // );
        break;
      case PageAction.SCAN_QR_CODE:
        return new DataScanOfProduct(
            dataScan: dataScan,
            context: context,
            allTranslations: allTranslations);
        break;
      default:
        return Container();
    }
  }

  Padding buildDetailProduct() {
    return Padding(
        padding: const EdgeInsets.only(left: 15, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 10, 15),
              child: TextBuilder.build(
                  title: "Product Detail",
                  style: TextStyleCustom.STYLE_CONTENT),
            ),
            RichText(
              text: TextSpan(
                style: TextStyleCustom.STYLE_LABEL,
                children: [
                  TextSpan(
                    text:
                        "Lorem Ipsum\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s\n\nThe standard Lorem\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,\n\nExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

Widget buildInformation({String title, String data}) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0, bottom: 30),
    child: RichText(
      text: TextSpan(children: [
        TextSpan(
          text: "$title\n",
          style: TextStyleCustom.STYLE_CONTENT,
        ),
        TextSpan(
            text: data,
            style: TextStyleCustom.STYLE_TITLE
                .copyWith(fontSize: 25, letterSpacing: 1.5)),
      ]),
    ),
  );
}

class DataScanOfProduct extends StatefulWidget {
  const DataScanOfProduct({
    Key key,
    @required this.dataScan,
    @required this.context,
    @required this.allTranslations,
  }) : super(key: key);

  final RepositoryAssetScan dataScan;
  final BuildContext context;
  final GlobalTranslations allTranslations;

  @override
  _DataScanOfProductState createState() => _DataScanOfProductState();
}

class _DataScanOfProductState extends State<DataScanOfProduct> {
  final ecsLib = getIt.get<ECSLib>();

  String brandName = "";
  getBrandName() async {
    var _brandName =
        await DBProviderAsset.db.getBrandName(widget.dataScan.data.brandCode);
    setState(() {
      brandName = _brandName;
    });
  }

  @override
  void initState() {
    super.initState();
    getBrandName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     centerTitle: true,
      //     elevation: 0,
      //     title: TextBuilder.build(
      //         title: "Detail Product", style: TextStyleCustom.STYLE_APPBAR)),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            forceElevated: true,
            expandedHeight: 300,
            elevation: 0,
            title: TextBuilder.build(
                title: "Detail Product", style: TextStyleCustom.STYLE_APPBAR),
            backgroundColor: Colors.white,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: <Color>[Colors.teal, Colors.red])),
              child: showImageProduct(),
            ),
            leading: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.teal),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: ThemeColors.COLOR_WHITE,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextBuilder.build(
                      title: "Product Detail",
                      style: TextStyleCustom.STYLE_TITLE
                          .copyWith(color: ThemeColors.COLOR_THEME_APP)),
                  TextBuilder.build(
                      title:
                          "${jsonDecode(widget.dataScan.data.description)['EN']}",
                      style: TextStyleCustom.STYLE_CONTENT),
                  Divider()
                ],
              ),
            ),
            buildInformation(
                title: "Product Name",
                data: "${jsonDecode(widget.dataScan.data.productName)['EN']}"),
            buildInformation(title: "Brand Name", data: "$brandName"),
            buildInformation(
                title: "Manufacturer Code",
                data: "${widget.dataScan.data.manCode}"),
            buildInformation(
                title: "Manufacturer Name",
                data: "${jsonDecode(widget.dataScan.data.manName)['EN']}"),
            buildInformation(
                title: "Manufacturer ProductID",
                data: "${widget.dataScan.data.productID}"),
            // buildProductImage(),
            buildInformation(
                title: "Serial No.", data: "${widget.dataScan.data.serialNo}"),
            buildInformation(
                title: "Lot No.", data: "${widget.dataScan.data.lotNo}"),
            buildInformation(
                title: "CatCode",
                data: "${widget.dataScan.data.catCode ?? "-"}"),
            buildInformation(
                title: "Model", data: "${widget.dataScan.data.model ?? "-"}"),
            buildInformation(
                title: "ProductType",
                data: "${widget.dataScan.data.productType ?? "-"}"),
            buildInformation(
                title: "MFG Date",
                data: "${widget.dataScan.data.mFGDate.split(" ").first}"),
            buildInformation(
                title: "WarrantyNo",
                data: "${widget.dataScan.data.warrantyNo}"),
            buildInformation(
                title: "MonthOfWarranty",
                data: "${widget.dataScan.data.monthOfWarranty}"),
            buildInformation(
                title: "SLCCode",
                data: "${widget.dataScan.data.sLCCode ?? "-"}"),
            buildInformation(
                title: "SLCBranchNo",
                data: "${widget.dataScan.data.sLCBranchNo ?? "-"}"),
            buildInformation(
                title: "Spec Detail",
                data: "${widget.dataScan.data.specDetail ?? "-"}"),
            // buildProductImage(),
            // buildDetailProduct(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ButtonBuilder.buttonCustom(
                  context: context,
                  paddingValue: 10,
                  label: widget.allTranslations.text("continue"),
                  onPressed: () {
                    print("tap");
                    ModelDataAsset tempModelAsset = ModelDataAsset(
                        title:
                            jsonDecode(widget.dataScan.data.productName)['EN'],
                        brandCode: widget.dataScan.data.brandCode,
                        groupCat: widget.dataScan.data.groupID,
                        lotNo: widget.dataScan.data.warrantyNo,
                        modelBrandName:
                            BrandName(eN: widget.dataScan.data.brandCode),
                        pdtCatCode: widget.dataScan.data.catCode,
                        serialNo: widget.dataScan.data.serialNo,
                        slcName: widget.dataScan.data.sLCCode ?? "",
                        warrantyNo: widget.dataScan.data.warrantyNo,
                        wTokenID: widget.dataScan.data.wTokenID,
                        createType: "T");

                    print("title => ${tempModelAsset.title}");
                    print("brandCode => ${tempModelAsset.brandCode}");
                    print("groupCat => ${tempModelAsset.groupCat}");
                    print("lotNo => ${tempModelAsset.lotNo}");
                    print(
                        "modelBrandName => ${tempModelAsset.modelBrandName.eN}");
                    print("pdtCatCode => ${tempModelAsset.pdtCatCode}");
                    print("serialNo => ${tempModelAsset.serialNo}");
                    print("slcName => ${tempModelAsset.slcName}");
                    print("warrantyNo => ${tempModelAsset.warrantyNo}");
                    print("wTokenID => ${tempModelAsset.wTokenID}");
                    ecsLib.pushPage(
                      context: context,
                      pageWidget: FormDataAssetTest(
                          modelDataAsset: tempModelAsset,
                          categoryID: null,
                          actionPageForAdd: true,
                          pageType: Asset.PageType.SCANQR,
                          listImageDataEachGroup: []),
                    );
                  }),
            )
          ])),
        ],
      ),
    );
  }

  CarouselWithIndicator showImageProduct() {
    return CarouselWithIndicator(
      height: 350,
      viewportFraction: 1.0,
      items: widget.dataScan.data.fileImageID != null &&
              widget.dataScan.data.fileImageID.length > 0
          ? Iterable.generate(
              widget.dataScan.data.fileImageID.length,
              (i) => GestureDetector(
                onTap: () {
                  Navigator.of(widget.context)
                      .push(TransparentMaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (BuildContext context) => PhotoViewPage(
                                image: widget.dataScan.data.fileImageID,
                                heroTag: "image$i",
                                currentIndex: i,
                              )));
                },
                child: CachedNetworkImage(
                  imageUrl: widget.dataScan.data.fileImageID[i],
                  imageBuilder: (context, imageProvider) => Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          colorFilter:
                              ColorFilter.mode(Colors.red, BlendMode.dstATop)),
                    ),
                  ),
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ).toList()
          : Iterable.generate(4, (i) => testImage()).toList(),
    );
  }

  Container buildProductImage() {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, right: 10, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextBuilder.build(
              title: "Product Image", style: TextStyleCustom.STYLE_CONTENT),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.dataScan.data.fileImageID.length ?? 0,
              // itemExtent: 200,
              itemBuilder: (BuildContext context, int i) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(TransparentMaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => PhotoViewPage(
                            image: widget.dataScan.data.fileImageID,
                            heroTag: "image$i",
                            currentIndex: i,
                          )));
                },
                child: CachedNetworkImage(
                  imageUrl: widget.dataScan.data.fileImageID[i],
                  imageBuilder: (context, imageProvider) => Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                          colorFilter:
                              ColorFilter.mode(Colors.red, BlendMode.dstATop)),
                    ),
                  ),
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget testImage({Widget child, bool hasWidget = false}) {
    return Container(
      width: MediaQuery.of(widget.context).size.width,
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
}
/*
StreamBuilder(
                      stream: streamController.stream,
                      // initialData: "${streamController.stream.first}",
                      builder: (BuildContext context,
                          AsyncSnapshot<List<String>> snapshot) {
                        if (snapshot.hasData)
                          return FormWidgetBuilder.formDropDown(
                              key: "Places",
                              title: "Place",
                              validate: [FormBuilderValidators.required()],
                              items: snapshot.data);
                        else
                          return Text("Others");
                      },
                    ),
*/
