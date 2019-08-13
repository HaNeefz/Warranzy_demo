import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/models/model_claim_asset.dart';
import 'package:warranzy_demo/page/asset_page/detail_asset_page/scDetailAsset.dart';
import 'package:warranzy_demo/page/service_page/scPayment.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/carouselImage.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class DetailProductClaim extends StatefulWidget {
  final ModelAssetsData assetsData;
  final ModelClaimProductAsset productClaimData;
  final bool isHistory;

  const DetailProductClaim(
      {Key key, this.assetsData, this.productClaimData, this.isHistory = false})
      : super(key: key);
  @override
  _DetailProductClaimState createState() => _DetailProductClaimState();
}

class _DetailProductClaimState extends State<DetailProductClaim> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();

  bool get isHistory => widget.isHistory == true;
  ModelAssetsData get assetsData => widget.assetsData;
  @override
  Widget build(BuildContext context) {
    TextStyle styleContent = TextStyleCustom.STYLE_CONTENT;
    return Scaffold(
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          buildSliverAppBar(context),
          buildSliverBody(styleContent, context)
        ],
      ),
    );
  }

  SliverList buildSliverBody(TextStyle styleContent, BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextBuilder.build(
                        title: "Fix Service",
                        style: TextStyleCustom.STYLE_TITLE
                            .copyWith(color: ThemeColors.COLOR_THEME_APP)),
                  ],
                ),
                TextBuilder.build(
                    title: assetsData.manuFacturerName,
                    style: TextStyleCustom.STYLE_LABEL_BOLD.copyWith(
                      fontSize: 30,
                      height: 1.0,
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextBuilder.build(
                      title:
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                      style: styleContent),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildStatus(
                          styleContent, "Delivery Type", "Delivery by service"),
                      buildStatus(styleContent, "Request Date",
                          widget.productClaimData.requsetDate),
                      buildStatus(
                          styleContent,
                          "Status",
                          !isHistory
                              ? widget.productClaimData.status
                              : "${allTranslations.text("success")} (30.05.2019)"),
                    ],
                  ),
                ),
                isHistory
                    ? buildMoreDataAboutHistory(styleContent)
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                TextBuilder.build(title: "About Asset", style: styleContent),
                buildAboutOwnerAsset(
                    textStyleContent: styleContent,
                    userName: "SandyKim ",
                    userID: "WE865145",
                    email: "sandy123@gmail.com",
                    mobileNo: "082-123-1234"),
                Divider(),
                ListTile(
                  title: TextBuilder.build(title: "Asset Detail"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    ecsLib.pushPage(
                      context: context,
                      pageWidget: DetailAsset(
                        assetsData: assetsData,
                        editAble: false,
                      ),
                    );
                  },
                ),
                Divider(),
                !isHistory
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ButtonBuilder.buttonCustom(
                          paddingValue: 0,
                          colorsButton: ThemeColors.COLOR_WHITE,
                          labelStyle: styleContent.copyWith(color: ThemeColors.COLOR_ERROR),
                          context: context,
                          label: "Cancel Service",
                        ),
                      )
                    : Container()
              ],
            ),
          )
        ],
      ),
    );
  }

  Padding buildMoreDataAboutHistory(TextStyle styleContent) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextBuilder.build(
                title: "Change Info", style: TextStyleCustom.STYLE_CONTENT),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Fix Motors\n",
                                      style: TextStyleCustom.STYLE_LABEL_BOLD),
                                  TextSpan(
                                    text: assetsData.productDetail
                                        .substring(0, 50),
                                    style: styleContent.copyWith(
                                      color: ThemeColors.COLOR_BLACK,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Status Payment : ",
                                      style: styleContent),
                                  TextSpan(
                                      text: "Complete",
                                      style: TextStyleCustom.STYLE_LABEL_BOLD
                                          .copyWith(color: ThemeColors.COLOR_THEME_APP)),
                                ],
                              ),
                            )
                          ],
                        )),
                    Expanded(
                      child: TextBuilder.build(
                          title: "500 THB",
                          style: styleContent,
                          textAlign: TextAlign.end),
                    ),
                  ],
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: ButtonBuilder.buttonCustom(
                          cornerRadius: 10,
                          colorsButton: ThemeColors.COLOR_WHITE,
                          paddingValue: 0,
                          context: context,
                          label: "Call Service",
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: ButtonBuilder.buttonCustom(
                            cornerRadius: 10,
                            context: context,
                            paddingValue: 0,
                            label: "Payment Service",
                            onPressed: () {
                              ecsLib.pushPage(
                                context: context,
                                pageWidget: PayMentAboutClaim(),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
                Divider(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Padding buildAboutOwnerAsset(
      {TextStyle textStyleContent, userName, userID, email, mobileNo}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage(Assets.BACK_GROUND_APP),
                  fit: BoxFit.cover)),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "$userName", style: TextStyleCustom.STYLE_LABEL_BOLD),
                TextSpan(text: "(Asset Owner)\n", style: textStyleContent),
                TextSpan(text: "User ID : ", style: textStyleContent),
                TextSpan(text: "$userID\n", style: textStyleContent),
                TextSpan(text: "Email : ", style: textStyleContent),
                TextSpan(text: "$email\n", style: textStyleContent),
                TextSpan(text: "Mobile No. : ", style: textStyleContent),
                TextSpan(text: "$mobileNo\n", style: textStyleContent),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStatus(TextStyle styleContent, title, data) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(text: "$title : ", style: styleContent),
        TextSpan(
            text: data,
            style: TextStyleCustom.STYLE_LABEL_BOLD
                .copyWith(color: ThemeColors.COLOR_THEME_APP))
      ]),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      // pinned: true,
      expandedHeight: 300,
      centerTitle: true,
      // backgroundColor: ThemeColors.COLOR_WHITE,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: ThemeColors.COLOR_WHITE,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: CarouselWithIndicator(
        autoPlay: false,
        height: 400,
        viewportFraction: 1.0,
        indiCatorIsLight: true,
        items: Iterable.generate(
            4,
            (i) => Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  Assets.BACK_GROUND_APP,
                  fit: BoxFit.cover,
                ))).toList(),
      ),
    );
  }
}
