import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_picker/flutter_picker.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:warranzy_demo/models/model_get_brand_name.dart';
import 'package:warranzy_demo/models/model_image_data_each_group.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/models/model_user.dart';
import 'package:warranzy_demo/page/asset_page/detail_asset_page/scDetailAsset.dart';
import 'package:warranzy_demo/page/asset_page/detail_asset_page/scEditDetailAsset.dart';
import 'package:warranzy_demo/page/main_page/scMain_page.dart';
import 'package:warranzy_demo/services/api/api_service_assets.dart';
import 'package:warranzy_demo/services/api/repository.dart';
import 'package:warranzy_demo/services/method/scan_qr.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/category_ui.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/take_a_photo.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_field_builder.dart';

enum PageType { MANUAL, SCANQR }

class FormDataAssetTest extends StatefulWidget {
  final ModelDataAsset modelDataAsset;
  final bool actionPageForAdd;
  final PageType pageType;
  final bool editImageForAdd;
  final String categoryID;
  final List<ImageDataEachGroup> listImageDataEachGroup;
  FormDataAssetTest(
      {Key key,
      this.modelDataAsset,
      this.actionPageForAdd,
      this.pageType = PageType.MANUAL,
      this.listImageDataEachGroup = const [],
      this.editImageForAdd,
      this.categoryID})
      : super(key: key);

  _FormDataAssetTestState createState() => _FormDataAssetTestState();
}

class _FormDataAssetTestState extends State<FormDataAssetTest> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  ModelDataAsset get _data => widget.modelDataAsset;
  bool get actionPageForAdd => widget.actionPageForAdd;
  List<ImageDataEachGroup> get listImageEachGroup =>
      widget.listImageDataEachGroup;
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

  String geoLocation = '';
  String brandActive = "N";
  var valueBrandName = "DysonElectric";
  List<GetBrandName> listBrandName = [];
  List<String> listBrandID = [];
  String dataTime = '';
  String titleAppBar = '';

  RelatedImage relatedImage;
  List<ImageDataEachGroup> listTempData;
  List<String> listRelated = [];
  List<String> tempListRelated = [];
  List<String> imageOld = [];
  Future<List<ProductCategory>> getProductCategory;
  List<Uint8List> getIconsProductCategory;
  Future<List<GroupCategory>> getProductGroupCategory;

  List<ImageDataEachGroup> _listTempData = [];

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
  String labelCategory = "";
  String labelSubCategory = "";
  String pathLogo = "";

  Map<String, dynamic> groupCatMap = {
    "GroupID": "",
    "GroupName": "",
    "Logo": ""
  };

  setGroupCatMap(Map<String, dynamic> map) {
    setState(() {
      groupCatMap['GroupID'] = map['GroupID'];
      groupCatMap['GroupName'] = map['GroupName'];
      groupCatMap['Logo'] = map['Logo'];

      labelCategory = jsonDecode(groupCatMap['GroupName'])["EN"];
      print("groupCatMap => $labelCategory");
      pathLogo = groupCatMap['Logo'];
    });
  }

  Map<String, dynamic> subCatMap = {"CatCode": "", "CatName": "", "Logo": ""};

  setSubCatMap(Map<String, dynamic> map) {
    setState(() {
      subCatMap['CatCode'] = map['CatCode'];
      subCatMap['CatName'] = map['CatName'];
      subCatMap['Logo'] = map['Logo'];
      labelSubCategory = jsonDecode(subCatMap['CatName'])["EN"];
      print("subCatMap => $labelSubCategory");
      pathLogo = subCatMap['Logo'];
    });
  }

  String groupID;
  String groupIDTest;
  String groupCatName;
  String subCatName;
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
      print("code > 1");
      var _tempSubCat =
          getDataCategoryInfo(listMap: subCatAll, searchText: code);

      tempgroupCat = List.of(groupCatAll);
      var _tempGroupCat = getDataCategoryInfo(
          listMap: groupCatAll, searchText: _tempSubCat.first['GroupID']);
      setGroupCatMap(_tempGroupCat.first);
      tempSubCat = getDataCategoryInfo(
          listMap: subCatAll, searchText: _tempSubCat.first['GroupID']);
      setSubCatMap(_tempSubCat.first);
    } else {
      print("code < 1");

      groupIDTest = code;
      tempgroupCat = List.of(groupCatAll);
      var _tempGroupCat =
          getDataCategoryInfo(listMap: groupCatAll, searchText: groupIDTest)
              .first;
      setGroupCatMap(_tempGroupCat);
      // print("groupCatMap => $groupCatMap");
      var _tempSubCat =
          getDataCategoryInfo(listMap: subCatAll, searchText: groupIDTest);
      tempSubCat = _tempSubCat;
      setSubCatMap(_tempSubCat.first);
      txtPdtCat.text = _tempSubCat.first['CatCode'];
      // print("subCatMap => $subCatMap");

    }
  }

  List<Map<String, dynamic>> initialGroupCategoryTest(String groupID) {
    //get All GroupCat to declare tempGroup
    List<Map<String, dynamic>> tempgroup =
        getDataCategoryInfo(listMap: groupCatAll, searchText: groupID);
    return tempgroup.isNotEmpty ? tempgroup : [];
  }

  @override
  void initState() {
    // if (SchedulerBinding.instance.schedulerPhase ==
    //     SchedulerPhase.persistentCallbacks) {}
    listImageEachGroup.forEach((v) {
      print("title : ${v.title}");
      print("imageList : ${v.imagesList}");
      print("imageBase64 : ${v.imageBase64}");
      print("tempBase64 : ${v.tempBase64.length}");
      print("-----------");
    });
    listTempData = List.of(listImageEachGroup ?? []);
    if (_data != null) {
      setState(() {
        brandActive = _data?.brandCode != null ? "Y" : "N";
        txtAssetName = TextEditingController(text: _data?.title ?? "");
        txtBrandName = TextEditingController(text: _data?.brandCode ?? "");
        txtBrandCode = TextEditingController(text: _data?.brandCode ?? "");
        txtWarranzyNo = TextEditingController(text: _data?.warrantyNo ?? "");
        txtWarranzyExpire =
            TextEditingController(text: _data?.warrantyExpire ?? "");
        dataTime = txtWarranzyExpire.text;
        txtAlertDate =
            TextEditingController(text: _data?.alertDateNo.toString() ?? "");
        if (_data?.groupCat != null) groupIDTest = _data?.groupCat;
        txtPdtCat = TextEditingController(text: _data?.pdtCatCode ?? "");
        txtPdtGroup =
            TextEditingController(text: _data?.pdtGroup ?? _group.first);
        txtPdtPlace =
            TextEditingController(text: _data?.pdtPlace ?? _place.first);
        txtPrice = TextEditingController(text: _data?.salesPrice ?? "");
        txtSerialNo = TextEditingController(text: _data?.serialNo ?? "");
        txtLotNo = TextEditingController(text: _data?.lotNo ?? "");
        txtNote = TextEditingController(text: _data?.custRemark ?? "");
        txtSLCName = TextEditingController(text: _data?.slcName ?? "");
        initialCategoryTest(_data?.pdtCatCode);
      });
    } else {
      setState(() {
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
        initialCategoryTest("A");
      });
    }
    if (widget.actionPageForAdd == true) {
      titleAppBar = "New Asset";
      print("Add Asset => $actionPageForAdd");
      getProductCat(txtPdtCat.text);
    } else {
      titleAppBar = "Edit Asset Data";
      print("Edit Asset => $actionPageForAdd");
      getProductCat();
      // getImageToBase64();
    }
    txtPdtCat.addListener(() {
      print("ADdListener => ${txtPdtCat.text}");
      if (widget.actionPageForAdd == true) {
        setState(() {
          listTempData.clear();
          _listTempData.clear();
          listImageEachGroup.clear();
          getProductCat(txtPdtCat.text);
        });
      }
    });
    Future.delayed(Duration(milliseconds: 1500), () {
      getBrandName();
    });

    super.initState();
  }

  // getBrandName() async {
  //   List<GetBrandName> tempAllBrand =
  //       await DBProviderAsset.db.getAllBrandName();
  //   setState(() => listBrandName = List.of(tempAllBrand));
  //   // listBrandName = List.of(tempAllBrand);
  //   print("tempAllBrand => ${tempAllBrand.length}");
  //   print("listBrandName => ${listBrandName.length}");
  //   tempAllBrand.forEach((v) {
  //     setState(() => listBrandID.add(v.documentID));
  //   });
  //   print("listBrandID ${listBrandID.length}");
  //   await getBrandNameEN();
  // }

  // getBrandNameEN() async {
  //   var _brandName = await DBProviderAsset.db.getBrandName(_data.brandCode);
  //   setState(() {
  //     print("brandName => $_brandName");
  //     txtBrandName.text = _brandName;
  //   });
  // }

  getProductCat([String categoryID]) async {
    var res = await DBProviderInitialApp.db
        .getDataProductCategoryByID(categoryID ?? _data.pdtCatCode);
    relatedImage = RelatedImage(category: res);
    listRelated = relatedImage.listRelatedImage();
    tempListRelated = List.of(listRelated);
    print("Related => $tempListRelated");
    for (var tempData in listTempData) {
      print("${listTempData.indexOf(tempData)} => ${tempData.title}");
      for (var tempReleted in listRelated) {
        if (tempReleted == tempData.title) {
          // setState(() {
          tempListRelated.removeAt(tempListRelated.indexOf(tempReleted));
          print("rm => $tempListRelated");
          // });
        }
      }
    }
    tempListRelated.forEach((v) {
      listTempData.add(ImageDataEachGroup(
          title: v,
          imageUrl: [],
          imageBase64: [],
          imagesList: [],
          imageUint8List: [],
          tempBase64: []));

      _listTempData.add(ImageDataEachGroup(
          title: v,
          imageUrl: [],
          imageBase64: [],
          imagesList: [],
          imageUint8List: [],
          tempBase64: []));
    });
    print("compact => $listRelated");
  }

  Future<List<Uint8List>> getImageToUint8List() async {
    List<Uint8List> listImage = [];
    for (int i = 0; i < listTempData.length; i++) {
      for (int j = 0; j < listTempData[i].imageUrl.length; j++) {
        try {
          var response = await http.get(listTempData[i].imageUrl[j]);
          listImage.add(response.bodyBytes);
        } catch (e) {
          print(e);
        }
      }
    }
    return listImage;
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

  int _currentStep = 0;
  bool complete = false;
  next() {
    if (actionPageForAdd == true) {
      if (_currentStep + 1 != _myStepForAdd().length)
        goTo(_currentStep + 1);
      else {
        setState(() {
          complete = true;
        });
        print("Completed, check fields.");
        saveInformation();
      }
    } else {
      // if (_currentStep + 1 != _myStepForEdit().length)
      //   goTo(_currentStep + 1);
      // else {
      //   setState(() {
      //     complete = true;
      //   });
      //   print("Completed, check fields.");
      //   saveInformation();
      // }
    }
  }

  void saveInformation() async {
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
      } else if (txtAssetName.text == "") {
        ecsLib.showDialogLib(context,
            content: "Invalide Asset Name.",
            textOnButton: allTranslations.text("close"),
            title: "Warranzy");
      } else {
        var createType = '';
        if (_data == null) {
          if (widget.pageType == PageType.MANUAL)
            createType = "C";
          else
            createType = "T";
        } else {
          createType =
              widget.pageType == PageType.MANUAL ? "C" : _data.createType;
        }
        var postData = {
          "WTokenID": _data?.wTokenID ?? "",
          "CreateType": createType,
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
              ? double.parse(txtPrice.text).toStringAsFixed(2)
              : 0.00,
          "WarrantyNo": txtWarranzyNo.text,
          "WarrantyExpire": txtWarranzyExpire.text,
          "SLCName": txtSLCName.text,
          "AlertDate": txtAlertDate.text,
          "CustRemark": txtNote.text,
          "Geolocation": geoLocation
        };
        // ecsLib.printJson(postData);

        if (actionPageForAdd == true) {
          if (checkImageisEmpty() == true) {
            await ecsLib.showDialogLib(context,
                title: "IMAGE IS EMPTY",
                content: "Please add some image.",
                textOnButton: allTranslations.text("close"));
          } else {
            await ecsLib
                .showDialogTripleAction(
              context,
              content: "Are you sure you want to add asset ?",
              labelFisrt: "Save",
              labelSecond: "Save and Duplicate",
              labelThird: allTranslations.text("cancel"),
            )
                .then((response) async {
              if (response == "F") {
                print(response);
                await setFormatDataBeforSendApi(
                  postData,
                ).then((body) async {
                  ecsLib.printJson(body);
                  await sendApiAddAsset(
                      body: body,
                      whenCompleted: () => ecsLib.pushPageAndClearAllScene(
                          context: context, pageWidget: MainPage()));
                });
              } else if (response == "S") {
                print(response);
                await setFormatDataBeforSendApi(
                  postData,
                ).then((body) async {
                  ecsLib.printJson(body);
                  await sendApiAddAsset(
                      body: body,
                      whenCompleted: () async {
                        await ecsLib.showDialogLib(
                          context,
                          title: "Warranzy",
                          content: "Added asset and Duplicated data.",
                          textOnButton: allTranslations.text("ok"),
                        );
                      });
                });
              } else {
                print(response);
              }
            });
          }
        } else
          sendApiEdit(postData: postData);
      }
    }
  }

  bool checkImageisEmpty() {
    bool isEmpty = true;
    listTempData.forEach((v) {
      if (v.tempBase64.length > 0) {
        isEmpty = false;
      }
    });
    return isEmpty;
  }

  Future<Map<String, dynamic>> setFormatDataBeforSendApi(
      Map<String, dynamic> postData) async {
    var imageData = {};
    var dataPost = {"Data": postData, "Images": {}};
    for (var modelImage in listTempData) {
      // print("title : ${modelImage.title}");
      // print("iamgeList : ${modelImage.imagesList}");
      // print("imageBase64 : ${modelImage.imageBase64}");
      // print("tempBase64 : ${modelImage.tempBase64}");
      // String tempBase64;
      imageData.addAll({"${modelImage.title}": {}});
      for (var imageBase64Data in modelImage.tempBase64) {
        imageData["${modelImage.title}"].addAll({
          "${modelImage.tempBase64.indexOf(imageBase64Data)}": imageBase64Data
        });
      }
    }
    dataPost.addAll({"Images": imageData});
    return dataPost;
  }

  Future sendApiAddAsset({body, Function whenCompleted}) async {
    ecsLib.showDialogLoadingLib(context, content: "Adding assets");
    try {
      await Repository.addAsset(body: body).then((res) async {
        ecsLib.cancelDialogLoadindLib(context);
        if (res.status == true) {
          try {
            await DBProviderAsset.db
                .insertDataWarranzyUesd(res.warranzyUsed)
                .catchError((onError) => print("warranzyUsed : $onError"));
          } catch (e) {
            print("insertDataWarranzyUesd => $e");
          }
          try {
            await DBProviderAsset.db
                .insertDataWarranzyLog(res.warranzyLog)
                .catchError((onError) => print("warranzyLog $onError"));
          } catch (e) {
            print("insertDataWarranzyLog => $e");
          }
          if (txtBrandCode.text == null || txtBrandCode.text == "") {
            try {
              await DBProviderAsset.db
                  .inserDataBrand(res.brand)
                  .catchError((onError) => print("Insert Name brand $onError"));
            } catch (e) {
              print("Insert Name brand $e");
            }
          }
          res.filePool.forEach((data) async {
            try {
              await DBProviderAsset.db
                  .insertDataFilePool(data)
                  .catchError((onError) => print("filePool $onError"))
                  .whenComplete(whenCompleted);
            } catch (e) {
              print("insertDataFilePool => $e");
            }
          });
        } else if (res.status == false) {
          ecsLib.showDialogLib(context,
              title: "FAIL ADD ASSET",
              content: res.message ?? "Somthing wrong !. status fail",
              textOnButton: allTranslations.text("close"));
        } else {
          ecsLib.showDialogLib(context,
              title: "FAIL ADD ASSET",
              content: res.message ?? "Somthing wrong !.",
              textOnButton: allTranslations.text("close"));
        }
      }).catchError((e) {
        print("$e");
        ecsLib.cancelDialogLoadindLib(context);
      });
    } on DioError catch (error) {
      print("DIO ERROR => ${error.error}\nMsg => ${error.message}");
      ecsLib.cancelDialogLoadindLib(context);
    } catch (e) {
      print("Catch $e");
      ecsLib.cancelDialogLoadindLib(context);
    }
  }

  Widget buttonAlert({String label, Function onPressed, Color colors}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ButtonBuilder.buttonCustom(
        context: context,
        label: label,
        paddingValue: 5,
        labelStyle: TextStyleCustom.STYLE_LABEL_BOLD
            .copyWith(color: ThemeColors.COLOR_WHITE),
        colorsButton: colors,
        onPressed: onPressed,
      ),
    );
  }

  cancel() {
    if (_currentStep > 0) {
      goTo(_currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextBuilder.build(
            title: titleAppBar, style: TextStyleCustom.STYLE_APPBAR),
        actions: <Widget>[
          // RaisedButton(
          //   child: Text("Clear SQLite"),
          //   onPressed: () async {
          //     await DBProviderAsset.db.deleteAllAsset();
          //     // print(await DBProviderCustomer.db.getSpecialPass());
          //   },
          // ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: ecsLib.dismissedKeyboard(
          context,
          child: Form(
            key: _formKey,
            autovalidate: true,
            child: KeyboardAvoider(
              child: Stepper(
                  currentStep: _currentStep,
                  onStepContinue: next,
                  onStepCancel: cancel,
                  onStepTapped: (step) => goTo(step),
                  steps: _myStepForAdd()),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetialEachGroup(ImageDataEachGroup data, {bool edit = false}) {
    // print("buildDetialEachGroup edit : $edit");
    return Column(
      children: <Widget>[
        ListTile(
          title: Text("${data.title}"),
          trailing: Container(
            // color: Colors.red,
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //"${edit == false ? data.imagesList.length : data.imageUrl.length + data.imagesList.length}\t\titems"
                Text(
                    "${edit == false ? data.tempBase64.length == 0 ? data.imageBase64.length : data.tempBase64.length : "Something"}\t\titems"),
                Icon(edit == true ? Icons.edit : Icons.add_circle),
              ],
            ),
          ),
          onTap: () async {
            ImageDataEachGroup images = await ecsLib.pushPage(
                context: context,
                pageWidget: TakePhotos(
                  title: data.title,
                  imageEachGroup: data,
                ));

            if (images != null) {
              setState(() {
                data = images;
              });
              print("title : ${data.title}");
              print("imageListFile : ${data.imagesList}");
              print("imageBase64 : ${data.imageBase64}");
              print("tempBase64 : ${data.tempBase64.length}");
            }
          },
        ),
        Divider()
      ],
    );
  }

  getBrandName() {
    Firestore.instance.collection('BrandName').snapshots().listen((onData) {
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
            setState(() {
              txtBrandName.text = listBrandName[onData.documents.indexOf(temp)]
                  .modelBrandName
                  .modelEN
                  .en;
            });
          }
        }
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

  Widget showDataIndropdown({String imgPath, String label}) {
    return Container(
      width: 180,
      child: Row(
        children: <Widget>[
          imgPath.length > 0
              ? Image.asset(
                  imgPath,
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                )
              : Icon(Icons.error, color: Colors.red),
          SizedBox(width: 10),
          Container(
            width: 140,
            child: AutoSizeText(
              label ?? "empty",
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
          ? double.parse(txtPrice.text).toStringAsFixed(2)
          : 0.00,
      "WarrantyNo": txtWarranzyNo.text,
      "WarrantyExpire": txtWarranzyExpire.text,
      "SLCName": txtSLCName.text,
      "AlertDate": txtAlertDate.text,
      "CustRemark": txtNote.text,
      "Geolocation": geoLocation
    };
    ecsLib.printJson(postData);
    sendApiEdit(postData: postData);
  }

  sendApiEdit({postData}) async {
    ecsLib
        .showDialogAction(context,
            title: "Warranzy",
            content: "Are you sure to update asset data.",
            textOk: allTranslations.text("ok"),
            textCancel: allTranslations.text("cancel"))
        .then((response) async {
      if (response == true) {
        try {
          ecsLib.showDialogLoadingLib(context, content: "Editing Detail Asset");
          await Repository.updateData(body: postData).then((resEdit) async {
            ecsLib.cancelDialogLoadindLib(context);
            if (resEdit?.status == true) {
              ecsLib.showDialogLoadingLib(context,
                  content: "Upload Detail Asset");
              await Repository.getDetailAseet(
                  body: {"wtokenID": "${_data.wTokenID}"}).then((resDetail) {
                ecsLib.cancelDialogLoadindLib(context);
                if (resDetail?.status == true) {
                  ecsLib.cancelDialogLoadindLib(context);
                  ecsLib.pushPageReplacement(
                    context: context,
                    pageWidget: DetailAsset(
                      dataAsset: resDetail.data,
                      dataScan: resDetail.dataScan,
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
    });
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
      "SalesPrice": txtPrice.text == "" ? 0.00 : double.parse(txtPrice.text),
      "CustRemark": txtNote.text,
      "SLCName": txtSLCName.text,
      "CreateType": widget.pageType == PageType.MANUAL ? "C" : "T",
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
                // ecsLib.pushPage(
                //   context: context,
                //   pageWidget: AddImageDemo(
                //     dataAsset: postDataForAdd(),
                //   ),
                // );
              }
            }
          }),
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

  List<Step> _myStepForAdd() {
    List<Step> _step = [
      Step(
        title: TextBuilder.build(
            title: "Asset Name", style: TextStyleCustom.STYLE_LABEL_BOLD),
        content: TextFieldBuilder.textFormFieldCustom(
            controller: txtAssetName,
            borderOutLine: false,
            necessary: true,
            validate: true,
            title: "Asset Name"),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: TextBuilder.build(
            title: "Category", style: TextStyleCustom.STYLE_LABEL_BOLD),
        content: Column(
          children: <Widget>[
            // formWidget(
            //     title: "Category",
            //     necessary: true,
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(10),
            //       child: DropdownButtonFormField(
            //           decoration: InputDecoration(
            //               // border: InputBorder.none,
            //               filled: true,
            //               fillColor: Colors.grey[100]),
            //           value: groupIDTest,
            //           items: tempgroupCat.map((v) {
            //             return DropdownMenuItem(
            //               value: v['GroupID'],
            //               child: showDataIndropdown(
            //                   imgPath: v['Logo'],
            //                   label:
            //                       "${jsonDecode(v['GroupName'])['EN'] ?? ""}"),
            //             );
            //           }).toList(),
            //           onChanged: (value) {
            //             print(value);
            //             setState(() {
            //               // groupIDTest = value;
            //               // print("valueChange => $value");
            //               // tempSubCat = getDataCategoryInfo(
            //               //     listMap: subCatAll, searchText: value);
            //               // txtPdtCat.text = tempSubCat.first['CatCode'];
            //               print(value);
            //               setGroupCatMap(value);
            //               tempSubCat = getDataCategoryInfo(
            //                   listMap: subCatAll, searchText: value['GroupID']);
            //               setSubCatMap(tempSubCat.first);
            //               txtPdtCat.text = tempSubCat.first['CatCode'];
            //             });
            //           }),
            //     )),
            // formWidget(
            //     title: "Sub - Category",
            //     necessary: true,
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(10),
            //       child: DropdownButtonFormField(
            //           decoration: InputDecoration(
            //               // border: InputBorder.none,
            //               filled: true,
            //               fillColor: Colors.grey[100]),
            //           value: txtPdtCat.text,
            //           items: tempSubCat.map((v) {
            //             return DropdownMenuItem(
            //               value: v['CatCode'],
            //               child: showDataIndropdown(
            //                   imgPath: v['Logo'],
            //                   label:
            //                       "${jsonDecode(v['CatName'])['EN'] ?? "Eieie"}"),
            //             );
            //           }).toList(),
            //           onChanged: (value) {
            //             print(value);
            //             setState(() {
            //               setGroupCatMap(value);
            //               tempSubCat = getDataCategoryInfo(
            //                   listMap: subCatAll, searchText: value['GroupID']);
            //               setSubCatMap(tempSubCat.first);
            //               txtPdtCat.text = tempSubCat.first['CatCode'];
            //             });
            //             // txtPdtCat.text = value;
            //           }),
            //     )),
            //----------------
            // formWidget(
            //     title: "Category",
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
            //     title: "Sub - Category",
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
            //----------------
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
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: TextBuilder.build(
            title: "Brand Name, Group and Place",
            style: TextStyleCustom.STYLE_LABEL_BOLD),
        content: Column(
          children: <Widget>[
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
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: TextBuilder.build(
            title: "Warranty Info", style: TextStyleCustom.STYLE_LABEL_BOLD),
        content: Column(
          children: <Widget>[
            TextFieldBuilder.textFormFieldCustom(
                controller: txtWarranzyNo,
                borderOutLine: false,
                validate: false,
                title: "Warranty No"),
            formWidget(
                title: "Warranty Expire",
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
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: TextBuilder.build(
            title: "Optional", style: TextStyleCustom.STYLE_LABEL_BOLD),
        content: formWidget(
          title: "Optional",
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: Colors.grey[100]
            ),
            padding: EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                TextFieldBuilder.textFormFieldCustom(
                    controller: txtSLCName,
                    borderOutLine: false,
                    validate: false,
                    title: "SLCName"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextFieldBuilder.textFormFieldCustom(
                          controller: txtSerialNo,
                          validate: false,
                          borderOutLine: false,
                          title: "Serial No"),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                        onTap: () async {
                          print("ScanBarCode or QR");
                          var dataScan = await MethodLib.scanQR(context);
                          if (dataScan != null)
                            setState(() {
                              txtSerialNo.text = dataScan;
                            });
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset(Assets.ICON_BARCODE,
                                width: 35, height: 35),
                            // TextBuilder.build(
                            //     title: "Scan",
                            //     style: TextStyleCustom.STYLE_LABEL
                            //         .copyWith(fontSize: 10))
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
                TextFieldBuilder.textFormFieldCustom(
                    controller: txtNote,
                    validate: false,
                    maxLine: 5,
                    borderOutLine: false,
                    title: "Note"),
              ],
              // ExpansionTile(
              //   title: TextBuilder.build(title: ""),
              //   children: <Widget>[

              //   ],
            ),
          ),
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: TextBuilder.build(
            title: "Image Asset", style: TextStyleCustom.STYLE_LABEL_BOLD),
        content: Column(
          children: listTempData
              .map((v) => buildDetialEachGroup(v,
                  edit: actionPageForAdd == true ? false : true))
              .toList(),
        ),
      )
    ];
    return _step;
  }

  // List<Step> _myStepForEdit() {
  //   List<Step> _step = [
  //     Step(
  //       title: TextBuilder.build(
  //           title: "Asset Name", style: TextStyleCustom.STYLE_LABEL_BOLD),
  //       content: TextFieldBuilder.textFormFieldCustom(
  //           controller: txtAssetName,
  //           borderOutLine: false,
  //           necessary: true,
  //           validate: true,
  //           title: "Asset Name"),
  //       isActive: _currentStep >= 0,
  //     ),
  //     Step(
  //       title: TextBuilder.build(
  //           title: "Category", style: TextStyleCustom.STYLE_LABEL_BOLD),
  //       content: Column(
  //         children: <Widget>[
  //           formWidget(
  //             title: "Category",
  //             necessary: true,
  //             child: FutureBuilder<List<ProductCategory>>(
  //               future: getProductCategory,
  //               builder: (BuildContext context,
  //                   AsyncSnapshot<List<ProductCategory>> snapshot) {
  //                 if (snapshot.connectionState == ConnectionState.done) {
  //                   if (!(snapshot.hasError)) {
  //                     return ClipRRect(
  //                       borderRadius: BorderRadius.circular(10),
  //                       child: DropdownButtonFormField(
  //                         decoration: InputDecoration(
  //                             // border: InputBorder.none,
  //                             filled: true,
  //                             fillColor: Colors.grey[100]),
  //                         value: txtPdtCat.text,
  //                         items: snapshot.data.map((v) {
  //                           return DropdownMenuItem(
  //                             value: v.catCode,
  //                             child: TextBuilder.build(
  //                                 title: "${v.catName}",
  //                                 style: TextStyleCustom.STYLE_LABEL
  //                                     .copyWith(fontSize: 15),
  //                                 maxLine: 1,
  //                                 textOverflow: TextOverflow.ellipsis),
  //                           );
  //                         }).toList(),
  //                         onChanged: (value) => setState(() {
  //                           txtPdtCat.text = value;
  //                           print(txtPdtCat.text);
  //                         }),
  //                       ),
  //                     );
  //                   } else {
  //                     return TextBuilder.build(title: "Error data");
  //                   }
  //                 } else if (snapshot.connectionState ==
  //                     ConnectionState.waiting) {
  //                   return CircularProgressIndicator();
  //                 } else {
  //                   return TextBuilder.build(title: "Something Wrong.");
  //                 }
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //       isActive: _currentStep >= 0,
  //     ),
  //     Step(
  //       title: TextBuilder.build(
  //           title: "Brand Name, Group and Place",
  //           style: TextStyleCustom.STYLE_LABEL_BOLD),
  //       content: Column(
  //         children: <Widget>[
  //           formWidget(
  //               title: "Brand Name",
  //               necessary: true,
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(10),
  //                 child: Container(
  //                     height: 55,
  //                     decoration: BoxDecoration(
  //                       color: Colors.grey[100],
  //                     ),
  //                     child: autoCompleteTextField()),
  //               )),
  //           formWidget(
  //               title: "Group",
  //               necessary: true,
  //               child: dropdownFormfield(
  //                 initalData: txtPdtGroup.text,
  //                 items: [
  //                   "Car",
  //                   "Living Room",
  //                   "Meeting Room",
  //                   "Bed room",
  //                 ],
  //                 onChange: (value) {
  //                   setState(() {
  //                     txtPdtGroup.text = value;
  //                   });
  //                 },
  //               )),
  //           formWidget(
  //               title: "Place",
  //               necessary: true,
  //               child: dropdownFormfield(
  //                 initalData: txtPdtPlace.text,
  //                 items: [
  //                   "Home",
  //                   "Office",
  //                   "School",
  //                   "Kitchen",
  //                 ],
  //                 onChange: (value) {
  //                   setState(() {
  //                     txtPdtPlace.text = value;
  //                   });
  //                 },
  //               )),
  //         ],
  //       ),
  //       isActive: _currentStep >= 0,
  //     ),
  //     Step(
  //       title: TextBuilder.build(
  //           title: "Warranzy Expire", style: TextStyleCustom.STYLE_LABEL_BOLD),
  //       content: Column(
  //         children: <Widget>[
  //           TextFieldBuilder.textFormFieldCustom(
  //               controller: txtWarranzyNo,
  //               borderOutLine: false,
  //               validate: false,
  //               title: "Warranty No"),
  //           formWidget(
  //               title: "Warranzy Expire",
  //               necessary: true,
  //               child: Container(
  //                 width: MediaQuery.of(context).size.width,
  //                 height: 50,
  //                 child: RaisedButton(
  //                   elevation: 0,
  //                   color: Colors.grey[100],
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10)),
  //                   child: Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: TextBuilder.build(title: dataTime)),
  //                   onPressed: () {
  //                     Picker(
  //                         itemExtent: 40,
  //                         adapter: DateTimePickerAdapter(customColumnType: [
  //                           0,
  //                           1,
  //                           2
  //                         ], months: [
  //                           allTranslations.text("jan"),
  //                           allTranslations.text("feb"),
  //                           allTranslations.text("mar"),
  //                           allTranslations.text("apr"),
  //                           allTranslations.text("may"),
  //                           allTranslations.text("Jun"),
  //                           allTranslations.text("jul"),
  //                           allTranslations.text("aug"),
  //                           allTranslations.text("sep"),
  //                           allTranslations.text("oct"),
  //                           allTranslations.text("nov"),
  //                           allTranslations.text("dec")
  //                         ]),
  //                         delimiter: [PickerDelimiter(child: Container())],
  //                         hideHeader: true,
  //                         confirmText: allTranslations.text("confirm"),
  //                         cancelText: allTranslations.text("cancel"),
  //                         title: new Text("Please Select"),
  //                         onConfirm: (Picker picker, List value) {
  //                           print(
  //                               "Picker value : ${(picker.adapter as DateTimePickerAdapter).value}");
  //                           setState(() {
  //                             dataTime =
  //                                 (picker.adapter as DateTimePickerAdapter)
  //                                     .value
  //                                     .toString()
  //                                     .split(" ")
  //                                     .first;
  //                             txtWarranzyExpire.text =
  //                                 (picker.adapter as DateTimePickerAdapter)
  //                                     .value
  //                                     .toString();
  //                           });
  //                         }).showDialog(context);
  //                   },
  //                 ),
  //               )
  //               // ButtonDatePickerCustom.buttonDatePicker(context, () {
  //               //   print(ButtonDatePickerCustom.showDate);
  //               //   setState(() {
  //               //     // _showDate = ButtonDatePickerCustom.showDate;
  //               //     txtWarranzyExpire.text = ButtonDatePickerCustom.valueDate;
  //               //   });
  //               // }),
  //               ),
  //         ],
  //       ),
  //       isActive: _currentStep >= 0,
  //     ),
  //     Step(
  //       title: TextBuilder.build(
  //           title: "Optional", style: TextStyleCustom.STYLE_LABEL_BOLD),
  //       content: formWidget(
  //         title: "Optional",
  //         child: Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //             // color: Colors.grey[100]
  //           ),
  //           padding: EdgeInsets.all(5),
  //           child: Column(
  //             children: <Widget>[
  //               TextFieldBuilder.textFormFieldCustom(
  //                   controller: txtSLCName,
  //                   borderOutLine: false,
  //                   validate: false,
  //                   title: "SLCName"),
  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: <Widget>[
  //                   Expanded(
  //                     child: TextFieldBuilder.textFormFieldCustom(
  //                         controller: txtSerialNo,
  //                         validate: false,
  //                         borderOutLine: false,
  //                         title: "Serial No"),
  //                   ),
  //                   SizedBox(
  //                     width: 5,
  //                   ),
  //                   GestureDetector(
  //                       onTap: () async {
  //                         print("ScanBarCode or QR");
  //                         var dataScan = await MethodLib.scanQR(context);
  //                         if (dataScan != null)
  //                           setState(() {
  //                             txtSerialNo.text = dataScan;
  //                           });
  //                       },
  //                       child: Column(
  //                         children: <Widget>[
  //                           Image.asset(Assets.ICON_BARCODE,
  //                               width: 35, height: 35),
  //                           // TextBuilder.build(
  //                           //     title: "Scan",
  //                           //     style: TextStyleCustom.STYLE_LABEL
  //                           //         .copyWith(fontSize: 10))
  //                         ],
  //                       ))
  //                 ],
  //               ),
  //               TextFieldBuilder.textFormFieldCustom(
  //                   controller: txtLotNo,
  //                   keyboardType: TextInputType.number,
  //                   validate: false,
  //                   borderOutLine: false,
  //                   title: "Lot No"),
  //               TextFieldBuilder.textFormFieldCustom(
  //                   controller: txtPrice,
  //                   keyboardType:
  //                       TextInputType.numberWithOptions(decimal: true),
  //                   validate: false,
  //                   borderOutLine: false,
  //                   title: "Salse price"),
  //               TextFieldBuilder.textFormFieldCustom(
  //                   controller: txtNote,
  //                   validate: false,
  //                   maxLine: 5,
  //                   borderOutLine: false,
  //                   title: "Note"),
  //             ],
  //             // ExpansionTile(
  //             //   title: TextBuilder.build(title: ""),
  //             //   children: <Widget>[

  //             //   ],
  //           ),
  //         ),
  //       ),
  //       isActive: _currentStep >= 0,
  //     ),
  //   ];
  //   return _step;
  // }
}

/*
// formWidget(
            //   title: "Category",
            //   necessary: true,
            //   child: FutureBuilder<List<GroupCategory>>(
            //     future: getProductGroupCategory,
            //     builder: (BuildContext context,
            //         AsyncSnapshot<List<GroupCategory>> snapshot) {
            //       if (snapshot.connectionState == ConnectionState.done) {
            //         if (!(snapshot.hasError)) {
            //           return ClipRRect(
            //             borderRadius: BorderRadius.circular(10),
            //             child: DropdownButtonFormField(
            //                 decoration: InputDecoration(
            //                     // border: InputBorder.none,
            //                     filled: true,
            //                     fillColor: Colors.grey[100]),
            //                 value: groupID,
            //                 items: snapshot.data.map((v) {
            //                   return DropdownMenuItem(
            //                     value: v.groupID,
            //                     child: Container(
            //                       width: 180,
            //                       child: Row(
            //                         children: <Widget>[
            //                           Image.network(
            //                             v.logo,
            //                             width: 30,
            //                             height: 30,
            //                             fit: BoxFit.contain,
            //                           ),
            //                           // Container(
            //                           //   child: CachedNetworkImage(
            //                           //     imageUrl: v.logo,
            //                           //     imageBuilder:
            //                           //         (context, imageProvider) =>
            //                           //             Container(
            //                           //       width: 30,
            //                           //       height: 30,
            //                           //       decoration: BoxDecoration(
            //                           //         image: DecorationImage(
            //                           //           image: imageProvider,
            //                           //           fit: BoxFit.contain,
            //                           //         ),
            //                           //       ),
            //                           //     ),
            //                           //     placeholder: (context, url) => Center(
            //                           //         child:
            //                           //             CircularProgressIndicator()),
            //                           //     errorWidget: (context, url, error) =>
            //                           //         Icon(Icons.error),
            //                           //   ),
            //                           // ),
            //                           SizedBox(width: 10),
            //                           Container(
            //                               width: 140,
            //                               child: AutoSizeText(
            //                                 v.modelGroupName?.eN ?? "",
            //                                 minFontSize: 10,
            //                                 stepGranularity: 10,
            //                                 maxLines: 2,
            //                                 overflow: TextOverflow.ellipsis,
            //                                 style: TextStyleCustom.STYLE_LABEL
            //                                     .copyWith(fontSize: 13),
            //                               )
            //                               // TextBuilder.build(
            //                               //     title: v.modelGroupName?.eN ?? "",
            //                               //     style: TextStyleCustom.STYLE_LABEL
            //                               //         .copyWith(fontSize: 13),
            //                               //     maxLine: 1,
            //                               //     textOverflow:
            //                               //         TextOverflow.ellipsis),
            //                               ),
            //                         ],
            //                       ),
            //                     ),
            //                   );
            //                 }).toList(),
            //                 onChanged: (value) async {
            //                   await DBProviderInitialApp.db
            //                       .getSubCategoryByGroupID(groupID: value)
            //                       .then((onValue) {
            //                     setState(() {
            //                       txtPdtCat.text = onValue.first.catCode;
            //                       groupID = value;
            //                       // print("${v.catCode} | ${v.groupID}");
            //                     });
            //                   });
            //                   getProductCategory = DBProviderInitialApp.db
            //                       .getSubCategoryByGroupID(groupID: value);
            //                 }),
            //           );
            //         } else {
            //           return TextBuilder.build(title: "Error data");
            //         }
            //       } else if (snapshot.connectionState ==
            //           ConnectionState.waiting) {
            //         return Center(child: CircularProgressIndicator());
            //       } else {
            //         return TextBuilder.build(title: "Something Wrong.");
            //       }
            //     },
            //   ),
            // ),
            // formWidget(
            //   title: "Sub-Category",
            //   necessary: true,
            //   child: FutureBuilder<List<ProductCategory>>(
            //     future: getProductCategory,
            //     builder: (BuildContext context,
            //         AsyncSnapshot<List<ProductCategory>> snapshot) {
            //       if (snapshot.connectionState == ConnectionState.done) {
            //         if (!(snapshot.hasError)) {
            //           return ClipRRect(
            //             borderRadius: BorderRadius.circular(10),
            //             child: DropdownButtonFormField(
            //               decoration: InputDecoration(
            //                   // border: InputBorder.none,
            //                   filled: true,
            //                   fillColor: Colors.grey[100]),
            //               value: txtPdtCat.text,
            //               items: snapshot.data.map((v) {
            //                 return DropdownMenuItem(
            //                   value: v.catCode,
            //                   child: Container(
            //                     width: 180,
            //                     child: Row(
            //                       children: <Widget>[
            //                         Image.network(
            //                           v.logo,
            //                           width: 30,
            //                           height: 30,
            //                           fit: BoxFit.contain,
            //                         ),
            //                         // CachedNetworkImage(
            //                         //   imageUrl: v.logo,
            //                         //   imageBuilder: (context, imageProvider) =>
            //                         //       Container(
            //                         //     width: 30,
            //                         //     height: 30,
            //                         //     decoration: BoxDecoration(
            //                         //       image: DecorationImage(
            //                         //         image: imageProvider,
            //                         //         fit: BoxFit.contain,
            //                         //       ),
            //                         //     ),
            //                         //   ),
            //                         //   placeholder: (context, url) => Center(
            //                         //       child: CircularProgressIndicator()),
            //                         //   errorWidget: (context, url, error) =>
            //                         //       Icon(Icons.error),
            //                         // ),
            //                         SizedBox(width: 10),
            //                         Container(
            //                           width: 140,
            //                           child: AutoSizeText(
            //                             v.modelCatName?.eN ?? "",
            //                             minFontSize: 10,
            //                             stepGranularity: 10,
            //                             maxLines: 2,
            //                             overflow: TextOverflow.ellipsis,
            //                             style: TextStyleCustom.STYLE_LABEL
            //                                 .copyWith(fontSize: 13),
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 );
            //               }).toList(),
            //               onChanged: (value) => setState(() {
            //                 txtPdtCat.text = value;
            //                 print(txtPdtCat.text);
            //               }),
            //             ),
            //           );
            //         } else {
            //           return TextBuilder.build(title: "Error data");
            //         }
            //       } else if (snapshot.connectionState ==
            //           ConnectionState.waiting) {
            //         return CircularProgressIndicator();
            //       } else {
            //         return TextBuilder.build(title: "Something Wrong.");
            //       }
            //     },
            //   ),
            // ),
*/
