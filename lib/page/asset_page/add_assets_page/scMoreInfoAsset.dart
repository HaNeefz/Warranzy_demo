import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class AddMoreInformationAsset extends StatefulWidget {
  final bool hasDataAssetAlready;

  const AddMoreInformationAsset({Key key, this.hasDataAssetAlready = false})
      : super(key: key);
  @override
  _AddMoreInformationAssetState createState() =>
      _AddMoreInformationAssetState();
}

enum TITLE_KEY_TYPE {
  SHOPFORSALES,
  SHOPBRANCH,
  SHOPCOUNTRY,
  PRODUCTCATEGORY,
  PRODUCTGROUP,
  PLACE,
  CURRENCY
}

class _AddMoreInformationAssetState extends State<AddMoreInformationAsset> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();

  Map<TITLE_KEY_TYPE, String> dropDownValue = {
    TITLE_KEY_TYPE.SHOPFORSALES: "Central",
    TITLE_KEY_TYPE.SHOPBRANCH: "Powerbuy",
    TITLE_KEY_TYPE.SHOPCOUNTRY: "Bangkok",
    TITLE_KEY_TYPE.PRODUCTCATEGORY: "Cleaning",
    TITLE_KEY_TYPE.PRODUCTGROUP: "Cleaning",
    TITLE_KEY_TYPE.PLACE: "Home",
    TITLE_KEY_TYPE.CURRENCY: "THB"
  };

  Map<TITLE_KEY_TYPE, List<String>> itemsDropDrown = {
    TITLE_KEY_TYPE.SHOPFORSALES: ["Central", "Super Center"],
    TITLE_KEY_TYPE.SHOPBRANCH: ["Powerbuy", "banan Shop"],
    TITLE_KEY_TYPE.SHOPCOUNTRY: ["Bangkok", "Nakhonnayok"],
    TITLE_KEY_TYPE.PRODUCTCATEGORY: ["Cleaning", "TV"],
    TITLE_KEY_TYPE.PRODUCTGROUP: ["Cleaning", "Mobile phone"],
    TITLE_KEY_TYPE.PLACE: ["Home", "Office"],
    TITLE_KEY_TYPE.CURRENCY: ["THB", "\$"]
  };

  List<String> title = [
    "Shop for sales",
    "Shop Branch",
    "Shop Country",
    "Product Category",
    "Product Group",
    "Product Place",
    "Currency"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextBuilder.build(
            title:
                widget.hasDataAssetAlready == true ? "Edit Asset" : "New Asset",
            style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
        child: ListView(
          children: <Widget>[
            buildHeader(),
            SizedBox(
              height: 20,
            ),
            buildFormWidget(
              // dropdown Shop for sale
              title: title[0],
              child: DropdownButton<String>(
                isExpanded: true,
                value: dropDownValue[TITLE_KEY_TYPE.SHOPFORSALES],
                items: itemsDropDrown[TITLE_KEY_TYPE.SHOPFORSALES]
                    .map<DropdownMenuItem<String>>((data) {
                  return DropdownMenuItem<String>(
                    value: data,
                    child: TextBuilder.build(
                        title: "$data",
                        style: TextStyleCustom.STYLE_LABEL
                            .copyWith(color: COLOR_BLACK)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  print(newValue);
                  setState(() {
                    dropDownValue[TITLE_KEY_TYPE.SHOPFORSALES] = newValue;
                  });
                },
              ),
            ),
            buildFormWidget(
              // dropdown shop branch
              title: title[1],
              child: DropdownButton<String>(
                isExpanded: true,
                value: dropDownValue[TITLE_KEY_TYPE.SHOPBRANCH],
                items: itemsDropDrown[TITLE_KEY_TYPE.SHOPBRANCH]
                    .map<DropdownMenuItem<String>>((data) {
                  return DropdownMenuItem<String>(
                    value: data,
                    child: TextBuilder.build(
                        title: "$data",
                        style: TextStyleCustom.STYLE_LABEL
                            .copyWith(color: COLOR_BLACK)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  print(newValue);
                  setState(() {
                    dropDownValue[TITLE_KEY_TYPE.SHOPBRANCH] = newValue;
                  });
                },
              ),
            ),
            buildFormWidget(
              // dropdown shop country
              title: title[2],
              child: DropdownButton<String>(
                isExpanded: true,
                value: dropDownValue[TITLE_KEY_TYPE.SHOPCOUNTRY],
                items: itemsDropDrown[TITLE_KEY_TYPE.SHOPCOUNTRY]
                    .map<DropdownMenuItem<String>>((data) {
                  return DropdownMenuItem<String>(
                    value: data,
                    child: TextBuilder.build(
                        title: "$data",
                        style: TextStyleCustom.STYLE_LABEL
                            .copyWith(color: COLOR_BLACK)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  print(newValue);
                  setState(() {
                    dropDownValue[TITLE_KEY_TYPE.SHOPCOUNTRY] = newValue;
                  });
                },
              ),
            ),
            buildFormWidget(title: "Purchase Date*", child: TextField()),
            buildFormWidget(title: "Warranty No.*", child: TextField()),
            buildFormWidget(title: "Warranty Expire Date*", child: TextField()),
            buildFormWidget(
              // dropdown product category
              title: title[3] + "*",
              child: DropdownButton<String>(
                isExpanded: true,
                value: dropDownValue[TITLE_KEY_TYPE.PRODUCTCATEGORY],
                items: itemsDropDrown[TITLE_KEY_TYPE.PRODUCTCATEGORY]
                    .map<DropdownMenuItem<String>>((data) {
                  return DropdownMenuItem<String>(
                    value: data,
                    child: TextBuilder.build(
                        title: "$data",
                        style: TextStyleCustom.STYLE_LABEL
                            .copyWith(color: COLOR_BLACK)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  print(newValue);
                  setState(() {
                    dropDownValue[TITLE_KEY_TYPE.PRODUCTCATEGORY] = newValue;
                  });
                },
              ),
            ),
            buildFormWidget(
              // dropdown product group
              title: title[4],
              child: DropdownButton<String>(
                isExpanded: true,
                value: dropDownValue[TITLE_KEY_TYPE.PRODUCTGROUP],
                items: itemsDropDrown[TITLE_KEY_TYPE.PRODUCTGROUP]
                    .map<DropdownMenuItem<String>>((data) {
                  return DropdownMenuItem<String>(
                    value: data,
                    child: TextBuilder.build(
                        title: "$data",
                        style: TextStyleCustom.STYLE_LABEL
                            .copyWith(color: COLOR_BLACK)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  print(newValue);
                  setState(() {
                    dropDownValue[TITLE_KEY_TYPE.PRODUCTGROUP] = newValue;
                  });
                },
              ),
            ),
            buildFormWidget(
              // dropdown product group
              title: title[5],
              child: DropdownButton<String>(
                isExpanded: true,
                value: dropDownValue[TITLE_KEY_TYPE.PLACE],
                items: itemsDropDrown[TITLE_KEY_TYPE.PLACE]
                    .map<DropdownMenuItem<String>>((data) {
                  return DropdownMenuItem<String>(
                    value: data,
                    child: TextBuilder.build(
                        title: "$data",
                        style: TextStyleCustom.STYLE_LABEL
                            .copyWith(color: COLOR_BLACK)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  print(newValue);
                  setState(() {
                    dropDownValue[TITLE_KEY_TYPE.PLACE] = newValue;
                  });
                },
              ),
            ),
            buildFormWidget(title: "Product Price*", child: TextField()),
            buildFormWidget(
              // dropdown product group
              title: title[6],
              child: DropdownButton<String>(
                isExpanded: true,
                value: dropDownValue[TITLE_KEY_TYPE.CURRENCY],
                items: itemsDropDrown[TITLE_KEY_TYPE.CURRENCY]
                    .map<DropdownMenuItem<String>>((data) {
                  return DropdownMenuItem<String>(
                    value: data,
                    child: TextBuilder.build(
                        title: "$data",
                        style: TextStyleCustom.STYLE_LABEL
                            .copyWith(color: COLOR_BLACK)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  print(newValue);
                  setState(() {
                    dropDownValue[TITLE_KEY_TYPE.CURRENCY] = newValue;
                  });
                },
              ),
            ),
            buildFormWidget(
                title: "Note (Optional)",
                child: TextField(
                  maxLines: 5,
                  decoration: InputDecoration(border: InputBorder.none),
                )),
            SizedBox(
              height: 15,
            ),
            ButtonBuilder.buttonCustom(
                context: context,
                label: allTranslations.text("success"),
                paddingValue: 5,
                onPressed: () {
                  widget.hasDataAssetAlready == true
                      ? ecsLib
                          .showDialogLib(
                              context: context,
                              title: "EDIT ASSET",
                              content: "Edit Asset Success!",
                              textOnButton: allTranslations.text("ok"))
                          .then((respone) {
                          if (respone == true) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        })
                      : ecsLib
                          .showDialogAction(
                              context: context,
                              title: "ADD ASSET",
                              content: allTranslations.text("finish"),
                              textOk: allTranslations.text("ok"),
                              textCancel: "")
                          .then((res) {
                          if (res == true) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        });
                })
          ],
        ),
      ),
    );
  }

  Container buildFormWidget({String title, Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 0.3, color: COLOR_GREY),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextBuilder.build(
              title: title,
              style: TextStyleCustom.STYLE_CONTENT.copyWith(fontSize: 15)),
          child
        ],
      ),
    );
  }

  RichText buildHeader() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: "Add more information\n",
              style:
                  TextStyleCustom.STYLE_TITLE.copyWith(color: COLOR_THEME_APP)),
          TextSpan(
              text:
                  "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.",
              style: TextStyleCustom.STYLE_CONTENT),
        ],
      ),
    );
  }
}
