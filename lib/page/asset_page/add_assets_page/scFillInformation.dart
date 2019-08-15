import 'dart:async';
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warranzy_demo/models/model_get_brand_name.dart';
import 'package:warranzy_demo/services/api/api_services_user.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/form_input_data.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'package:dio/dio.dart';

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
  AutoCompleteTextField searchTextField;
  TextEditingController txtCtrl = TextEditingController(text: "");
  TextEditingController txtCtrlSerialNo = TextEditingController(text: "");
  TextEditingController txtCtrlLotNo = TextEditingController(text: "");
  TextEditingController txtCtrlPrice = TextEditingController(text: "");
  // StreamController<List<String>> streamController;
  var valueBrandName = "DysonElectric";
  List<GetBrandName> listBrandName = [];
  List<GetBrandName> tempListBrandName = [];

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
      }
      print(listBrandName.length);
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
      body: FormBuilder(
        key: _fbk,
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
                      hint: "qwertteqwe",
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
                      hint: "qwertteqwe",
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
              FormWidgetBuilder.formWidget(
                  title: "Optional",
                  showTitle: false,
                  child: ExpansionTile(
                    title: TextBuilder.build(
                        title: "Optional",
                        style: TextStyleCustom.STYLE_LABEL_BOLD),
                    children: <Widget>[
                      FormWidgetBuilder.formInputData(
                        key: "SerialNo",
                        textContrl: txtCtrlSerialNo,
                        title: "Serial No.",
                        validators: null,
                      ),
                      FormWidgetBuilder.formInputData(
                        key: "LotNo",
                        textContrl: txtCtrlLotNo,
                        title: "Lot No.",
                        validators: null,
                      ),
                      FormWidgetBuilder.formInputData(
                        key: "Price",
                        title: "Price",
                        textContrl: txtCtrlPrice,
                        validators: null,
                      ),
                    ],
                  )),
              FormWidgetBuilder.formInputData(
                  key: "Remark", title: "Note", validators: null, maxLine: 5),
              RaisedButton(
                child: Text("Take a Photo"),
                onPressed: () async {
                  await ecsLib.getImage().then((v) async {
                    var imageConpressed = await ecsLib.compressFile(
                        file: v,
                        targetPath: v.absolute.path,
                        minHeight: 640,
                        minWidth: 480,
                        quality: 50);
                    String imageBase64 =
                        base64Encode(imageConpressed.readAsBytesSync());
                    // print("$imageBase64");
                    print("sending..");
                    FormData form = FormData.from({
                      "base64": ["imageBase64[0]", "imageBase64[1]"]
                    });

                    try {
                      await dio
                          .post(
                              "http://192.168.0.36:9999/API/v1/User/TestLoading",
                              data: form,
                              onSendProgress: (int sent, int total) =>
                                  print("$sent | $total"))
                          // await http
                          //     .post(
                          //         "http://192.168.0.36:9999/API/v1/User/TestLoading",
                          //         body: body)
                          .then((res) {
                        print(res.data);
                      }).catchError((onError) {
                        print("catchError $onError");
                      });
                    } on TimeoutException catch (_) {
                      print("TimeOut");
                    } catch (e) {
                      print("$e");
                    }
                  });
                },
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
    );
  }

  AutoCompleteTextField<GetBrandName> autoCompleteTextField() {
    return searchTextField = AutoCompleteTextField<GetBrandName>(
      key: keyAutoComplete,
      suggestions: listBrandName,
      clearOnSubmit: false,
      controller: txtCtrl,
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
          txtCtrl.text = item.modelBrandName.modelEN.en;
          searchTextField.textField.controller.text =
              item.modelBrandName.modelEN.en;
        });
      },
    );
  }

  Widget buildTextAutoComplete(GetBrandName item) => Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("${item.modelBrandName.modelEN.en}"),
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
            // print(_fbk.currentState.value);
            if (_fbk.currentState.validate()) {
              print(_fbk.currentState.value);
            }
            // ecsLib.pushPage(
            //   context: context,
            //   pageWidget: AddImage(
            //     hasDataAssetAlready: widget.hasDataAssetAlready,
            //   ),
            // );
          }),
    );
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
