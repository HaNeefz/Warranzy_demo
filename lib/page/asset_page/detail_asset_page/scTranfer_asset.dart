import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_asset_data.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class TranfersInformation extends StatefulWidget {
  final ModelAssetsData assetsData;

  const TranfersInformation({Key key, this.assetsData}) : super(key: key);
  @override
  _TranfersInformationState createState() => _TranfersInformationState();
}

class _TranfersInformationState extends State<TranfersInformation> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextBuilder.build(
            title: "Transfer asset", style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: ListView(
          children: <Widget>[
            TextBuilder.build(
                title: "Transfer information",
                style: TextStyleCustom.STYLE_TITLE
                    .copyWith(color: COLOR_THEME_APP)),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Your Asset\n",
                        style: TextStyleCustom.STYLE_CONTENT),
                    TextSpan(
                        text: widget.assetsData.manuFacturerName,
                        style: TextStyleCustom.STYLE_LABEL_BOLD
                            .copyWith(fontSize: 20)),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.3, color: COLOR_GREY),
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Customer ID\n",
                              style: TextStyleCustom.STYLE_CONTENT),
                          TextSpan(
                              text: "WR867145",
                              style: TextStyleCustom.STYLE_LABEL_BOLD
                                  .copyWith(fontSize: 20))
                        ]),
                      ),
                      Icon(
                        Icons.search,
                        size: 35,
                      )
                    ],
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: FlutterLogo(),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextBuilder.build(
                            title: "Bambam Brown",
                            style: TextStyleCustom.STYLE_LABEL_BOLD
                                .copyWith(fontSize: 20)),
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on),
                            TextBuilder.build(title: "Bangkok")
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: ButtonBuilder.buttonCustom(
                        paddingValue: 5,
                        context: context,
                        label: "Transfer",
                        onPressed: () {
                          ecsLib
                              .showDialogLib(
                                  context: context,
                                  title: "TRANSFER ASSET",
                                  content: "Transfer Success!",
                                  textOnButton: allTranslations.text("ok"))
                              .then((response) {
                            if (response) Navigator.pop(context);
                          });
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
