import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/page/asset_page/detail_asset_page/scDetailAsset.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/carouselImage.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class TradeDetail extends StatefulWidget {
  final ModelAssetsData assetsData;

  const TradeDetail({Key key, this.assetsData}) : super(key: key);
  @override
  _TradeDetailState createState() => _TradeDetailState();
}

class _TradeDetailState extends State<TradeDetail> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();

  ModelAssetsData get assetsData => widget.assetsData;
  @override
  Widget build(BuildContext context) {
    TextStyle styleContent = TextStyleCustom.STYLE_CONTENT;
    return Scaffold(
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          buildSliverAppBar(context),
          SliverList(
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
                              title: assetsData.productPrice,
                              style: TextStyleCustom.STYLE_TITLE
                                  .copyWith(color: COLOR_THEME_APP)),
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {},
                          )
                        ],
                      ),
                      TextBuilder.build(
                          title: assetsData.manuFacturerName +
                              " มือสอง การใช้งาน 3 เดือน",
                          style: TextStyleCustom.STYLE_LABEL_BOLD.copyWith(
                            fontSize: 30,
                            height: 1.0,
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.location_on),
                            TextBuilder.build(
                                title: "Bangkok", style: styleContent)
                          ],
                        ),
                      ),
                      TextBuilder.build(
                          title:
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                          style: styleContent),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: COLOR_THEME_APP.withOpacity(0.5)),
                        child: TextBuilder.build(
                            title: assetsData.productCategory),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildStatus(styleContent, "Status", "Active"),
                            buildStatus(styleContent, "Create Date",
                                assetsData.expireDate),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextBuilder.build(
                          title: "About Asset", style: styleContent),
                      buildAboutOwnerAsset(
                          textStyleContent: styleContent,
                          userName: "SandyKim",
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
                    ],
                  ),
                )
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
                .copyWith(color: COLOR_THEME_APP))
      ]),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 300,
      // backgroundColor: COLOR_WHITE,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: COLOR_WHITE,
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
