import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:warranzy_demo/models/model_image_data_each_group.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/page/asset_page/add_assets_page/scAdd_image_demo.dart';
import 'package:warranzy_demo/services/api/repository.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/form_data_asset.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/image_list_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import 'scDetailAsset.dart';

class EditDetailAsset extends StatefulWidget {
  final bool editingImage;
  final ModelDataAsset modelDataAsset;
  final List<ImageDataEachGroup> imageDataEachGroup;
  final Map<String, List<String>> fileAttach;

  const EditDetailAsset(
      {Key key,
      this.editingImage,
      this.modelDataAsset,
      this.imageDataEachGroup,
      this.fileAttach})
      : super(key: key);
  @override
  _EditDetailAssetState createState() => _EditDetailAssetState();
}

class _EditDetailAssetState extends State<EditDetailAsset> {
  bool get editor => widget.editingImage == true ? true : false;
  ModelDataAsset get _data => widget.modelDataAsset;
  List<ImageDataEachGroup> get imageDataEachGroup => widget.imageDataEachGroup;
  @override
  @override
  void initState() {
    super.initState();
    print("<EditDetailAsset> fileAttach => ${widget.fileAttach}");
  }

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
        return EditImages(
          modelDataAsset: _data,
          imageEachGroup: imageDataEachGroup,
          fileAttach: widget.fileAttach,
        );
        break;
      case false:
        return FormDataAsset(
          actionPageForAdd: false,
          modelDataAsset: _data,
        );
        break;
      default:
        return child;
    }
  }
}

class EditImages extends StatefulWidget {
  final ModelDataAsset modelDataAsset;
  final bool editImageForAdd;
  final List<ImageDataEachGroup> imageEachGroup;
  final String categoryID;
  final Map<String, List<String>> fileAttach;
  const EditImages(
      {Key key,
      this.modelDataAsset,
      this.imageEachGroup,
      this.editImageForAdd = true,
      this.categoryID,
      this.fileAttach})
      : super(key: key);
  @override
  _EditImagesState createState() => _EditImagesState();
}

class _EditImagesState extends State<EditImages> {
  final Dio dio = Dio();
  final ecsLib = getIt.get<ECSLib>();
  ModelDataAsset get _data => widget.modelDataAsset;
  List<ImageDataEachGroup> get imageEachGroup => widget.imageEachGroup;
  bool get editImageForAdd => widget.editImageForAdd;
  String get categoryID => widget.categoryID;
  List<ImageDataEachGroup> listTempData;
  RelatedImage relatedImage;
  List<String> listRelated = [];
  List<String> tempListRelated = [];
  List<String> imageOld = [];
  List<Uint8List> image = [];

  getProductCat([String categoryID]) async {
    // print("CatID => $categoryID");
    var res = await DBProviderInitialApp.db
        .getDataProductCategoryByID(categoryID ?? _data.pdtCatCode);
    relatedImage = RelatedImage(category: res);
    listRelated = relatedImage.listRelatedImage();
    tempListRelated = List.of(listRelated);
    // print("Related => $tempListRelated");
    for (var tempData in listTempData) {
      // print("${listTempData.indexOf(tempData)} => ${tempData.title}");
      for (var tempReleted in listRelated) {
        if (tempReleted == tempData.title) {
          tempListRelated.removeAt(tempListRelated.indexOf(tempReleted));
          // print("rm => $tempListRelated");
        }
      }
    }
    tempListRelated.forEach((v) {
      setState(() {
        listTempData.add(ImageDataEachGroup(
            title: v, imageUrl: [], imageBase64: [], imagesList: []));
      });
    });
    print("compact => $listRelated");
  }

  @override
  void initState() {
    super.initState();
    listTempData = List.of(imageEachGroup ?? []);

    if (editImageForAdd == false) {
      getProductCat();
      getImageToBase64();
    } else {
      print("editImageForAdd => $editImageForAdd");
      getProductCat(categoryID);
    }
  }

  Future<List<Uint8List>> getImageToBase64() async {
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // Text("EIeie")
          Column(
            children: listTempData.map((v) => buildDetialEachGroup(v)).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildDetialEachGroup(ImageDataEachGroup v) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text("${v.title}"),
          trailing: Container(
            // color: Colors.red,
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("${v.imageBase64.length}\t\titems"),
                Icon(Icons.edit),
              ],
            ),
          ),
          onTap: () async {
            await ecsLib
                .pushPage(
              context: context,
              pageWidget: ModifyImage(
                image: v,
                assetData: _data,
                fileAttach: widget.fileAttach,
              ),
            )
                .then((_) {
              setState(() {});
            });
          },
        ),
        Divider()
      ],
    );
  }
}

class ModifyImage extends StatefulWidget {
  final ImageDataEachGroup image;
  final ModelDataAsset assetData;
  final Map<String, List<String>> fileAttach;
  ModifyImage({Key key, this.image, this.assetData, this.fileAttach})
      : super(key: key);

  ModifytImageState createState() => ModifytImageState();
}

class ModifytImageState extends State<ModifyImage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  ImageDataEachGroup get imageDataEachGroup => widget.image;
  ModelDataAsset get assetData => widget.assetData;
  Future<List<Uint8List>> tempImageLoading;
  List<File> imageNew = [];
  List<Uint8List> imageOld = [];

  void initState() {
    super.initState();
    print("fileAttach intiState() : ${widget.fileAttach}");
    print("title initState() : ${imageDataEachGroup.title}");
    print("listBase64 initState() : ${imageDataEachGroup.imageBase64}");
    tempImageLoading = getImageToBase64();
  }

  Future<List<Uint8List>> getImageToBase64() async {
    List<Uint8List> listImage = [];
    // for (int i = 0; i < imageDataEachGroup.imageUrl.length; i++) {
    //   try {
    //     print("loading");
    //     var response = await http.get(imageDataEachGroup.imageUrl[i]);
    //     listImage.add(response.bodyBytes);
    //     imageOld = listImage;
    //   } catch (e) {
    //     print(e);
    //     return [];
    //   }
    // }
    imageDataEachGroup?.imageBase64?.forEach((v) async {
      final image = await DBProviderAsset.db.getImagePoolReturn(v);
      if (image != null && image.length > 0) {
        listImage.add(base64Decode(image.first.fileData));
        setState(() => imageOld = listImage);
      } else {
        print("getImageFromDB return null");
      }
    });

    return listImage;
  }

  alert({String title, String content}) => ecsLib.showDialogLib(context,
      content: content,
      textOnButton: allTranslations.text("close"),
      title: "ERROR STATUS");

  List returnImage = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextBuilder.build(
            title: "Modify Image", style: TextStyleCustom.STYLE_APPBAR),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            // returnImage.add(imageOld);
            // returnImage.add(imageNew);
            // Navigator.pop(context, returnImage);
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          FlatButton(
              child: TextBuilder.build(title: "Edit"),
              onPressed: submitUpdateImage)
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextBuilder.build(
                      title: "${imageDataEachGroup.title}",
                      style: TextStyleCustom.STYLE_TITLE),
                  SizedBox(height: 5),
                  SizedBox(height: 5),
                  FutureBuilder<List<Uint8List>>(
                    future: tempImageLoading,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Uint8List>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text("Error");
                        } else {
                          var data = snapshot.data;
                          return Container(
                              child: Column(
                            children: <Widget>[
                              if (data.isNotEmpty && data.length > 0)
                                Column(
                                  children: <Widget>[
                                    Center(
                                        child: TextBuilder.build(
                                            title: "Old Image")),
                                    ImageListBuilder.build(
                                        context: context,
                                        imageData: data,
                                        isImageBase64: true,
                                        heroTag: "imageOld",
                                        editAble: true,
                                        onClicked: (index) {
                                          print("ImageOld indexOf($index)");
                                          if (data.length > 1)
                                            setState(() {
                                              imageOld.removeAt(index);
                                            });
                                        }),
                                  ],
                                )
                            ],
                          ));
                        }
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Text("Something wrong...!");
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  imageNew.length > 0
                      ? Column(
                          children: <Widget>[
                            TextBuilder.build(title: "New Image"),
                            SizedBox(height: 10),
                            if (imageNew.isNotEmpty && imageNew.length > 0)
                              ImageListBuilder.build(
                                  context: context,
                                  imageData: imageNew,
                                  isImageBase64: true,
                                  heroTag: "imageNew",
                                  editAble: true,
                                  onClicked: (index) {
                                    print("imageNew indexOf($index)");
                                    if (imageNew.length > 0)
                                      setState(() {
                                        imageNew.removeAt(index);
                                      });
                                  })
                          ],
                        )
                      : Container()
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "takePhoto",
            child: Icon(Icons.add_a_photo, size: 35),
            onPressed: () async {
              try {
                var resPhoto = await ecsLib.getImage();
                if (resPhoto != null)
                  setState(() {
                    imageNew.add(resPhoto);
                  });
              } catch (e) {
                print(e);
              }
            },
          ),
          SizedBox(height: 5),
          FloatingActionButton(
            heroTag: "gallery",
            backgroundColor: Colors.red[300],
            child: Icon(Icons.add_photo_alternate, size: 35),
            onPressed: () async {
              try {
                var resPhoto = await ecsLib.getImageFromGallery();
                if (resPhoto != null)
                  setState(() {
                    imageNew.add(resPhoto);
                  });
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      ),
    );
  }

  submitUpdateImage() async {
    if (imageOld.isNotEmpty || imageNew.isNotEmpty) {
      print("this if imageOld.isNotEmpty || imageNew.isNotEmpty");
      ecsLib.showDialogLoadingLib(context, content: "compressing photo");
      Map<String, dynamic> postData = {
        "WTokenID": "${assetData.wTokenID}",
        "${imageDataEachGroup.title}": {}
      };
      int counter = imageOld.length + imageNew.length;
      List<String> imageTobase64 = [];
      if (imageNew.length > 0)
        imageNew.forEach((v) async {
          if (imageNew.indexOf(v) == 0) {
            print("index ${imageNew.indexOf(v)}");
            imageOld.forEach((v) {
              imageTobase64.add(base64.encode(v));
            });
          }
          var tempDir = await getTemporaryDirectory();
          var _newSize = await ecsLib.compressFile(
            file: v,
            targetPath: tempDir.path + "/${v.path.split("/").last}",
            minWidth: 600,
            minHeight: 480,
            quality: 80,
          );
          var imageByte = _newSize.readAsBytesSync();
          imageTobase64.add(base64Encode(imageByte));

          if (imageTobase64.length == counter) {
            print("imageToBase64 length => ${imageTobase64.length}");
            for (var data in imageTobase64) {
              postData["${imageDataEachGroup.title}"].addAll({
                "${imageTobase64.indexOf(data)}": data,
              });
            }
            ecsLib.cancelDialogLoadindLib(context);
            ecsLib.printJson(postData);
            sendAPIUpdateImage(postData: postData);
          }
        });
      else {
        print("this else imageOld.isNotEmpty || imageNew.isNotEmpty");
        imageOld.forEach((v) {
          imageTobase64.add(base64.encode(v));
        });
        if (imageTobase64.length == counter) {
          print("imageToBase64 length => ${imageTobase64.length}");
          for (var data in imageTobase64) {
            postData["${imageDataEachGroup.title}"].addAll({
              "${imageTobase64.indexOf(data)}": data,
            });
          }
          ecsLib.cancelDialogLoadindLib(context);
          ecsLib.printJson(postData);
          sendAPIUpdateImage(postData: postData);
        }
      }
    } else {
      alert(content: "Image is empty. Please add Image.");
    }
  }

  sendAPIUpdateImage({dynamic postData}) async {
    ecsLib.showDialogLoadingLib(context, content: "Editing Image Asset");
    await Repository.updateImage(body: postData).then((response) async {
      ecsLib.cancelDialogLoadindLib(context);
      print("upDate Image Success ${response.status} | ${response.message}");
      if (response.status == true) {
        ecsLib.showDialogLoadingLib(context, content: "Updating Image Asset");
        Map<String, List<String>> fileAttach = {};
        String decriptionImage;
        List<String> keyImage = [];
        response.filePool.forEach((v) {
          decriptionImage = "${jsonDecode(v.fileDescription)['EN']}";
          keyImage.add(v.fileID);
        });
        fileAttach.addAll({decriptionImage: keyImage});
        print("OldFileAttach => ${widget.fileAttach}");
        print("fileAttach => $fileAttach");
        widget.fileAttach.addAll(fileAttach);
        print("ManageFileAttach : ${widget.fileAttach}");
        await DBProviderAsset.db
            .updateWarranzyLog(
                wTokenID: assetData.wTokenID,
                fileAttach: jsonEncode(widget.fileAttach))
            .then((completed) async {
          if (completed != null) {
            print("Update tableLog completed");
            response.filePool.forEach((dataFilePool) async {
              await DBProviderAsset.db.updateImagePoolForEditImageAsset(
                  oldFileID: imageDataEachGroup.imageBase64,
                  filePool: dataFilePool);
            });
            print("ALL UPDATE COMPLETED");
            if (widget.assetData.createType == "C") {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              ecsLib.pushPageReplacement(
                  context: context,
                  pageWidget: DetailAsset(
                    dataAsset: widget.assetData,
                    dataScan: null,
                    showDetailOnline: true,
                    listImage: [widget.fileAttach],
                  ));
            } else {
              try {
                ecsLib.showDialogLoadingLib(context);
                await Repository.getDetailAseet(
                        body: {"WTokenID": widget.assetData.wTokenID})
                    .then((res) async {
                  ecsLib.cancelDialogLoadindLib(context);
                  if (res?.status == true) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ecsLib.pushPageReplacement(
                      context: context,
                      pageWidget: DetailAsset(
                        dataAsset: res.data,
                        showDetailOnline: true,
                        dataScan: res.dataScan,
                        listImage: [widget.fileAttach],
                      ),
                    );
                  } else if (res.status == false) {
                    alert(
                        content:
                            "status false : " + res?.message ?? "status false");
                  } else {
                    alert(content: res?.message ?? "Something wrong");
                    await ecsLib.pushPageReplacement(
                        context: context,
                        pageWidget: DetailAsset(
                          dataAsset: widget.assetData,
                          showDetailOnline: true,
                          dataScan: null,
                          listImage: [widget.fileAttach],
                        ));
                  }
                });
              } catch (e) {
                alert(title: "CATCH ERROR", content: "catch : $e");
              }
            }
          } else {
            print("Update tableLog incompleted");
          }
        });
      } else if (response.status == false) {
        alert(content: "${response.message}");
      } else {
        alert(content: "${response.message}");
      }
    });
  }

  List<String> imageOldToBase64() {
    List<String> tempImage = [];
    if (imageOld.length > 0)
      imageOld.forEach((v) {
        tempImage.add(base64.encode(v));
      });
    else
      tempImage = [];
    return tempImage;
  }

  List<String> imageNewToBase64() {
    List<String> tempImage = [];
    if (imageNew.length > 0) {
      imageNew.forEach((v) async {
        var tempDir = await getTemporaryDirectory();
        var _newSize = await ecsLib.compressFile(
          file: v,
          targetPath: tempDir.path + "/${v.path.split("/").last}",
          minWidth: 600,
          minHeight: 480,
          quality: 80,
        );
        var imageByte = _newSize.readAsBytesSync();
        tempImage.add(base64Encode(imageByte));
      });
    } else
      tempImage = [];
    return tempImage;
  }

  // List<String> imageToBase64() {
  //   List<String> tempImage = [];
  //   int counterAllImage = imageOld.length + imageNew.length;
  //   imageOld.forEach((v) {
  //     tempImage.add(base64.encode(v));
  //   });
  //   imageNew.forEach((v) async {
  //     var tempDir = await getTemporaryDirectory();
  //     var _newSize = await ecsLib.compressFile(
  //       file: v,
  //       targetPath: tempDir.path + "/${v.path.split("/").last}",
  //       minWidth: 600,
  //       minHeight: 480,
  //       quality: 80,
  //     );
  //     var imageByte = _newSize.readAsBytesSync();
  //     tempImage.add(base64Encode(imageByte));
  //   });
  //   if (tempImage.length == counterAllImage) {
  //     return tempImage;
  //   } else
  //     return [];
  // }
}
