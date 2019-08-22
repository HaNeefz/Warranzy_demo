import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class AddImageDemo extends StatefulWidget {
  final bool hasDataAssetAlready;
  final Map<String, dynamic> dataAsset;
  AddImageDemo({Key key, this.hasDataAssetAlready, this.dataAsset})
      : super(key: key);

  _AddImageDemoState createState() => _AddImageDemoState();
}

class _AddImageDemoState extends State<AddImageDemo> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  final Dio dio = Dio();
  List<ProductCatagory> listCat = [];
  ProductCatagory productCatagory = ProductCatagory();
  RelatedImage relatedImage;
  List<String> listRelated = [];
  List<ImageKeepData> listKeepImageData;

  @override
  void initState() {
    super.initState();

    listCat = productCatagory?.getListCat();
    relatedImage = RelatedImage(category: listCat[0]);
    listRelated = relatedImage.listRelatedImage();
    listKeepImageData = List<ImageKeepData>(listRelated.length);
    for (int i = 0; i < listRelated.length; i++) {
      listKeepImageData[i] =
          ImageKeepData(title: listRelated[i], imagesList: [], imageBase64: []);
    }
    print(widget.dataAsset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextBuilder.build(
            title: "Add Image Asset", style: TextStyleCustom.STYLE_APPBAR),
        actions: <Widget>[
          FlatButton(
            child: TextBuilder.build(title: allTranslations.text("submit")),
            onPressed: () async {
              print("Submit");
              ecsLib.showDialogLoadingLib(context,
                  content: "Image compressing");
              try {
                for (int i = 0; i < listKeepImageData.length; i++) {
                  var tempModelImage = listKeepImageData[i];
                  for (int j = 0; j < tempModelImage.imagesList.length; j++) {
                    var listImages = tempModelImage.imagesList[j];
                    var tempDir = await getTemporaryDirectory();
                    var _newSize = await ecsLib.compressFile(
                      file: listImages,
                      targetPath:
                          tempDir.path + "/${listImages.path.split("/").last}",
                      minWidth: 600,
                      minHeight: 480,
                      quality: 80,
                    );
                    listImages = _newSize;
                    tempModelImage.imageBase64[j] =
                        base64Encode(listImages.readAsBytesSync());
                    print(
                        "------ ${tempModelImage.title} No. $i => Image No. $j");
                  }
                }
              } catch (e) {
                print(e);
              }
              ecsLib.cancelDialogLoadindLib(context);
              var dataPost = {"Data": widget.dataAsset, "Images": {}};

              listKeepImageData.forEach((v) {
                dataPost['Images'].addAll({"${v.title}": v.imageBase64});
              });

              print(dataPost);
            },
          )
        ],
      ),
      body: Container(
          child: listRelated.length > 0
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: listRelated.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = listKeepImageData[index];
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("${data.title}\t\t"),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  child: data.imagesList.length > 0
                                      ? ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: data.imagesList.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 5, 0, 10),
                                              // width: 50.0,
                                              // height: 50.0,
                                              child: Image.file(
                                                data.imagesList[index],
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        )
                                      : Container(),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: RaisedButton(
                                    child: Icon(Icons.add),
                                    onPressed: () async {
                                      List<File> images = await ecsLib.pushPage(
                                          context: context,
                                          pageWidget: TakePhotos());
                                      print("return Images = ${images.length}");
                                      setState(() {
                                        if (images != null) {
                                          for (var fileImage in images) {
                                            data.imagesList.add(fileImage);
                                            data.imageBase64.add("temp");
                                          }
                                          print(data.imagesList.length);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  },
                )
              : Container(
                  child: Center(
                    child: Text("Empty data"),
                  ),
                )),
    );
  }
}

class TakePhotos extends StatefulWidget {
  TakePhotos({Key key}) : super(key: key);

  _TakePhotosState createState() => _TakePhotosState();
}

class _TakePhotosState extends State<TakePhotos> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  List<File> images = List<File>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Take a Photos',
          style: TextStyleCustom.STYLE_APPBAR,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            images.length > 0
                ? GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5),
                    itemCount: images.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: 100.0,
                        height: 100.0,
                        child: Image.file(
                          images[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  )
                : Center(
                    child: TextBuilder.build(
                        title: "Empty photos, Please take a photos."),
                  ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: TextBuilder.build(title: "Take a photo"),
                    onPressed: () async {
                      var image = await ecsLib.getImage();
                      print(image);
                      setState(() {
                        images.add(image);
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: RaisedButton(
                    child: TextBuilder.build(title: "Save"),
                    onPressed: () {
                      Navigator.pop(context, images);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImageKeepData {
  final String title;
  List<File> imagesList;
  List<String> imageBase64;

  ImageKeepData(
      {this.title, this.imagesList = const [], this.imageBase64 = const []});
}

class Name<T> {
  void getSomething(T value) {
    print(value);
  }
}
