import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:warranzy_demo/models/model_get_brand_name.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/page/asset_page/add_assets_page/scAdd_image_demo.dart';
import 'package:warranzy_demo/page/asset_page/detail_asset_page/scDetailAsset.dart';
import 'package:warranzy_demo/services/api/api_service_assets.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';

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
  TextEditingController txtSLCCode;

  // String _showDate = "-";
  // String _valueDate = "";
  String brandActive = "N";
  var valueBrandName = "DysonElectric";
  List<GetBrandName> listBrandName = [];
  List<String> listBrandID = [];
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
    if (_data != null) {
      brandActive = _data?.brandCode != null ? "Y" : "N";
      txtAssetName = TextEditingController(text: _data?.title ?? "");
      txtBrandName = TextEditingController(text: "");
      txtBrandCode = TextEditingController(text: _data?.brandCode ?? "");
      txtWarranzyNo = TextEditingController(text: _data?.warrantyNo ?? "");
      ButtonDatePickerCustom.setShowDate = _data?.warrantyExpire ?? "";
      txtWarranzyExpire =
          TextEditingController(text: ButtonDatePickerCustom.showDate);
      txtAlertDate =
          TextEditingController(text: _data?.alertDateNo.toString() ?? "");
      txtPdtCat = TextEditingController(text: _data?.pdtCatCode ?? "");
      txtPdtGroup = TextEditingController(text: _data?.pdtGroup ?? "");
      txtPdtPlace = TextEditingController(text: _data?.pdtPlace ?? "");
      txtPrice = TextEditingController(text: _data?.salesPrice ?? "");
      txtSerialNo = TextEditingController(text: _data?.serialNo ?? "");
      txtLotNo = TextEditingController(text: _data?.lotNo ?? "");
      txtNote = TextEditingController(text: _data?.custRemark ?? "");
      txtSLCCode = TextEditingController(text: _data?.custRemark ?? "");
    } else {
      brandActive = _data?.brandCode != null ? "Y" : "N";
      txtAssetName = TextEditingController(text: "");
      txtBrandName = TextEditingController(text: "");
      txtBrandCode = TextEditingController(text: "");
      txtWarranzyNo = TextEditingController(text: "");
      txtWarranzyExpire = TextEditingController(text: "");
      txtAlertDate = TextEditingController(text: "7");
      txtPdtCat = TextEditingController(text: "A001");
      txtPdtGroup = TextEditingController(text: _group.elementAt(0));
      txtPdtPlace = TextEditingController(text: _place.elementAt(0));
      txtPrice = TextEditingController(text: "");
      txtSerialNo = TextEditingController(text: "");
      txtLotNo = TextEditingController(text: "");
      txtNote = TextEditingController(text: "");
      txtSLCCode = TextEditingController(text: "");
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
    txtSLCCode?.dispose();
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
                if (actionPageForAdd == true) buildTitle(),
                SizedBox(
                  height: 20,
                ),
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
                    title: "Alert Date",
                    necessary: true,
                    child: dropdownFormfield(
                      initalData: txtAlertDate.text,
                      items: ["60", "30", "7", "0"],
                      onChange: (value) {
                        setState(() {
                          txtAlertDate.text = value;
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
                TextFieldBuilder.textFormFieldCustom(
                    controller: txtWarranzyNo,
                    necessary: true,
                    borderOutLine: false,
                    title: "Warranzy No"),
                formWidget(
                  title: "Warranzy Expire",
                  necessary: true,
                  child: ButtonDatePickerCustom.buttonDatePicker(context, () {
                    print(ButtonDatePickerCustom.showDate);
                    setState(() {
                      // _showDate = ButtonDatePickerCustom.showDate;
                      txtWarranzyExpire.text = ButtonDatePickerCustom.valueDate;
                    });
                  }),
                ),
                formWidget(
                  title: "Optional",
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100]),
                    padding: EdgeInsets.all(5),
                    child: ExpansionTile(
                      title: TextBuilder.build(title: ""),
                      children: <Widget>[
                        TextFieldBuilder.textFormFieldCustom(
                            controller: txtSLCCode,
                            borderOutLine: false,
                            validate: false,
                            title: "SCCCode"),
                        TextFieldBuilder.textFormFieldCustom(
                            controller: txtSerialNo,
                            validate: false,
                            borderOutLine: false,
                            title: "Serial No"),
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
                        printTxtController();
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
    ecsLib.showDialogLib(
        context: context,
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

  printTxtController() {
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
      "SalesPrice": txtPrice.text != null || txtPrice.text == ""
          ? int.parse(txtPrice.text)
          : 0,
      "WarrantyNo": txtWarranzyNo.text,
      "WarrantyExpire": txtWarranzyExpire.text,
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
  Map<String, dynamic> addTextController() {
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
              print(addTextController());
              ecsLib.pushPage(
                context: context,
                pageWidget: AddImageDemo(
                  dataAsset: addTextController(),
                ),
                //   // AddImage(
                //   //   hasDataAssetAlready: widget.hasDataAssetAlready,
                //   //   dataAsset: dataAsset,
                //   // ),
              );
            }
          }),
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
