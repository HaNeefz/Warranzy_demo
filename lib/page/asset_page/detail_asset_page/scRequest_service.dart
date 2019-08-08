import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class RequestService extends StatefulWidget {
  final String assetName;

  const RequestService({Key key, this.assetName}) : super(key: key);
  @override
  _RequestServiceState createState() => _RequestServiceState();
}

class _RequestServiceState extends State<RequestService> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  String serviceTypeValue = "Fix Service";
  String deliveryTypeValue = "Delivery by service";
  int counterPhoto = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextBuilder.build(
            title: "Request service", style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: ListView(
          children: <Widget>[
            buildHeader(),
            buildAssetName(),
            formWidget(
              title: "Serive Type",
              child: DropdownButton(
                value: serviceTypeValue,
                isExpanded: true,
                items: ["Fix Service", "Other"]
                    .map<DropdownMenuItem<String>>((data) {
                  return DropdownMenuItem(
                    value: data,
                    child: TextBuilder.build(title: data),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    serviceTypeValue = value;
                  });
                },
              ),
            ),
            formWidget(
              title: "Delivey",
              child: DropdownButton(
                value: deliveryTypeValue,
                isExpanded: true,
                items: ["Delivery by service", "Other"]
                    .map<DropdownMenuItem<String>>((data) {
                  return DropdownMenuItem(
                    value: data,
                    child: TextBuilder.build(title: data),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    deliveryTypeValue = value;
                  });
                },
              ),
            ),
            formWidget(
                title: "Your Address",
                child: TextField(
                  decoration: InputDecoration(
                      hintText: allTranslations.text("address")),
                )),
            buildAddPhotos(context),
            formWidget(
                title: "Note (Optional)",
                child: TextField(
                  maxLines: 5,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                )),
            buildButtonSend(context),
          ],
        ),
      ),
    );
  }

  Padding buildButtonSend(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: ButtonBuilder.buttonCustom(
          paddingValue: 5,
          context: context,
          label: "Send",
          onPressed: () {
            ecsLib
                .showDialogLib(
                    context: context,
                    title: "REQUEST SERVICE",
                    content: "Send requset service",
                    textOnButton: allTranslations.text("ok"))
                .then((response) {
              if (response) Navigator.pop(context);
            });
          }),
    );
  }

  Column buildAddPhotos(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextBuilder.build(
                  title: "Product Photo (By Customer)",
                  style: TextStyleCustom.STYLE_CONTENT),
              TextBuilder.build(
                title: counterPhoto.toString() + "/10",
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: 10,
          ),
          height: 210,
          child: ListView.builder(
            itemCount: 5,
            itemExtent: 200,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    color: COLOR_THEME_APP,
                    borderRadius: BorderRadius.circular(20)),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: ButtonBuilder.buttonCustom(
              paddingValue: 5,
              context: context,
              label: counterPhoto < 10 ? "Add Photos" : "Limit photos",
              onPressed: () {
                setState(() {
                  if (counterPhoto < 10) counterPhoto++;
                });
              }),
        ),
      ],
    );
  }

  Widget formWidget({String title, Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(width: 0.3, color: COLOR_GREY),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextBuilder.build(title: title, style: TextStyleCustom.STYLE_CONTENT),
          child
        ],
      ),
    );
  }

  RichText buildAssetName() {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: "Your Asset\n",
            style:
                TextStyleCustom.STYLE_LABEL.copyWith(color: COLOR_THEME_APP)),
        TextSpan(
            text: widget.assetName + "\n\n", style: TextStyleCustom.STYLE_LABEL)
      ]),
    );
  }

  RichText buildHeader() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: "Enter asset information\n",
              style:
                  TextStyleCustom.STYLE_TITLE.copyWith(color: COLOR_THEME_APP)),
          TextSpan(
              text:
                  "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae.\n\n",
              style: TextStyleCustom.STYLE_CONTENT)
        ],
      ),
    );
  }
}
