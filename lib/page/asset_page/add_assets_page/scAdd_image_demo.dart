import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/services/api/base_url.dart';
import 'package:warranzy_demo/services/api/jwt_service.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
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

  getPrudcutCategory() async {
    var catTemp = await DBProviderInitialApp.db.getAllDataProductCategory();
    ProductCatagory category;
    catTemp.forEach((v) {
      if (v.catCode == widget.dataAsset['PdtCatCode']) {
        setState(() {
          category = v;
        });
        return;
      }
    });
    relatedImage = RelatedImage(category: category);
    listRelated = relatedImage.listRelatedImage();
    listKeepImageData = List<ImageKeepData>(listRelated.length);
    for (int i = 0; i < listRelated.length; i++) {
      listKeepImageData[i] =
          ImageKeepData(title: listRelated[i], imagesList: [], imageBase64: []);
    }
  }

  @override
  void initState() {
    super.initState();
    getPrudcutCategory();
    ecsLib.printJson(widget.dataAsset);
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

              listKeepImageData.forEach((modelImage) {
                modelImage.imageBase64.forEach((imageBase64) {
                  dataPost['Images'].addAll({
                    "${modelImage.title}": {
                      "${modelImage.imageBase64.indexOf(imageBase64)}":
                          imageBase64
                    }
                  });
                });
              });
              ecsLib.printJson(dataPost);

              FormData formData = FormData.from(dataPost);
              ecsLib.showDialogLoadingLib(context, content: "Adding assets");
              try {
                print(
                    "sending Api URL => https://testwarranty-239103.appspot.com/API/v1/Asset/AddAsset");
                await dio
                    .post(
                  "https://testwarranty-239103.appspot.com/API/v1/Asset/AddAsset",
                  //http://192.168.0.36:9999/API/v1/Asset/AddAsset
                  data: formData,
                  options: Options(
                    headers: {"Authorization": await JWTService.getTokenJWT()},
                  ),
                )
                    .then((res) async {
                  print("<--- Response");
                  ecsLib.printJson(jsonDecode(res.data));
                  ecsLib.cancelDialogLoadindLib(context);
                  var temp = RepositoryOfAsset.fromJson(jsonDecode(res.data));
                  try {
                    await DBProviderAsset.db
                        .insertDataWarranzyUesd(temp.warranzyUsed)
                        .catchError(
                            (onError) => print("warranzyUsed : $onError"));
                  } catch (e) {
                    print("insertDataWarranzyUesd => $e");
                  }
                  try {
                    await DBProviderAsset.db
                        .insertDataWarranzyLog(temp.warranzyLog)
                        .catchError((onError) => print("warranzyLog $onError"));
                  } catch (e) {
                    print("insertDataWarranzyLog => $e");
                  }
                  temp.filePool.forEach((data) async {
                    try {
                      await DBProviderAsset.db
                          .insertDataFilePool(data)
                          .catchError((onError) => print("filePool $onError"))
                          .whenComplete(() {
                        ecsLib.stepBackScene(context, 2);
                      });
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
                                      setState(() {
                                        if (images != null) {
                                          print(
                                              "return Images = ${images.length}");
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_a_photo),
          onPressed: () async {
            var image = await ecsLib.getImage();
            print(image);
            if (image != null) {
              setState(() {
                images.add(image);
              });
            }
          },
        ));
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
