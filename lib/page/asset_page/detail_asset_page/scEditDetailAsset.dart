import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_get_brand_name.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/services/api/api_service_assets.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_field_builder.dart';

import 'scDetailAsset.dart';

class EditDetailAsset extends StatefulWidget {
  final bool editingImage;
  final ModelDataAsset modelDataAsset;

  const EditDetailAsset({Key key, this.editingImage, this.modelDataAsset})
      : super(key: key);
  @override
  _EditDetailAssetState createState() => _EditDetailAssetState();
}

class _EditDetailAssetState extends State<EditDetailAsset> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  final Dio dio = Dio();
  bool get editor => widget.editingImage == true ? true : false;
  ModelDataAsset get _data => widget.modelDataAsset;
  Future<List<ProductCatagory>> getProductCategory;
  final GlobalKey<AutoCompleteTextFieldState<GetBrandName>> keyAutoComplete =
      GlobalKey();
  AutoCompleteTextField searchTextField;
  String brandActive;
  List<GetBrandName> listBrandName = [];
  List<String> listBrandID = [];
  final _fkey = GlobalKey<FormState>();
  TextEditingController txtAssetName;
  TextEditingController txtBrandName;
  TextEditingController txtBrandCode;
  TextEditingController txtWarranzyNo;
  TextEditingController txtWarranzyExpire;
  TextEditingController txtAlertDateNo;
  TextEditingController txtPdtCat;
  TextEditingController txtPdtGroup;
  TextEditingController txtPdtPlace;
  TextEditingController txtPrice;
  TextEditingController txtSerialNo;
  TextEditingController txtLotNo;
  TextEditingController txtNote;
  List<String> alertDate = ["60", "30", "7", "0"];

  @override
  void initState() {
    getProductCategory = DBProviderInitialApp.db.getAllDataProductCategory();
    brandActive = _data.brandCode != null ? "Y" : "N";
    txtAssetName = TextEditingController(text: _data.title ?? "");
    txtBrandName = TextEditingController(text: "");
    txtBrandCode = TextEditingController(text: _data.brandCode ?? "");
    txtWarranzyNo = TextEditingController(text: _data.warrantyNo ?? "");
    txtWarranzyExpire = TextEditingController(text: _data.warrantyExpire ?? "");
    txtAlertDateNo =
        TextEditingController(text: _data.alertDateNo.toString() ?? "");
    txtPdtCat = TextEditingController(text: _data.pdtCatCode ?? "");
    txtPdtGroup = TextEditingController(text: _data.pdtGroup ?? "");
    txtPdtPlace = TextEditingController(text: _data.pdtPlace ?? "");
    txtPrice = TextEditingController(text: _data.salesPrice ?? "");
    txtSerialNo = TextEditingController(text: _data.serialNo ?? "");
    txtLotNo = TextEditingController(text: _data.lotNo ?? "");
    txtNote = TextEditingController(text: _data.custRemark ?? "");

    Future.delayed(Duration(milliseconds: 1500), () {
      getBrandName();
    });

    super.initState();
  }

  void dispose() {
    txtAssetName.dispose();
    txtBrandCode.dispose();
    txtBrandName.dispose();
    txtWarranzyNo.dispose();
    txtWarranzyExpire.dispose();
    txtAlertDateNo.dispose();
    txtPdtCat.dispose();
    txtPdtGroup.dispose();
    txtPdtPlace.dispose();
    txtPrice.dispose();
    txtNote.dispose();
    txtSerialNo.dispose();
    txtLotNo.dispose();
    super.dispose();
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

  printTxtController() {
    var postData = {
      "WTokenID": _data.wTokenID,
      "CreateType": _data.createType,
      "PdtCatCode": txtPdtCat.text,
      "PdtGroup": txtPdtGroup.text,
      "PdtPlace": txtPdtPlace.text,
      "BrandCode": txtBrandCode.text,
      "BrandActive": brandActive,
      "BrandName": txtBrandName.text,
      "Title": txtAssetName.text,
      "SerialNo": txtSerialNo.text,
      "LotNo": txtLotNo.text,
      "SalesPrice": txtPrice.text != null || txtPrice.text == ""
          ? int.parse(txtPrice.text)
          : 0,
      "WarrantyNo": txtWarranzyNo.text,
      "WarrantyExpire": txtWarranzyExpire.text,
      "AlertDate": txtAlertDateNo.text,
      "CustRemark": txtNote.text,
    };
    ecsLib.printJson(postData);
    sendApiEdit(postData: postData);
  }

  sendApiEdit({postData}) async {
    try {
      ecsLib.showDialogLoadingLib(context, content: "Updating");
      await APIServiceAssets.editAseet(postData: postData)
          .then((resEdit) async {
        ecsLib.cancelDialogLoadindLib(context);
        if (resEdit?.status == true) {
          ecsLib.showDialogLoadingLib(context, content: "Loading Detail Asset");
          await APIServiceAssets.getDetailAseet(wtokenID: _data.wTokenID)
              .then((resDetail) {
            ecsLib.cancelDialogLoadindLib(context);
            if (resDetail?.status == true) {
              ecsLib.cancelDialogLoadindLib(context);
              ecsLib.pushPageReplacement(
                context: context,
                pageWidget: DetailAsset(
                  dataAsset: resDetail.data,
                ),
              );
            } else if (resDetail?.status == false) {
              ecsLib.showDialogLib(
                context: context,
                title: "Warranzy",
                content: resDetail.message ?? "",
                textOnButton: allTranslations.text("close"),
              );
            } else {
              ecsLib.showDialogLib(
                context: context,
                title: "Warranzy",
                content: resDetail.message ?? "",
                textOnButton: allTranslations.text("close"),
              );
            }
          });
        } else if (resEdit?.status == false) {
          ecsLib.showDialogLib(
            context: context,
            title: "Warranzy",
            content: resEdit.message ?? "",
            textOnButton: allTranslations.text("close"),
          );
        } else {
          ecsLib.showDialogLib(
            context: context,
            title: "Warranzy",
            content: resEdit.message ?? "",
            textOnButton: allTranslations.text("close"),
          );
        }
      });
    } catch (e) {
      print("Catch => $e");
    }
  }

  getBrandName() {
    Firestore.instance.collection('BrandName').snapshots().listen((onData) {
      for (var temp in onData.documents) {
        listBrandName.add(GetBrandName.fromJson(temp.data));
        listBrandName[onData.documents.indexOf(temp)].brandCode =
            temp.documentID;
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
        // print(
        //     "${listBrandName[onData.documents.indexOf(temp)].brandID} | ${listBrandName[onData.documents.indexOf(temp)].modelBrandName.modelEN.en}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: TextBuilder.build(
            title: "Edit Asset ${editor == true ? "Image" : "Data"}",
            style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: checkEdit(editor),
      ),
    );
  }

  Widget checkEdit(bool editorImage) {
    Widget child = Container();
    switch (editorImage) {
      case true:
        return editImage();
        break;
      case false:
        return editData();
        break;
      default:
        return child;
    }
  }

  Widget editImage() {
    return Container(
      child: Text("edit image"),
    );
  }

  Widget editData() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _fkey,
              child: Column(
                children: <Widget>[
                  TextFieldBuilder.textFormFieldCustom(
                      controller: txtAssetName,
                      borderOutLine: false,
                      title: "Asset Name"),
                  formWidget(
                    title: "Category",
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
                                    filled: true, fillColor: Colors.grey[100]),
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
                      title: "Alert Date",
                      child: dropdownFormfield(
                        initalData: txtAlertDateNo.text,
                        items: [
                          "60",
                          "30",
                          "7",
                          "0",
                        ],
                        onChange: (value) {
                          setState(() {
                            txtAlertDateNo.text = value;
                          });
                        },
                      )),
                  formWidget(
                      title: "Brand Name", child: autoCompleteTextField()),
                  TextFieldBuilder.textFormFieldCustom(
                      controller: txtWarranzyNo,
                      borderOutLine: false,
                      title: "Warranzy No"),
                  TextFieldBuilder.textFormFieldCustom(
                      controller: txtWarranzyExpire,
                      borderOutLine: false,
                      title: "Warranzy Expire"),
                  TextFieldBuilder.textFormFieldCustom(
                      controller: txtSerialNo,
                      borderOutLine: false,
                      validet: false,
                      title: "Serial No"),
                  TextFieldBuilder.textFormFieldCustom(
                      controller: txtLotNo,
                      borderOutLine: false,
                      validet: false,
                      title: "Lot No"),
                  TextFieldBuilder.textFormFieldCustom(
                      controller: txtPrice,
                      borderOutLine: false,
                      title: "Salse price"),
                  TextFieldBuilder.textFormFieldCustom(
                      controller: txtNote,
                      maxLine: 5,
                      borderOutLine: false,
                      validet: false,
                      title: "Note"),
                  ButtonBuilder.buttonCustom(
                    paddingValue: 5,
                    onPressed: () {
                      if (_fkey.currentState.validate()) {
                        printTxtController();
                      }
                    },
                    context: context,
                    label: "Edit",
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget formWidget({String title, Widget child}) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
                child: Center(
                    child: Text(
              "${title ?? "title's empty"}:",
              textAlign: TextAlign.center,
            ))),
            Expanded(
              flex: 3,
              child: child,
            ),
          ],
        ),
        Divider()
      ],
    );
  }

  Widget dropdownFormfield(
      {String initalData, List<String> items, Function onChange}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(filled: true, fillColor: Colors.grey[100]),
        value: initalData ?? "",
        items: items.isNotEmpty
            ? items.map((v) {
                return DropdownMenuItem<String>(
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
}
