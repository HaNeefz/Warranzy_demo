import 'package:flutter/material.dart';
import 'package:warranzy_demo/page/asset_page/add_edit_asset.dart' as Asset;
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/form_data_asset.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import '../add_edit_asset.dart';

class FillInformation extends StatefulWidget {
  final PageAction onClickAddAssetPage;
  final bool hasDataAssetAlready;

  FillInformation(
      {Key key, this.onClickAddAssetPage, this.hasDataAssetAlready = false})
      : super(key: key);
  @override
  _FillInformationState createState() => _FillInformationState();
}

class _FillInformationState extends State<FillInformation> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();

  PageAction get page => widget.onClickAddAssetPage;

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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildInformation(title: "Brand Name", data: "Dyson Electric"),
            buildInformation(
                title: "Manufacturer Name", data: "Dyson V7 Trigger"),
            buildProductImage(),
            buildDetailProduct(),
          ],
        );
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
              itemCount: 5,
              // itemExtent: 200,
              itemBuilder: (BuildContext context, int index) => Container(
                margin: EdgeInsets.all(5),
                width: 300,
                decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(20)),
                child: Center(child: FlutterLogo()),
              ),
            ),
          )
        ],
      ),
    );
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
              style: TextStyleCustom.STYLE_TITLE.copyWith(fontSize: 25)),
        ]),
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
