import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_picker/flutter_picker.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:warranzy_demo/models/model_get_brand_name.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/page/asset_page/add_assets_page/scAdd_image_demo.dart';
import 'package:warranzy_demo/page/asset_page/detail_asset_page/scDetailAsset.dart';
import 'package:warranzy_demo/page/asset_page/detail_asset_page/scEditDetailAsset.dart';
import 'package:warranzy_demo/page/main_page/scMain_page.dart';
import 'package:warranzy_demo/services/api/api_service_assets.dart';
import 'package:warranzy_demo/services/method/scan_qr.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
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
  Future<List<ProductCatagory>> getProductCategory;
  bool _showButtonSave = false;
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
    listTempData = List.of(listImageEachGroup ?? []);

    getProductCategory = DBProviderInitialApp.db.getAllDataProductCategory();
    if (_data != null) {
      brandActive = _data?.brandCode != null ? "Y" : "N";
      txtAssetName = TextEditingController(text: _data?.title ?? "");
      txtBrandName = TextEditingController(text: "");
      txtBrandCode = TextEditingController(text: _data?.brandCode ?? "");
      txtWarranzyNo = TextEditingController(text: _data?.warrantyNo ?? "");
      txtWarranzyExpire =
          TextEditingController(text: _data?.warrantyExpire ?? "");
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

  getProductCat([String categoryID]) async {
    // print("CatID => $categoryID");
    var res = await DBProviderInitialApp.db
        .getDataProductCategoryByID(categoryID ?? _data.pdtCatCode);
    relatedImage = RelatedImage(category: res);
    listRelated = relatedImage.listRelatedImage();
    tempListRelated = List.of(listRelated);
    print("Related => $tempListRelated");
    // if (listTempData != null && listTempData != []) {
    // print("listTempData $listTempData");
    for (var tempData in listTempData) {
      print("${listTempData.indexOf(tempData)} => ${tempData.title}");
      for (var tempReleted in listRelated) {
        if (tempReleted == tempData.title) {
          setState(() {
            tempListRelated.removeAt(tempListRelated.indexOf(tempReleted));
            print("rm => $tempListRelated");
          });
        }
      }
      // }
    }
    tempListRelated.forEach((v) {
      setState(() {
        listTempData.add(ImageDataEachGroup(
            title: v,
            imageUrl: [],
            imageBase64: [],
            imagesList: [],
            imageUint8List: []));
      });
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
      if (_currentStep + 1 != _myStepForEdit().length)
        goTo(_currentStep + 1);
      else {
        setState(() {
          complete = true;
        });
        print("Completed, check fields.");
        saveInformation();
      }
    }
  }

  void saveInformation() async {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      print(txtBrandName.text);
      if (txtBrandName.text == "") {
        ecsLib.showDialogLib(
            context: context,
            content: "Invalide Brand Name.",
            textOnButton: allTranslations.text("close"),
            title: "Warranzy");
      } else if (txtWarranzyExpire.text == "") {
        ecsLib.showDialogLib(
            context: context,
            content: "Invalide Warranty Expire.",
            textOnButton: allTranslations.text("close"),
            title: "Warranzy");
      } else if (txtAssetName.text == "") {
        ecsLib.showDialogLib(
            context: context,
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
          createType = _data.createType;
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
        };
        // ecsLib.printJson(postData);

        if (actionPageForAdd == true) {
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: TextBuilder.build(
                      title: "Warranzy",
                      style: TextStyleCustom.STYLE_LABEL_BOLD),
                  content: TextBuilder.build(
                      title: "Are you sure you want to add asset"),
                  actions: <Widget>[
                    FlatButton(
                      child: TextBuilder.build(title: "Save"),
                      onPressed: () => Navigator.pop(context, "S"),
                    ),
                    FlatButton(
                      child: TextBuilder.build(title: "Save and Duplicate"),
                      onPressed: () => Navigator.pop(context, "SD"),
                    ),
                    FlatButton(
                      child: TextBuilder.build(
                          title: allTranslations.text("cancel")),
                      onPressed: () => Navigator.pop(context, "C"),
                    ),
                  ],
                );
              }).then((response) async {
            if (response == "S") {
              print(response);
              await submitForAddAsset(
                  postData: postData,
                  whenCompleted: () => ecsLib.pushPageAndClearAllScene(
                      context: context, pageWidget: MainPage()));
            } else if (response == "SD") {
              print(response);
              await submitForAddAsset(
                  postData: postData,
                  whenCompleted: () async {
                    await ecsLib.showDialogLib(
                      context: context,
                      title: "Warranzy",
                      content: "Added asset and Duplicated data.",
                      textOnButton: allTranslations.text("ok"),
                    );
                  });
            } else {
              print(response);
            }
          });
        } else
          sendApiEdit(postData: postData);
      }
    }
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
          FlatButton(
            child: null,
            onPressed: () {},
          )
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
                  steps: actionPageForAdd == true
                      ? _myStepForAdd()
                      : _myStepForEdit()),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetialEachGroup(ImageDataEachGroup data, {bool edit = false}) {
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
                Text(
                    "${edit == false ? data.imagesList.length : data.imageUrl.length + data.imagesList.length}\t\titems"),
                Icon(edit == true ? Icons.edit : Icons.add_circle),
              ],
            ),
          ),
          onTap: () async {
            if (edit == true) {
              List images = await ecsLib.pushPage(
                context: context,
                pageWidget: ModifyImage(
                  image: data,
                  assetData: _data,
                ),
              );
              if (images != null && images.isNotEmpty) {
                // List<Uint8List> temp = images[0] as List<Uint8List>;
                setState(() {
                  data.imageUint8List = images[0] as List<Uint8List>;
                  data.imagesList = images[1] as List<File>;
                });
              }
            } else {
              List<File> images = await ecsLib.pushPage(
                  context: context,
                  pageWidget: TakePhotos(
                    title: data.title,
                    images: data.imagesList,
                  ));
              print("comeback");

              if (images != null) {
                print("return Images = ${images.length}");
                setState(() {
                  data.imagesList = images;
                });
                data.imageBase64.clear();
                for (var fileImage in images) {
                  data.imageBase64.add("${fileImage.path}");
                }
                print(data.imagesList.length);
              }
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
    };
    ecsLib.printJson(postData);
    sendApiEdit(postData: postData);
  }

  sendApiEdit({postData}) async {
    ecsLib
        .showDialogAction(
            context: context,
            title: "Warranzy",
            content: "Are you sure to update asset data.",
            textOk: allTranslations.text("ok"),
            textCancel: allTranslations.text("cancel"))
        .then((response) async {
      if (response == true) {
        try {
          ecsLib.showDialogLoadingLib(context, content: "Editing Detail Asset");
          await APIServiceAssets.updateData(postData: postData)
              .then((resEdit) async {
            ecsLib.cancelDialogLoadindLib(context);
            if (resEdit?.status == true) {
              ecsLib.showDialogLoadingLib(context,
                  content: "Upload Detail Asset");
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
    });
  }

  Future<bool> submitForAddAsset({postData, Function whenCompleted}) async {
    bool _completed = false;
    var dataPost = {"Data": postData, "Images": {}};
    print("Submit");
    ecsLib.showDialogLoadingLib(context, content: "Image compressing");
    try {
      for (int i = 0; i < listTempData.length; i++) {
        var tempModelImage = listTempData[i];
        for (int j = 0; j < tempModelImage.imagesList.length; j++) {
          var listImages = tempModelImage.imagesList[j];
          var tempDir = await getTemporaryDirectory();
          var _newSize = await ecsLib.compressFile(
            file: listImages,
            targetPath: tempDir.path + "/${listImages.path.split("/").last}",
            minWidth: 600,
            minHeight: 480,
            quality: 80,
          );
          listImages = _newSize;
          tempModelImage.imageBase64[j] =
              base64Encode(listImages.readAsBytesSync());

          print("------ ${tempModelImage.title} No. $i => Image No. $j");
        }
      }
      var imageData = {};
      try {
        for (var modelImage in listTempData) {
          imageData.addAll({"${modelImage.title}": {}});
          for (var imageBase64Data in modelImage.imageBase64) {
            imageData["${modelImage.title}"].addAll({
              "${modelImage.imageBase64.indexOf(imageBase64Data)}":
                  imageBase64Data
            });
          }
        }
        dataPost.addAll({"Images": imageData});
      } catch (e) {
        print(e);
      }
    } catch (e) {
      print(e);
    }
    ecsLib.cancelDialogLoadindLib(context);

    ecsLib.printJson(dataPost);
    ecsLib.showDialogLoadingLib(context, content: "Adding assets");
    try {
      await APIServiceAssets.addAsset(postData: dataPost)
          .timeout(Duration(seconds: 60))
          .then((res) async {
        print("<--- Response");
        _completed = true;
        ecsLib.cancelDialogLoadindLib(context);
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
      }).catchError((e) {
        print(e);
        ecsLib.cancelDialogLoadindLib(context);
      });
    } on DioError catch (error) {
      print("DIO ERROR => ${error.error}\nMsg => ${error.message}");
      ecsLib.cancelDialogLoadindLib(context);
    } on SocketException catch (e) {
      print(e);
      ecsLib.cancelDialogLoadindLib(context);
    } on HttpException catch (e) {
      print(e);
      ecsLib.cancelDialogLoadindLib(context);
    } on FormatException catch (e) {
      print(e);
      ecsLib.cancelDialogLoadindLib(context);
    } on Exception catch (e) {
      print(e);
      ecsLib.cancelDialogLoadindLib(context);
    } catch (e) {
      print("Catch $e");
      ecsLib.cancelDialogLoadindLib(context);
    }
    return _completed;
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
      "CreateType": widget.pageType == PageType.MANUAL ? "C" : "T"
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
                ecsLib.showDialogLib(
                    context: context,
                    content: "Invalide Brand Name.",
                    textOnButton: allTranslations.text("close"),
                    title: "Warranzy");
              } else if (txtWarranzyExpire.text == "") {
                ecsLib.showDialogLib(
                    context: context,
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
                                  title: "${v.catName}",
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
            title: "Warranzy Expire", style: TextStyleCustom.STYLE_LABEL_BOLD),
        content: formWidget(
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
                          dataTime = (picker.adapter as DateTimePickerAdapter)
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

  List<Step> _myStepForEdit() {
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
                                  title: "${v.catName}",
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
            title: "Warranzy Expire", style: TextStyleCustom.STYLE_LABEL_BOLD),
        content: formWidget(
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
                          dataTime = (picker.adapter as DateTimePickerAdapter)
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
    ];
    return _step;
  }
}
