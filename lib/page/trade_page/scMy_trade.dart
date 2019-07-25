import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/page/asset_page/detail_asset_page/scTrade_asset.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'package:http/http.dart' as http;

import 'scTrade_contact.dart';
import 'scTrade_detail.dart';

class MyTrade extends StatefulWidget {
  @override
  _MyTradeState createState() => _MyTradeState();
}

class _MyTradeState extends State<MyTrade> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  ModelAssetsData assetsData = ModelAssetsData();
  List<ModelAssetsData> listData = [];

  @override
  void initState() {
    super.initState();
    listData = assetsData.pushData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextBuilder.build(
            title: "My Trade", style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            buildProfile(context),
            Divider(),
            buildLocation(),
            Divider(),
            buildTitleMyTradeAndButtonAddTrade(),
            buildMyTradeDataAll(),
            testButtonAPI()
          ],
        ),
      ),
    );
  }

  ListTile buildLocation() {
    return ListTile(
      leading: Icon(
        Icons.location_on,
        size: 35,
      ),
      title: TextBuilder.build(title: "Location"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextBuilder.build(
              title: "Bangkok", style: TextStyleCustom.STYLE_CONTENT),
          Icon(
            Icons.arrow_forward_ios,
          ),
        ],
      ),
      onTap: () {},
    );
  }

  ListTile buildProfile(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: COLOR_BLACK,
        radius: 30,
        child: FlutterLogo(),
      ),
      title: TextBuilder.build(title: "Trade Contact"),
      trailing: Icon(
        Icons.arrow_forward_ios,
      ),
      onTap: () => ecsLib.pushPage(
        context: context,
        pageWidget: TradeContact(),
      ),
    );
  }

  Widget buildMyTradeDataAll() {
    return Column(
      children: listData.map((data) {
        return Container(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Container(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          Assets.BACK_GROUND_APP,
                          fit: BoxFit.cover,
                        ),
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextBuilder.build(
                              title:
                                  "${data.manuFacturerName} มือสอง ใช้งานมา 2 ปีี",
                              style: TextStyleCustom.STYLE_TITLE
                                  .copyWith(fontSize: 20),
                              maxLine: 1,
                              textOverflow: TextOverflow.ellipsis),
                          TextBuilder.build(
                              title: "${data.productPrice}",
                              style: TextStyleCustom.STYLE_CONTENT),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "\nStatus Trade   ",
                                    style: TextStyleCustom.STYLE_CONTENT
                                        .copyWith(fontSize: 12)),
                                TextSpan(
                                    text: "Active",
                                    style: TextStyleCustom.STYLE_LABEL_BOLD
                                        .copyWith(color: COLOR_THEME_APP)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: IconButton(
                      icon: Icon(
                        Icons.more_vert,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextBuilder.build(
                                      title:
                                          "${data.manuFacturerName} มือสอง ใช้งานมา 3 ปี",
                                      style: TextStyleCustom.STYLE_CONTENT
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                      maxLine: 1,
                                      textOverflow: TextOverflow.ellipsis),
                                  Divider(),
                                  modelListTileModelSheet(
                                      icons: Icons.credit_card,
                                      title: "Mark as Sold",
                                      onTap: () {}),
                                  Divider(),
                                  modelListTileModelSheet(
                                      icons: Icons.pause_circle_outline,
                                      title: "Mark as inactive",
                                      onTap: () {}),
                                  Divider(),
                                  modelListTileModelSheet(
                                      icons: Icons.edit,
                                      title: "Edit Trade",
                                      onTap: () {
                                        Navigator.pop(context);
                                        ecsLib.pushPage(
                                            context: context,
                                            pageWidget: TradeInformation(
                                              assetsData: data,
                                              editAble: true,
                                            ));
                                      }),
                                  Divider(),
                                  modelListTileModelSheet(
                                      icons: Icons.delete_outline,
                                      title: "Delete Trade",
                                      onTap: () {}),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
              onTap: () {
                ecsLib.pushPage(
                    context: context,
                    pageWidget: TradeDetail(
                      assetsData: data,
                    ));
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget modelListTileModelSheet({icons, title, onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(
          icons,
          color: COLOR_BLACK,
        ),
        title: TextBuilder.build(title: title),
        onTap: onTap,
      ),
    );
  }

  Row buildTitleMyTradeAndButtonAddTrade() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextBuilder.build(
            title: "My Trade Asset", style: TextStyleCustom.STYLE_LABEL_BOLD),
        RaisedButton.icon(
          color: COLOR_THEME_APP,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          icon: Icon(
            Icons.add,
            color: COLOR_WHITE,
          ),
          label: TextBuilder.build(
              title: "Add Trade",
              style: TextStyleCustom.STYLE_LABEL
                  .copyWith(color: COLOR_WHITE, fontSize: 14)),
          onPressed: () => ecsLib.pushPage(
              context: context,
              pageWidget: TradeInformation(
                assetsData: listData[0],
              )),
        )
      ],
    );
  }

  RaisedButton testButtonAPI() {
    return RaisedButton(
      child: Text("API"),
      onPressed: () async {
        await http
            .post("https://testwarranty-239103.appspot.com/API/v1/User/test")
            .then((res) {
          print(res.body);
        });
      },
    );
  }
}
