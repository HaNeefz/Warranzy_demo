import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/page/asset_page/add_assets_page/scAdd_image_demo.dart';
import 'package:warranzy_demo/services/api/api_service_assets.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/form_data_asset.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/image_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/image_list_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import 'scDetailAsset.dart';

class EditDetailAsset extends StatefulWidget {
  final bool editingImage;
  final ModelDataAsset modelDataAsset;
  final List<ImageDataEachGroup> imageDataEachGroup;

  const EditDetailAsset(
      {Key key,
      this.editingImage,
      this.modelDataAsset,
      this.imageDataEachGroup})
      : super(key: key);
  @override
  _EditDetailAssetState createState() => _EditDetailAssetState();
}

class _EditDetailAssetState extends State<EditDetailAsset> {
  bool get editor => widget.editingImage == true ? true : false;
  ModelDataAsset get _data => widget.modelDataAsset;
  List<ImageDataEachGroup> get imageDataEachGroup => widget.imageDataEachGroup;
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
        return EditImages(
          modelDataAsset: _data,
          imageEachGroup: imageDataEachGroup,
        );
        break;
      case false:
        return EditInformation(
          modelDataAsset: _data,
        );
        break;
      default:
        return child;
    }
  }
}

class EditInformation extends StatelessWidget {
  final ModelDataAsset modelDataAsset;
  const EditInformation({Key key, this.modelDataAsset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FormDataAsset(
      actionPageForAdd: false,
      modelDataAsset: modelDataAsset,
    ));
  }
}

class EditImages extends StatefulWidget {
  final ModelDataAsset modelDataAsset;
  final List<ImageDataEachGroup> imageEachGroup;
  const EditImages({Key key, this.modelDataAsset, this.imageEachGroup})
      : super(key: key);
  @override
  _EditImagesState createState() => _EditImagesState();
}

class _EditImagesState extends State<EditImages> {
  final Dio dio = Dio();
  final ecsLib = getIt.get<ECSLib>();
  ModelDataAsset get _data => widget.modelDataAsset;
  List<ImageDataEachGroup> get imageEachGroup => widget.imageEachGroup;
  List<ImageDataEachGroup> listTempData;
  RelatedImage relatedImage;
  List<String> listRelated = [];
  List<String> tempListRelated = [];
  List<String> imageOld = [];
  List<Uint8List> image = [];

  getProductCat() async {
    var res = await DBProviderInitialApp.db
        .getDataProductCategoryByID(_data.pdtCatCode);
    relatedImage = RelatedImage(category: res);
    listRelated = relatedImage.listRelatedImage();
    tempListRelated = List.of(listRelated);
    print(listRelated);
    print(
        "listTempData Old => ${listTempData.length} is ${listTempData.first.title}");
    for (var tempData in listTempData) {
      print("${listTempData.indexOf(tempData)} => ${tempData.title}");
      for (var tempReleted in tempListRelated) {
        if (tempReleted == tempData.title) {
          print("Remove cause :$tempReleted == ${tempData.title}");
          print("Data listRelated before rm => ${listRelated.length} items");
          listRelated.removeAt(tempListRelated.indexOf(tempReleted));
          print("Data listRelated After rm => ${listRelated.length} items");
        }
      }
    }
    listRelated.forEach((v) {
      setState(() {
        listTempData.add(ImageDataEachGroup(
            title: v, imageUrl: [], imageBase64: [], imagesList: []));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    listTempData = List.of(imageEachGroup);
    getProductCat();
    getImageToBase64();
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
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("${v.imageUrl.length}\t\titems"),
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
  ModifyImage({Key key, this.image, this.assetData}) : super(key: key);

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

    print(imageDataEachGroup.title);
    print(imageDataEachGroup.imageUrl);
    tempImageLoading = getImageToBase64();
  }

  Future<List<Uint8List>> getImageToBase64() async {
    List<Uint8List> listImage = [];
    for (int i = 0; i < imageDataEachGroup.imageUrl.length; i++) {
      try {
        print("loading");
        var response = await http.get(imageDataEachGroup.imageUrl[i]);
        listImage.add(response.bodyBytes);
        imageOld = listImage;
      } catch (e) {
        print(e);
        return null;
      }
    }

    return listImage;
  }

  alert(String content) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextBuilder.build(
            title: "Modify Image", style: TextStyleCustom.STYLE_APPBAR),
        actions: <Widget>[
          FlatButton(
              child: TextBuilder.build(title: allTranslations.text("submit")),
              onPressed: submitUpdateImage)
        ],
      ),
      body: Padding(
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
      alert("Image is empty. Please add Image.");
    }
  }

  sendAPIUpdateImage({dynamic postData}) async {
    ecsLib.showDialogLoadingLib(context, content: "Editing Image Asset");
    await APIServiceAssets.updateImage(postData: postData)
        .then((response) async {
      ecsLib.cancelDialogLoadindLib(context);
      if (response.status == true) {
        ecsLib.showDialogLoadingLib(context, content: "Updating Image Asset");
        await APIServiceAssets.getDetailAseet(wtokenID: assetData.wTokenID)
            .then((responseDetail) {
          ecsLib.cancelDialogLoadindLib(context);
          if (responseDetail.status == true) {
            ecsLib.stepBackScene(context, 2);
            ecsLib.pushPageReplacement(
              context: context,
              pageWidget: DetailAsset(
                dataAsset: responseDetail.data,
                showDetailOnline: true,
              ),
            );
          } else if (responseDetail.status == false) {
            alert("${responseDetail.message}");
          } else {
            alert("${responseDetail.message}");
          }
        });
      } else if (response.status == false) {
        alert("${response.message}");
      } else {
        alert("${response.message}");
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
