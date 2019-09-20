import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:warranzy_demo/models/model_get_brand_name.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/page/asset_page/add_assets_page/scAdd_image_demo.dart';
import 'package:warranzy_demo/page/asset_page/detail_asset_page/scDetailAsset.dart';
import 'package:warranzy_demo/services/api/api_service_assets.dart';
import 'package:warranzy_demo/services/method/scan_qr.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';

import '../assets.dart';
import '../const.dart';
import '../theme_color.dart';
import 'button_builder.dart';
import 'button_date_picker.dart';
import 'text_builder.dart';
import 'text_field_builder.dart';

class FormDataAsset extends StatefulWidget {
  final ModelDataAsset modelDataAsset;
  final bool actionPageForAdd;
  final PageAction onClickAddAssetPage;
  FormDataAsset(
      {Key key,
      this.modelDataAsset,
      this.actionPageForAdd,
      this.onClickAddAssetPage})
      : super(key: key);

  _FormDataAssetState createState() => _FormDataAssetState();
}

class _FormDataAssetState extends State<FormDataAsset> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  ModelDataAsset get _data => widget.modelDataAsset;
  bool get actionPageForAdd => widget.actionPageForAdd;
  final GlobalKey<AutoCompleteTextFieldState<GetBrandName>> keyAutoComplete =
      GlobalKey();
  AutoCompleteTextField searchTextField;

  TextEditingController txtAssetName;
  TextEditingController txtBrandName;
  TextEditingController txtBrandCode;
  TextEditingController txtWarranzyNo;
  TextEditingController txtWarranzyExpire;
  TextEditingController txtAlertDate;
  TextEditingController txtPdtCat;
  TextEditingController txtPdtGroup;
  TextEditingController txtPdtPlace;
  TextEditingController txtPrice;
  TextEditingController txtSerialNo;
  TextEditingController txtLotNo;
  TextEditingController txtNote;
  TextEditingController txtSLCName;

  String brandActive = "N";
  var valueBrandName = "DysonElectric";
  List<GetBrandName> listBrandName = [];
  List<String> listBrandID = [];
  String dataTime = '';
  Future<List<ProductCatagory>> getProductCategory;
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

  @override
  void initState() {
    getProductCategory = DBProviderInitialApp.db.getAllDataProductCategory();
    print(_data?.salesPrice);
    if (_data != null) {
      brandActive = _data?.brandCode != null ? "Y" : "N";
      txtAssetName = TextEditingController(text: _data?.title ?? "");
      txtBrandName = TextEditingController(text: "");
      txtBrandCode = TextEditingController(text: _data?.brandCode ?? "");
      txtWarranzyNo = TextEditingController(text: _data?.warrantyNo ?? "");
      ButtonDatePickerCustom.setShowDate = _data?.warrantyExpire ?? "";
      txtWarranzyExpire =
          TextEditingController(text: ButtonDatePickerCustom.showDate);
      dataTime = txtWarranzyExpire.text;
      txtAlertDate =
          TextEditingController(text: _data?.alertDateNo.toString() ?? "");
      txtPdtCat = TextEditingController(text: _data?.pdtCatCode ?? "");
      txtPdtGroup = TextEditingController(text: _data?.pdtGroup ?? "");
      txtPdtPlace = TextEditingController(text: _data?.pdtPlace ?? "");
      txtPrice = TextEditingController(text: _data?.salesPrice ?? "");
      txtSerialNo = TextEditingController(text: _data?.serialNo ?? "");
      txtLotNo = TextEditingController(text: _data?.lotNo ?? "");
      txtNote = TextEditingController(text: _data?.custRemark ?? "");
      txtSLCName = TextEditingController(text: _data?.slcName ?? "");
    } else {
      brandActive = _data?.brandCode != null ? "Y" : "N";
      txtAssetName = TextEditingController(text: "");
      txtBrandName = TextEditingController(text: "");
      txtBrandCode = TextEditingController(text: "");
      txtWarranzyNo = TextEditingController(text: "");
      txtWarranzyExpire = TextEditingController(text: "");
      txtAlertDate = TextEditingController(text: "60");
      txtPdtCat = TextEditingController(text: "A001");
      txtPdtGroup = TextEditingController(text: _group.elementAt(0));
      txtPdtPlace = TextEditingController(text: _place.elementAt(0));
      txtPrice = TextEditingController(text: "");
      txtSerialNo = TextEditingController(text: "");
      txtLotNo = TextEditingController(text: "");
      txtNote = TextEditingController(text: "");
      txtSLCName = TextEditingController(text: "");
    }

    Future.delayed(Duration(milliseconds: 1500), () {
      getBrandName();
    });
    super.initState();
  }

  @override
  void dispose() {
    txtAssetName?.dispose();
    txtBrandCode?.dispose();
    txtBrandName?.dispose();
    txtWarranzyNo?.dispose();
    txtWarranzyExpire?.dispose();
    txtAlertDate?.dispose();
    txtPdtCat?.dispose();
    txtPdtGroup?.dispose();
    txtPdtPlace?.dispose();
    txtPrice?.dispose();
    txtNote?.dispose();
    txtSerialNo?.dispose();
    txtSLCName?.dispose();
    txtLotNo?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: ecsLib.dismissedKeyboard(
        context,
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: KeyboardAvoider(
            child: ListView(
              controller: _scrollController,
              children: <Widget>[
                TextFieldBuilder.textFormFieldCustom(
                    controller: txtAssetName,
                    borderOutLine: false,
                    necessary: true,
                    validate: true,
                    title: "Asset Name"),
                formWidget(
                  title: "Category",
                  necessary: true,
                  child: FutureBuilder<List<ProductCatagory>>(
                    future: getProductCategory,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ProductCatagory>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (!(snapshot.hasError)) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                  // border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[100]),
                              value: txtPdtCat.text,
                              items: snapshot.data.map((v) {
                                return DropdownMenuItem(
                                  value: v.catCode,
                                  child: TextBuilder.build(
                                      title: "${v.catCode}. ${v.catName}",
                                      style: TextStyleCustom.STYLE_LABEL
                                          .copyWith(fontSize: 15),
                                      maxLine: 1,
                                      textOverflow: TextOverflow.ellipsis),
                                );
                              }).toList(),
                              onChanged: (value) => setState(() {
                                txtPdtCat.text = value;
                                print(txtPdtCat.text);
                              }),
                            ),
                          );
                        } else {
                          return TextBuilder.build(title: "Error data");
                        }
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        return TextBuilder.build(title: "Something Wrong.");
                      }
                    },
                  ),
                ),
                formWidget(
                    title: "Group",
                    necessary: true,
                    child: dropdownFormfield(
                      initalData: txtPdtGroup.text,
                      items: [
                        "Car",
                        "Living Room",
                        "Meeting Room",
                        "Bed room",
                      ],
                      onChange: (value) {
                        setState(() {
                          txtPdtGroup.text = value;
                        });
                      },
                    )),
                formWidget(
                    title: "Place",
                    necessary: true,
                    child: dropdownFormfield(
                      initalData: txtPdtPlace.text,
                      items: [
                        "Home",
                        "Office",
                        "School",
                        "Kitchen",
                      ],
                      onChange: (value) {
                        setState(() {
                          txtPdtPlace.text = value;
                        });
                      },
                    )),
                formWidget(
                    title: "Brand Name",
                    necessary: true,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                          ),
                          child: autoCompleteTextField()),
                    )),
                formWidget(
                    title: "Warranzy Expire",
                    necessary: true,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: RaisedButton(
                        elevation: 0,
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextBuilder.build(title: dataTime)),
                        onPressed: () {
                          Picker(
                              itemExtent: 40,
                              adapter: DateTimePickerAdapter(customColumnType: [
                                0,
                                1,
                                2
                              ], months: [
                                allTranslations.text("jan"),
                                allTranslations.text("feb"),
                                allTranslations.text("mar"),
                                allTranslations.text("apr"),
                                allTranslations.text("may"),
                                allTranslations.text("Jun"),
                                allTranslations.text("jul"),
                                allTranslations.text("aug"),
                                allTranslations.text("sep"),
                                allTranslations.text("oct"),
                                allTranslations.text("nov"),
                                allTranslations.text("dec")
                              ]),
                              delimiter: [PickerDelimiter(child: Container())],
                              hideHeader: true,
                              confirmText: allTranslations.text("confirm"),
                              cancelText: allTranslations.text("cancel"),
                              title: new Text("Please Select"),
                              onConfirm: (Picker picker, List value) {
                                print(
                                    "Picker value : ${(picker.adapter as DateTimePickerAdapter).value}");
                                setState(() {
                                  dataTime =
                                      (picker.adapter as DateTimePickerAdapter)
                                          .value
                                          .toString()
                                          .split(" ")
                                          .first;
                                  txtWarranzyExpire.text =
                                      (picker.adapter as DateTimePickerAdapter)
                                          .value
                                          .toString();
                                });
                              }).showDialog(context);
                        },
                      ),
                    )
                    // ButtonDatePickerCustom.buttonDatePicker(context, () {
                    //   print(ButtonDatePickerCustom.showDate);
                    //   setState(() {
                    //     // _showDate = ButtonDatePickerCustom.showDate;
                    //     txtWarranzyExpire.text = ButtonDatePickerCustom.valueDate;
                    //   });
                    // }),
                    ),
                actionPageForAdd == false
                    ? formWidget(
                        title: "Alert Date",
                        child: dropdownFormfield(
                          initalData: txtAlertDate.text,
                          items: ["0", "7", "30", "60"],
                          onChange: (value) {
                            setState(() {
                              txtAlertDate.text = value;
                            });
                          },
                        ))
                    : Container(),
                formWidget(
                  title: "Optional",
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[100], width: 3)
                        // color: Colors.grey[100]
                        ),
                    padding: EdgeInsets.all(5),
                    child: ExpansionTile(
                      title: TextBuilder.build(title: ""),
                      children: <Widget>[
                        TextFieldBuilder.textFormFieldCustom(
                            controller: txtWarranzyNo,
                            borderOutLine: false,
                            validate: false,
                            title: "Warranty No"),
                        TextFieldBuilder.textFormFieldCustom(
                            controller: txtSLCName,
                            borderOutLine: false,
                            validate: false,
                            title: "SLCName"),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFieldBuilder.textFormFieldCustom(
                                  controller: txtSerialNo,
                                  validate: false,
                                  borderOutLine: false,
                                  title: "Serial No"),
                            ),
                            GestureDetector(
                                onTap: () async {
                                  print("ScanBarCode or QR");
                                  var dataScan =
                                      await MethodLib.scanQR(context);
                                  if (dataScan != null)
                                    setState(() {
                                      txtSerialNo.text = dataScan;
                                    });
                                },
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(Assets.ICON_BARCODE,
                                        width: 35, height: 35),
                                    TextBuilder.build(
                                        title: "Scan",
                                        style: TextStyleCustom.STYLE_LABEL
                                            .copyWith(fontSize: 10))
                                  ],
                                ))
                          ],
                        ),
                        TextFieldBuilder.textFormFieldCustom(
                            controller: txtLotNo,
                            keyboardType: TextInputType.number,
                            validate: false,
                            borderOutLine: false,
                            title: "Lot No"),
                        TextFieldBuilder.textFormFieldCustom(
                            controller: txtPrice,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validate: false,
                            borderOutLine: false,
                            title: "Salse price"),
                      ],
                    ),
                  ),
                ),
                TextFieldBuilder.textFormFieldCustom(
                    controller: txtNote,
                    validate: false,
                    maxLine: 5,
                    borderOutLine: false,
                    title: "Note"),
                if (actionPageForAdd == true)
                  buildContinue(context)
                else
                  ButtonBuilder.buttonCustom(
                    paddingValue: 5,
                    onPressed: () {
                      _formKey.currentState.save();
                      if (_formKey.currentState.validate()) {
                        buttonEditInformation();
                      }
                    },
                    context: context,
                    label: "Edit",
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getBrandName() {
    Firestore.instance.collection('BrandName').snapshots().listen((onData) {
      for (var temp in onData.documents) {
        listBrandName.add(GetBrandName.fromJson(temp.data));
        listBrandName[onData.documents.indexOf(temp)].brandCode =
            temp.documentID;
        if (_data != null) {
          if (temp.documentID == _data.brandCode) {
            print(listBrandName[onData.documents.indexOf(temp)]
                .modelBrandName
                .modelEN
                .en);
            setState(() {
              txtBrandName.text = listBrandName[onData.documents.indexOf(temp)]
                  .modelBrandName
                  .modelEN
                  .en;
            });
          }
        }
        // print(
        //     "${listBrandName[onData.documents.indexOf(temp)].brandID} | ${listBrandName[onData.documents.indexOf(temp)].modelBrandName.modelEN.en}");
      }
    });
  }

  alerModel(String title, String content) {
    ecsLib.showDialogLib(context,
        title: "Warranzy",
        content: content ?? "",
        textOnButton: allTranslations.text("close"));
  }

  Widget formWidget({String title, Widget child, bool necessary = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "${title ?? "title's empty"} ${necessary == true ? "*" : ""} :",
          textAlign: TextAlign.center,
          style: TextStyleCustom.STYLE_CONTENT
              .copyWith(fontSize: 14, color: Colors.teal),
        ),
        child,
        Divider()
      ],
    );
  }

  Widget dropdownFormfield(
      {String initalData,
      List<String> items,
      Function onChange,
      bool validate = true}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: DropdownButtonFormField(
        validator: (s) {
          if (validate == true) if (s.isEmpty) {
            return "Invalide, Please enter data.";
          }
          return null;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          // border: InputBorder.none,
        ),
        value: initalData, //items.elementAt(0)
        items: items.isNotEmpty
            ? items.map((v) {
                return DropdownMenuItem(
                  value: v,
                  child: TextBuilder.build(title: "$v"),
                );
              }).toList()
            : [
                DropdownMenuItem(
                  child: TextBuilder.build(title: "-"),
                )
              ],
        onChanged: onChange,
      ),
    );
  }

  buttonEditInformation() {
    var postData = {
      "WTokenID": _data?.wTokenID ?? "",
      "CreateType": _data?.createType ?? "",
      "PdtCatCode": txtPdtCat.text,
      "PdtGroup": txtPdtGroup.text,
      "PdtPlace": txtPdtPlace.text,
      "BrandCode": txtBrandCode.text,
      "BrandActive": brandActive,
      "BrandName": txtBrandName.text,
      "Title": txtAssetName.text,
      "SerialNo": txtSerialNo.text,
      "LotNo": txtLotNo.text,
      "SalesPrice": txtPrice.text != null && txtPrice.text != ""
          ? int.parse(txtPrice.text)
          : 0,
      "WarrantyNo": txtWarranzyNo.text,
      "WarrantyExpire": txtWarranzyExpire.text,
      "SLCName": txtSLCName.text,
      "AlertDate": txtAlertDate.text,
      "CustRemark": txtNote.text,
    };
    ecsLib.printJson(postData);
    sendApiEdit(postData: postData);
  }

  sendApiEdit({postData}) async {
    try {
      ecsLib.showDialogLoadingLib(context, content: "Editing Detail Asset");
      await APIServiceAssets.updateData(postData: postData)
          .then((resEdit) async {
        ecsLib.cancelDialogLoadindLib(context);
        if (resEdit?.status == true) {
          ecsLib.showDialogLoadingLib(context, content: "Upload Detail Asset");
          await APIServiceAssets.getDetailAseet(wtokenID: _data.wTokenID)
              .then((resDetail) {
            ecsLib.cancelDialogLoadindLib(context);
            if (resDetail?.status == true) {
              ecsLib.cancelDialogLoadindLib(context);
              ecsLib.pushPageReplacement(
                context: context,
                pageWidget: DetailAsset(
                  dataAsset: resDetail.data,
                  showDetailOnline: true,
                ),
              );
            } else if (resDetail?.status == false) {
              alerModel("Warranzy", resDetail.message);
            } else {
              alerModel("Warranzy", resDetail.message);
            }
          });
        } else if (resEdit?.status == false) {
          alerModel("Warranzy", resEdit.message);
        } else {
          alerModel("Warranzy", resEdit.message);
        }
      });
    } catch (e) {
      print("Catch => $e");
    }
  }

  AutoCompleteTextField<GetBrandName> autoCompleteTextField() {
    return searchTextField = AutoCompleteTextField<GetBrandName>(
      key: keyAutoComplete,
      suggestions: listBrandName,
      clearOnSubmit: false,
      controller: txtBrandName,
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
          txtBrandCode.text = item.brandCode;
          print("BrandCode => ${txtBrandCode.text}");
          searchTextField.textField.controller.text =
              item.modelBrandName.modelEN.en;
          txtBrandName.text = item.modelBrandName.modelEN.en;
          brandActive = item.brandActive;
        });
      },
    );
  }

  Widget buildTextAutoComplete(GetBrandName item) => Container(
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextBuilder.build(
                  title: "${item.modelBrandName.modelEN.en}",
                  style: TextStyleCustom.STYLE_LABEL_BOLD),
            ),
            Divider()
          ],
        ),
      );
  Map<String, dynamic> postDataForAdd() {
    Map<String, dynamic> mapData = {
      "WarrantyNo": txtWarranzyNo.text,
      "WarrantyExpire": txtWarranzyExpire.text,
      "Title": txtAssetName.text,
      "PdtGroup": txtPdtGroup.text,
      "PdtPlace": txtPdtPlace.text,
      "PdtCatCode": txtPdtCat.text,
      "AlertDate": txtAlertDate.text,
      "BrandCode": txtBrandCode.text,
      "BrandName": txtBrandName.text,
      "BrandActive": brandActive,
      "SerialNo": txtSerialNo.text,
      "LotNo": txtLotNo.text,
      "SalesPrice": txtPrice.text == "" ? 0 : int.parse(txtPrice.text),
      "CustRemark": txtNote.text,
      "SLCName": txtSLCName.text,
      "CreateType":
          widget.onClickAddAssetPage == PageAction.MANUAL_ADD ? "C" : "T"
    };
    return mapData;
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
            _formKey.currentState.save();
            if (_formKey.currentState.validate()) {
              print(txtBrandName.text);
              if (txtBrandName.text == "") {
                ecsLib.showDialogLib(context,
                    content: "Invalide Brand Name.",
                    textOnButton: allTranslations.text("close"),
                    title: "Warranzy");
              } else if (txtWarranzyExpire.text == "") {
                ecsLib.showDialogLib(context,
                    content: "Invalide Warranty Expire.",
                    textOnButton: allTranslations.text("close"),
                    title: "Warranzy");
              } else {
                print(postDataForAdd());
                ecsLib.pushPage(
                  context: context,
                  pageWidget: AddImageDemo(
                    dataAsset: postDataForAdd(),
                  ),
                );
              }
            }
          }),
    );
  }
}
