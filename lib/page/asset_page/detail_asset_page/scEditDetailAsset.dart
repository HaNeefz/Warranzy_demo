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
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/form_data_asset.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

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
  List<String> imageOld = [];
  List<Uint8List> image = [];
  @override
  void initState() {
    super.initState();
    // relatedImage = RelatedImage(category: _data);
    // var tempRelated = relatedImage.listRelatedImage();
    // print(tempRelated);
    listTempData = List.of(imageEachGroup);
    getImageToBase64();
  }

  Future<List<Uint8List>> getImageToBase64() async {
    List<Uint8List> listImage = [];
    for (int i = 0; i < imageEachGroup.length; i++) {
      for (int j = 0; j < imageEachGroup[i].imageUrl.length; j++) {
        try {
          // print("URL => imageEachGroup[$i].imageUrl[$j]");
          var response = await http.get(imageEachGroup[i].imageUrl[j]);
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
            children:
                imageEachGroup.map((v) => buildDetialEachGroup(v)).toList(),
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
                Text("${v.imageUrl.length}"),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
          onTap: () async {
            v.imageUrl.forEach((v) {
              print(v);
            });
            await ecsLib
                .pushPage(
              context: context,
              pageWidget: ModifyImage(
                image: v,
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
  final ModelDataAsset data;
  ModifyImage({Key key, this.image, this.data}) : super(key: key);

  ModifytImageState createState() => ModifytImageState();
}

class ModifytImageState extends State<ModifyImage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  ImageDataEachGroup get imageDataEachGroup => widget.image;
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
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextBuilder.build(title: "${imageDataEachGroup.title}"),
            SizedBox(height: 5),
            Center(child: TextBuilder.build(title: "Old Image")),
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
                        Text("Eieie")
                        // GridView(
                        //   shrinkWrap: true,
                        //   gridDelegate:
                        //       SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 2,
                        //     crossAxisSpacing: 5,
                        //     mainAxisSpacing: 5,
                        //   ),
                        //   children: <Widget>[
                        //     for (var _imageData in data)
                        //       if (_imageData != null && _imageData.length > 0)
                        //         Image.memory(_imageData, fit: BoxFit.cover),
                        //   ],
                        // ),
                        // imageNew.length > 0
                        //     ? Column(
                        //         children: <Widget>[
                        //           Padding(
                        //             padding:
                        //                 EdgeInsets.only(top: 5, bottom: 10),
                        //             child:
                        //                 TextBuilder.build(title: "New Image"),
                        //           ),
                        //           GridView(
                        //             shrinkWrap: true,
                        //             gridDelegate:
                        //                 SliverGridDelegateWithFixedCrossAxisCount(
                        //               crossAxisCount: 2,
                        //               crossAxisSpacing: 5,
                        //               mainAxisSpacing: 5,
                        //             ),
                        //             children: <Widget>[
                        //               for (var _imageNew in imageNew)
                        //                 if (_imageNew != null &&
                        //                     imageNew.length > 0)
                        //                   Image.file(_imageNew,
                        //                       fit: BoxFit.cover)
                        //             ],
                        //           ),
                        //         ],
                        //       )
                        //     : Container()
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
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.add_a_photo),
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
          FloatingActionButton(
            child: Icon(Icons.add_a_photo),
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
    ecsLib.showDialogLoadingLib(context, content: "compressing photo");
    Map<String, dynamic> postData = {
      "WTokenID": "${widget.data.wTokenID}",
      "${imageDataEachGroup.title}": {}
    };
    int counter = imageOld.length + imageNew.length;
    List<String> imageTobase64 = [];
    imageOld.forEach((v) {
      imageTobase64.add(base64.encode(v));
    });
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
  }

  sendAPIUpdateImage({dynamic postData}) async {
    ecsLib.showDialogLoadingLib(context, content: "Updating Image");
    await APIServiceAssets.updateImage(postData: postData).then((response) {
      ecsLib.cancelDialogLoadindLib(context);
    });
  }
}
