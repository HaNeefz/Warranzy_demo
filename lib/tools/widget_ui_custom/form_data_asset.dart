import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:warranzy_demo/models/model_get_brand_name.dart';
import 'package:warranzy_demo/models/model_image_data_each_group.dart';
import 'package:warranzy_demo/models/model_repository_asset_scan.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/models/model_user.dart';
import 'package:warranzy_demo/page/asset_page/add_assets_page/scAdd_image_demo.dart';
import 'package:warranzy_demo/page/asset_page/detail_asset_page/scDetailAsset.dart';
import 'package:warranzy_demo/services/api/api_service_assets.dart';
import 'package:warranzy_demo/services/api/repository.dart';
import 'package:warranzy_demo/services/method/auto_completed.dart';
import 'package:warranzy_demo/services/method/scan_qr.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';

import '../assets.dart';
import '../const.dart';
import '../theme_color.dart';
import 'button_builder.dart';
import 'button_date_picker.dart';
import 'category_ui.dart';
import 'text_builder.dart';
import 'text_field_builder.dart';

class FormDataAsset extends StatefulWidget {
  final ModelDataAsset modelDataAsset;
  final bool actionPageForAdd;
  final PageAction onClickAddAssetPage;
  final List<ImageDataEachGroup> imageEachGroup;
  final List<Map<String, List<String>>> fileAttach;
  FormDataAsset(
      {Key key,
      this.modelDataAsset,
      this.actionPageForAdd,
      this.onClickAddAssetPage,
      this.imageEachGroup,
      this.fileAttach})
      : super(key: key);

  _FormDataAssetState createState() => _FormDataAssetState();
}

class _FormDataAssetState extends State<FormDataAsset> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  final _formKey = GlobalKey<FormState>();
  final Firestore firestore = Firestore();
  final ScrollController _scrollController = ScrollController();
  ModelDataAsset get _data => widget.modelDataAsset;
  bool get actionPageForAdd => widget.actionPageForAdd;
  final GlobalKey<AutoCompleteTextFieldState<GetBrandName>> keyAutoComplete =
      GlobalKey();
  AutoCompleteTextField searchTextField;
  final GlobalKey<AutoCompleteTextFieldState<String>> keyAutoCompleteGroup =
      GlobalKey();
  AutoCompleteTextField searchTextFieldGroup;
  final GlobalKey<AutoCompleteTextFieldState<String>> keyAutoCompletePlace =
      GlobalKey();
  AutoCompleteTextField searchTextFieldPlace;

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
  TextEditingController txtGeoLocation;

  String brandActive = "N";
  String keepOldBrand = "";
  var valueBrandName = "DysonElectric";
  List<GetBrandName> listBrandName = [];
  List<String> listBrandID = [];
  String dataTime = '';
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
  Map<String, dynamic> groupCatMap = {
    "GroupID": "",
    "GroupName": "",
    "Logo": ""
  };

  String labelCategory = "";
  String labelSubCategory = "";

  setGroupCatMap(Map<String, dynamic> map) {
    groupCatMap['GroupID'] = map['GroupID'];
    groupCatMap['GroupName'] = map['GroupName'];
    groupCatMap['Logo'] = map['Logo'];
    labelCategory = jsonDecode(groupCatMap['GroupName'])["EN"];
    print("groupCatMap => $labelCategory");
  }

  Map<String, dynamic> subCatMap = {"CatCode": "", "CatName": "", "Logo": ""};

  setSubCatMap(Map<String, dynamic> map) {
    subCatMap['CatCode'] = map['CatCode'];
    subCatMap['CatName'] = map['CatName'];
    subCatMap['Logo'] = map['Logo'];
    labelSubCategory = jsonDecode(subCatMap['CatName'])["EN"];
    print("subCatMap => $labelSubCategory");
  }

  String groupID;
  Future<List<ProductCategory>> getProductCategory;
  Future<List<GroupCategory>> getProductGroupCategory;

  String groupIDTest;
  List<Map<String, dynamic>> groupCatAll = [];
  List<Map<String, dynamic>> subCatAll = [];
  List<Map<String, dynamic>> tempgroupCat = [];
  List<Map<String, dynamic>> tempSubCat = [];

  List<Map<String, dynamic>> getDataCategoryInfo(
      {List<Map<String, dynamic>> listMap, String searchText}) {
    List<Map<String, dynamic>> result = [];
    listMap.forEach((v) {
      if (v.containsValue(searchText)) {
        // print(v);
        result.add(v);
      }
    });
    return result.isNotEmpty ? result : [];
  }

  initialCategoryTest(String code) async {
    print("code => $code");
    groupCatAll =
        await DBProviderInitialApp.db.getAllGroupCategoryTypeListMap();
    subCatAll = await DBProviderInitialApp.db.getAllSubCategoryTypeListMap();
    if (code.length > 1) {
      //SubCat
      print("code > 1");
      var _tempSubCat =
          getDataCategoryInfo(listMap: subCatAll, searchText: code);
      setState(() {
        tempgroupCat = List.of(groupCatAll);
        var _tempGroupCat = getDataCategoryInfo(
            listMap: groupCatAll, searchText: _tempSubCat.first['GroupID']);
        setGroupCatMap(_tempGroupCat.first);
        tempSubCat = getDataCategoryInfo(
            listMap: subCatAll, searchText: _tempSubCat.first['GroupID']);
        setSubCatMap(_tempSubCat.first);
      });
    } else {
      //Cat
      print("code < 1");
      setState(() {
        groupIDTest = code;
        tempgroupCat = List.of(groupCatAll);
        var _tempGroupCat =
            getDataCategoryInfo(listMap: groupCatAll, searchText: groupIDTest)
                .first;
        setGroupCatMap(_tempGroupCat);
        print("groupCatMap => $groupCatMap");
        var _tempSubCat =
            getDataCategoryInfo(listMap: subCatAll, searchText: groupIDTest);
        tempSubCat = _tempSubCat;
        setSubCatMap(_tempSubCat.first);
        txtPdtCat.text = _tempSubCat.first['CatCode'];
        print("subCatMap => $subCatMap");
      });
    }
  }

  initialCategory(String catCode) async {
    var getGroupCatID = await DBProviderInitialApp.db
        .getGroupCategoryByCatCode(catCode: catCode);
    setState(() {
      groupID = getGroupCatID;
    });
    initialSubCategory(groupID);
  }

  initialSubCategory(String groupID) async {
    getProductCategory =
        DBProviderInitialApp.db.getSubCategoryByGroupID(groupID: groupID);
  }

  @override
  void initState() {
    if (_data != null) {
      setState(() {
        initialCategoryTest(_data?.pdtCatCode);
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
            TextEditingController(text: _data?.alertDateNo?.toString() ?? "60");
        txtPdtCat = TextEditingController(text: _data?.pdtCatCode ?? "");
        txtPdtGroup = TextEditingController(text: _data?.pdtGroup ?? "");
        txtPdtPlace = TextEditingController(text: _data?.pdtPlace ?? "");
        txtPrice = TextEditingController(text: _data?.salesPrice ?? "");
        txtSerialNo = TextEditingController(text: _data?.serialNo ?? "");
        txtLotNo = TextEditingController(text: _data?.lotNo ?? "");
        txtNote = TextEditingController(text: _data?.custRemark ?? "");
        txtSLCName = TextEditingController(text: _data?.slcName ?? "");
        txtGeoLocation = TextEditingController(text: _data?.geoLocation ?? "");
      });
    } else {
      setState(() {
        initialCategoryTest("A");
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
        txtGeoLocation = TextEditingController(text: "");
      });
    }

    if (listBrandName.length == 0) {
      Future.delayed(Duration(milliseconds: 1500), () {
        getBrandName();
      });
    }
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
    txtGeoLocation.dispose();
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 50,
                        child: RaisedButton(
                            elevation: 0,
                            color: Colors.grey[100],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: showDataIndropdown(
                                  imgPath: groupCatMap['Logo'],
                                  label: labelCategory,
                                )),
                            onPressed: () async {
                              Map<String, dynamic> dataReturn =
                                  await ecsLib.pushPage(
                                      context: context,
                                      pageWidget: CategoryUI(
                                        title: "Category",
                                        category: tempgroupCat,
                                        selected: groupCatMap,
                                        showLogo: false,
                                      ));
                              if (dataReturn != null) {
                                setState(() {
                                  print(dataReturn);
                                  setGroupCatMap(dataReturn);
                                  tempSubCat = getDataCategoryInfo(
                                      listMap: subCatAll,
                                      searchText: dataReturn['GroupID']);
                                  setSubCatMap(tempSubCat.first);
                                  txtPdtCat.text = tempSubCat.first['CatCode'];
                                });
                              }
                            }),
                      ),
                    )),
                formWidget(
                    title: "Sub - Category",
                    necessary: true,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 50,
                        child: RaisedButton(
                            elevation: 0,
                            color: Colors.grey[100],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: showDataIndropdown(
                                    imgPath: subCatMap['Logo'],
                                    label: labelSubCategory)),
                            onPressed: () async {
                              Map<String, dynamic> dataReturn =
                                  await ecsLib.pushPage(
                                      context: context,
                                      pageWidget: CategoryUI(
                                        title: "Sub - Category",
                                        category: tempSubCat,
                                        selected: subCatMap,
                                        showLogo: false,
                                      ));
                              if (dataReturn != null) {
                                setState(() {
                                  setSubCatMap(dataReturn);
                                  txtPdtCat.text = dataReturn['CatCode'];
                                  print("dataGroup => $dataReturn");
                                  print("txtPdtCat.text => ${txtPdtCat.text}");
                                });
                              }
                            }),
                      ),
                    )),
                // formWidget(
                //     title: "Category Test",
                //     necessary: true,
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(10),
                //       child: Container(
                //         height: 50,
                //         child: showAlertDropDownCustoms(
                //             showContent: groupCatMap,
                //             titleInDropdown: "Category",
                //             dataOfDropdown: tempgroupCat,
                //             onSelected: (data) {
                //               setState(() {
                //                 print(data);
                //                 setGroupCatMap(data);
                //                 tempSubCat = getDataCategoryInfo(
                //                     listMap: subCatAll,
                //                     searchText: data['GroupID']);
                //                 setSubCatMap(tempSubCat.first);
                //                 txtPdtCat.text = tempSubCat.first['CatCode'];
                //               });
                //             }),
                //       ),
                //     )),
                // formWidget(
                //     title: "Sub - Category Test",
                //     necessary: true,
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(10),
                //       child: Container(
                //         height: 50,
                //         child: showAlertDropDownCustoms(
                //             showContent: subCatMap,
                //             titleInDropdown: "Sub-Category",
                //             dataOfDropdown: tempSubCat,
                //             onSelected: (data) {
                //               setState(() {
                //                 setSubCatMap(data);
                //                 txtPdtCat.text = data['CatCode'];
                //                 print("dataGroup => $data");
                //                 print("txtPdtCat.text => ${txtPdtCat.text}");
                //               });
                //             }),
                //       ),
                //     )),
                formWidget(
                    title: "Group",
                    necessary: true,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                            ),
                            child:
                                AutoCompletedCustom.autoCompleteTextFieldCustom(
                                    key: keyAutoCompleteGroup,
                                    controller: txtPdtGroup,
                                    suggestions: _group,
                                    returnWidget: searchTextFieldGroup,
                                    onSubmit: (word) {
                                      setState(() => txtPdtGroup.text = word);
                                    }),
                          ),
                        )),
                        // Expanded(
                        //   child: dropdownFormfield(
                        //     initalData: txtPdtGroup.text,
                        //     items: _group,
                        //     onChange: (value) {
                        //       setState(() {
                        //         txtPdtGroup.text = value;
                        //       });
                        //     },
                        //   ),
                        // ),
                      ],
                    )),
                formWidget(
                  title: "Place",
                  necessary: true,
                  child: Row(children: <Widget>[
                    Expanded(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                        ),
                        child: AutoCompletedCustom.autoCompleteTextFieldCustom(
                            key: keyAutoCompletePlace,
                            controller: txtPdtPlace,
                            suggestions: _place,
                            returnWidget: searchTextFieldPlace,
                            onSubmit: (word) {
                              setState(() => txtPdtPlace.text = word);
                            }),
                      ),
                    )),
                  ]),
                ),
                // dropdownFormfield(
                //   initalData: txtPdtPlace.text,
                //   items: [
                //     "Home",
                //     "Office",
                //     "School",
                //     "Kitchen",
                //   ],
                //   onChange: (value) {
                //     setState(() {
                //       txtPdtPlace.text = value;
                //     });
                //   },
                // ),

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

  showAlertDropDownCustoms(
      {Map<String, dynamic> showContent,
      String titleInDropdown,
      List<Map<String, dynamic>> dataOfDropdown,
      Function(Map<String, dynamic> data) onSelected}) {
    return RaisedButton(
        elevation: 0,
        color: Colors.grey[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Align(
            alignment: Alignment.centerLeft,
            child: showDataIndropdown(
                imgPath: showContent['Logo'],
                label: jsonDecode(
                    showContent['CatName'] ?? showContent['GroupName'])["EN"])),
        onPressed: () async {
          Map<String, dynamic> dataGroup = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 20.0),
                  content: Container(
                    width: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: TextBuilder.build(
                              title: titleInDropdown,
                              style: TextStyleCustom.STYLE_LABEL_BOLD),
                        ),
                        Divider(),
                        Container(
                          height: 300,
                          child: ListView(
                            shrinkWrap: true,
                            children: dataOfDropdown.map((v) {
                              return Container(
                                height: 45,
                                child: ListTile(
                                    leading: Image.asset("${v['Logo']}",
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.contain),
                                    title: Container(
                                      width: 140,
                                      child: AutoSizeText(
                                        jsonDecode(v['CatName'] ??
                                            v['GroupName'])["EN"],
                                        minFontSize: 10,
                                        stepGranularity: 10,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyleCustom.STYLE_LABEL
                                            .copyWith(fontSize: 13),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context, v);
                                    }),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
          if (dataGroup != null) {
            onSelected(dataGroup);
            // setState(() {
            //   setSubCatMap(dataGroup);
            //   txtPdtCat.text = dataGroup['CatCode'];
            //   print("dataGroup => $dataGroup");
            //   print("txtPdtCat.text => ${txtPdtCat.text}");
            // });
          }
        });
  }

  Widget showDataIndropdown({String imgPath, String label}) {
    return Container(
      width: 180,
      child: Row(
        children: <Widget>[
          // imgPath.length>0?
          // Image.asset(
          //   imgPath,
          //   width: 30,
          //   height: 30,
          //   fit: BoxFit.contain,
          // ): Icon(Icons.error, color: Colors.red),
          // CachedNetworkImage(
          //   imageUrl: imgUrl,
          //   imageBuilder: (context, imageProvider) => Container(
          //     width: 30,
          //     height: 30,
          //     decoration: BoxDecoration(
          //       image: DecorationImage(
          //         image: imageProvider,
          //         fit: BoxFit.contain,
          //       ),
          //     ),
          //   ),
          //   placeholder: (context, url) => Container(
          //     width: 30,
          //     height: 30,
          //     child: Center(child: CircularProgressIndicator()),
          //   ),
          //   errorWidget: (context, url, error) => Icon(Icons.error),
          // ),
          // SizedBox(width: 10),
          Container(
            width: 140,
            child: AutoSizeText(
              label,
              minFontSize: 10,
              stepGranularity: 10,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyleCustom.STYLE_LABEL.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  getBrandName() {
    firestore.collection('BrandName').getDocuments().then((onData) {
      if (listBrandName.length == 0) {
        print("FireStore add data");
        for (var temp in onData.documents) {
          String docID = temp.documentID;
          temp.data.addAll({"DocumentID": docID});
          listBrandName.add(GetBrandName.fromJson(temp.data));
          listBrandName[onData.documents.indexOf(temp)].brandCode =
              temp.documentID;
          if (_data != null) {
            if (temp.documentID == _data.brandCode) {
              print(listBrandName[onData.documents.indexOf(temp)]
                  .modelBrandName
                  .modelEN
                  .en);

              txtBrandName.text = listBrandName[onData.documents.indexOf(temp)]
                  .modelBrandName
                  .modelEN
                  .en;
            }
          }
        }
      } else
        print("listBrandName has data: ${listBrandName.length}");
    });
  }

  alerModel([String title, String content]) {
    ecsLib.showDialogLib(context,
        title: title ?? "Warranzy",
        content: content ?? "",
        textOnButton: allTranslations.text("close"));
  }

  alert({String title, String content}) => ecsLib.showDialogLib(context,
      content: content,
      textOnButton: allTranslations.text("close"),
      title: "ERROR STATUS");

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
    Map<String, dynamic> postData = {
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
          ? double.parse(txtPrice.text)
          : 0.0,
      "WarrantyNo": txtWarranzyNo.text,
      "WarrantyExpire": txtWarranzyExpire.text,
      "SLCName": txtSLCName.text,
      "AlertDate": txtAlertDate.text,
      "CustRemark": txtNote.text,
      "Geolocation": txtGeoLocation.text,
    };
    ecsLib.printJson(postData);
    sendApiEdit(postData: postData);
  }

  sendApiEdit({postData}) async {
    try {
      ecsLib.showDialogLoadingLib(context, content: "Editing Detail Asset");
      await Repository.updateData(body: postData).then((resEdit) async {
        ecsLib.cancelDialogLoadindLib(context);
        if (resEdit?.status == true) {
          ecsLib.showDialogLoadingLib(context, content: "Upload Detail Asset");
          await DBProviderAsset.db
              .updateDetailDataAsset(
                  wTokenID: _data.wTokenID,
                  warranzyUsed: resEdit.warranzyUsed,
                  warranzyLog: resEdit.warranzyLog)
              .then((resUpdated) async {
            if (resUpdated == true) {
              if (_data.createType == "C") {
                await DBProviderAsset.db
                    .getDataAssetByWTokenID(wTokenID: "${_data.wTokenID}")
                    .then((dataAsset) async {
                  if (dataAsset != null) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    await ecsLib.pushPageReplacement(
                        context: context,
                        pageWidget: DetailAsset(
                          dataAsset: dataAsset,
                          showDetailOnline: true,
                          dataScan: null,
                          listImage: widget.fileAttach,
                        ));
                  }
                });
              } else {
                try {
                  await Repository.getDetailAseet(
                      body: {"WTokenID": _data.wTokenID}).then((res) async {
                    ecsLib.cancelDialogLoadindLib(context);
                    if (res?.status == true) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ecsLib.pushPageReplacement(
                        context: context,
                        pageWidget: DetailAsset(
                          dataAsset: res.data,
                          showDetailOnline: true,
                          dataScan: res.dataScan,
                          listImage: widget.fileAttach,
                        ),
                      );
                    } else if (res.status == false) {
                      alerModel(
                          "status false : " + res?.message ?? "status false");
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      await ecsLib.pushPageReplacement(
                          context: context,
                          pageWidget: DetailAsset(
                            dataAsset: _data,
                            showDetailOnline: true,
                            dataScan: ModelDataScan(fileImageID: []),
                            listImage: widget.fileAttach,
                          ));
                    }
                  });
                } catch (e) {
                  alerModel("CATCH ERROR", "catch : $e");
                }
              }
            } else {
              await alerModel("Update fail", "Update incompleted.");
              print("update incompleted");
            }
          });
        } else if (resEdit?.status == false) {
          alerModel("Warranzy", resEdit.message);
        } else {
          alerModel("Warranzy", resEdit.message);
        }
      });
    } catch (e) {
      print("Catch outerSide=> $e");
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
          keepOldBrand = txtBrandName.text;
        });
      },
      textChanged: (text) {
        // print(text);
        // print(keepOldBrand);
        if (keepOldBrand == text) {
          brandActive = "Y";
          print("=");
          print("brandActive $brandActive");
        } else {
          brandActive = "N";
          print("!=");
          print("brandActive $brandActive");
        }
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
      "SalesPrice": txtPrice.text == "" ? "0" : txtPrice.text,
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
