import 'dart:async';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warranzy_demo/models/model_get_brand_name.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/form_input_data.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'package:dio/dio.dart';

import 'scAdd_image.dart';
import 'scAdd_image_demo.dart';

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
  final GlobalKey<FormBuilderState> _fbk = GlobalKey<FormBuilderState>();
  final GlobalKey<AutoCompleteTextFieldState<GetBrandName>> keyAutoComplete =
      GlobalKey();
  final Dio dio = Dio();
  AutoCompleteTextField searchTextField;
  TextEditingController txtCtrlBrandCode = TextEditingController(text: "");
  TextEditingController txtCtrlBrandName = TextEditingController(text: "");
  TextEditingController txtCtrlSerialNo = TextEditingController(text: "");
  TextEditingController txtCtrlNote = TextEditingController(text: "");
  TextEditingController txtCtrlLotNo = TextEditingController(text: "");
  TextEditingController txtCtrlPrice = TextEditingController(text: "");
  String brandActive = "N";
  var valueBrandName = "DysonElectric";
  List<GetBrandName> listBrandName = [];
  List<String> listBrandID = [];

  List<String> _dataBrandNameDD = [
    "Dyson Electric",
    "Dyson Phone",
    "Doyson TV"
  ];
  var valueMenufacturer = "Dyson V7 Trigger";
  List<String> _dataMenufacturerDD = [
    "Dyson V7 Trigger",
    "Dyson V6 Trigger",
    "Dyson V5 Trigger"
  ];

  PageAction get page => widget.onClickAddAssetPage;

  @override
  void initState() {
    super.initState();
    // streamController = StreamController<List<String>>();
    // streamController.sink.add(["test1", "test2", "test3", "test4"]);

    // getBrandName();
    Future.delayed(Duration(milliseconds: 1500), () {
      getBrandName();
    });
  }

  getBrandName() {
    Firestore.instance.collection('BrandName').snapshots().listen((onData) {
      for (var temp in onData.documents) {
        listBrandName.add(GetBrandName.fromJson(temp.data));
        listBrandName[onData.documents.indexOf(temp)].brandCode =
            temp.documentID;
        // print(
        //     "${listBrandName[onData.documents.indexOf(temp)].brandID} | ${listBrandName[onData.documents.indexOf(temp)].modelBrandName.modelEN.en}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> _title = [
      "Brand Name",
      "Manufacturer Name",
      "Manufacturer Product ID",
      "Serial No.",
      "Lot No.",
      "MFG Date",
      "Expire Date"
    ];

    List<String> _place = [
      "Home",
      "Office",
      "School",
      "Kitchen",
    ];
    List<String> _group = [
      "Car",
      "Living Room",
      "Meeting Room",
      "Bed room",
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextBuilder.build(
            title:
                widget.hasDataAssetAlready == true ? "Edit Asset" : "New Asset",
            style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: ecsLib.dismissedKeyboard(
        context,
        child: FormBuilder(
          key: _fbk,
          autovalidate: true,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 10, top: 20),
            child: ListView(
              children: <Widget>[
                buildTitle(),
                SizedBox(
                  height: 20,
                ),
                if (page == PageAction.SCAN_QR_CODE)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildInformation(
                          title: "Brand Name", data: "Dyson Electric"),
                      buildInformation(
                          title: "Manufacturer Name", data: "Dyson V7 Trigger"),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FormWidgetBuilder.formDropDown(
                        key: "PdtGroup",
                        title: "Group*",
                        hint: "Choose your group",
                        validate: [
                          FormBuilderValidators.required(),
                        ],
                        items: _group,
                      ),
                      FormWidgetBuilder.formWidget(
                          title: "BrandName*", child: autoCompleteTextField()),
                      FormWidgetBuilder.formDropDown(
                        key: "PdtPlace",
                        title: "Place*",
                        hint: "Choose your place",
                        validate: [
                          FormBuilderValidators.required(),
                        ],
                        items: _place,
                      ),
                    ],
                  ),
                FormWidgetBuilder.formInputData(
                    key: "Title",
                    title: "Title*",
                    validators: [FormBuilderValidators.required()]),
                FormWidgetBuilder.formInputData(
                    key: "WarrantyNo",
                    title: "Warranty No.*",
                    validators: [FormBuilderValidators.required()]),
                FormWidgetBuilder.formInputData(
                    key: "WarrantyExpire",
                    title: "Warranty Expire*",
                    validators: [FormBuilderValidators.required()]),
                FormWidgetBuilder.formDropDown(
                  key: "AlertDate",
                  title: "Choose notification before expire* (Day)",
                  hint: "Ex. 30 days",
                  validate: [
                    FormBuilderValidators.required(),
                  ],
                  items: [60, 30, 7, 0],
                ),
                FormWidgetBuilder.formWidget(
                    title: "Optional",
                    showTitle: false,
                    child: ExpansionTile(
                      title: TextBuilder.build(
                          title: "Optional",
                          style: TextStyleCustom.STYLE_LABEL_BOLD),
                      children: <Widget>[
                        FormWidgetBuilder.formInputDataNotValidate(
                          controller: txtCtrlSerialNo,
                          title: "Serial No.",
                        ),
                        FormWidgetBuilder.formInputDataNotValidate(
                          controller: txtCtrlLotNo,
                          title: "Lot No.",
                        ),
                        FormWidgetBuilder.formInputDataNotValidate(
                          title: "Price",
                          controller: txtCtrlPrice,
                        ),
                      ],
                    )),
                FormWidgetBuilder.formInputDataNotValidate(
                  controller: txtCtrlNote,
                  title: "Note",
                  maxLine: 5,
                ),
                if (page == PageAction.SCAN_QR_CODE)
                  Column(
                    children: <Widget>[
                      buildProductImage(),
                      buildDetailProduct(),
                    ],
                  ),
                buildContinue(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  AutoCompleteTextField<GetBrandName> autoCompleteTextField() {
    return searchTextField = AutoCompleteTextField<GetBrandName>(
      key: keyAutoComplete,
      suggestions: listBrandName,
      clearOnSubmit: false,
      controller: txtCtrlBrandName,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 30, 10, 20),
          hintText: "Search"),
      itemFilter: (item, query) {
        return item.modelBrandName.modelEN.en
            .toLowerCase()
            .startsWith(query.toLowerCase());
      },
      itemSorter: (a, b) => //
          a.modelBrandName.modelEN.en.compareTo(b.modelBrandName.modelEN.en),
      itemBuilder: (context, item) {
        return buildTextAutoComplete(item);
      },
      itemSubmitted: (item) {
        setState(() {
          txtCtrlBrandCode.text = item.brandCode;
          searchTextField.textField.controller.text =
              item.modelBrandName.modelEN.en;
          txtCtrlBrandName.text = item.modelBrandName.modelEN.en;
          brandActive = item.brandActive;
        });
      },
    );
  }

  Widget buildTextAutoComplete(GetBrandName item) => Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextBuilder.build(
                  title: "${item.modelBrandName.modelEN.en}",
                  style: TextStyleCustom.STYLE_LABEL_BOLD),
            )
          ],
        ),
      );

  Widget buildBrandAndMenufacturer() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(width: 0.3, color: ThemeColors.COLOR_GREY),
              borderRadius: BorderRadius.circular(5)),
          child: DropdownButton<String>(
            isExpanded: true,
            value: valueBrandName,
            items: ["Dyson Electric", "Dyson Phone", "Doyson TV"]
                .map<DropdownMenuItem<String>>((data) {
              return DropdownMenuItem<String>(
                value: data,
                child: TextBuilder.build(title: data),
              );
            }).toList(),
            onChanged: (value) {
              valueBrandName = value;
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(width: 0.3, color: ThemeColors.COLOR_GREY),
              borderRadius: BorderRadius.circular(5)),
          child: DropdownButton<String>(
            isExpanded: true,
            value: valueMenufacturer,
            items: ["Dyson V7 Trigger", "Dyson V6 Trigger", "Dyson V5 Trigger"]
                .map<DropdownMenuItem<String>>((data) {
              return DropdownMenuItem<String>(
                value: data,
                child: TextBuilder.build(title: data),
              );
            }).toList(),
            onChanged: (value) {
              valueMenufacturer = value;
            },
          ),
        ),
      ],
    );
  }

  Padding buildContinue(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
      child: ButtonBuilder.buttonCustom(
          paddingValue: 10,
          context: context,
          label: allTranslations.text("continue"),
          onPressed: () {
            print("tap");
            _fbk.currentState.save();
            if (_fbk.currentState.validate()) {
              var dataAsset = _fbk.currentState.value;
              dataAsset.addAll(addTextController());
              // print(dataAsset);
              ecsLib.pushPage(
                context: context,
                pageWidget: AddImageDemo(
                  dataAsset: dataAsset,
                ),
                // AddImage(
                //   hasDataAssetAlready: widget.hasDataAssetAlready,
                //   dataAsset: dataAsset,
                // ),
              );
            }
          }),
    );
  }

  Map<String, String> addTextController() {
    Map<String, String> mapData = {
      "BrandCode": txtCtrlBrandCode.text,
      "BrandActive": brandActive,
      "SerialNo": txtCtrlSerialNo.text,
      "LotNo": txtCtrlLotNo.text,
      "SalesPrice": txtCtrlPrice.text,
      "CustRemark": txtCtrlNote.text,
      "CreateType":
          widget.onClickAddAssetPage == PageAction.MANUAL_ADD ? "C" : "T",
      "PdtCatCode": "A001"
    };
    return mapData;
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

  RichText buildTitle() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Product Detail\n",
            style: TextStyleCustom.STYLE_TITLE
                .copyWith(color: ThemeColors.COLOR_THEME_APP),
          ),
          TextSpan(
              text:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, ",
              style: TextStyleCustom.STYLE_CONTENT),
        ],
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
