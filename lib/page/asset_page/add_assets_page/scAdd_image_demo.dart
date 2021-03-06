import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:warranzy_demo/models/model_image_data_each_group.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/page/main_page/scMain_page.dart';
import 'package:warranzy_demo/services/api/api_service_assets.dart';
import 'package:warranzy_demo/services/api/repository.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/image_list_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/take_a_photo.dart';
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
  List<ProductCategory> listCat = [];
  ProductCategory productCatagory = ProductCategory();
  RelatedImage relatedImage;
  List<String> listRelated = [];
  List<ImageDataEachGroup> listKeepImageData;

  getPrudcutCategory() async {
    var catTemp = await DBProviderInitialApp.db.getAllDataProductCategory();
    ProductCategory category;
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
    listKeepImageData = List<ImageDataEachGroup>(listRelated.length);
    for (int i = 0; i < listRelated.length; i++) {
      listKeepImageData[i] = ImageDataEachGroup(
          title: listRelated[i], imagesList: [], imageBase64: []);
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
            onPressed: submitAsset,
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
                    return Column(
                      children: <Widget>[
                        ListTile(
                          title: Text("${data.title}\t\t"),
                          trailing: Container(
                            // color: Colors.red,
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("${data.imagesList.length}"),
                                Text("Items"),
                                Icon(Icons.add_circle),
                              ],
                            ),
                          ),
                          onTap: () async {
                            List<File> images = await ecsLib.pushPage(
                                context: context,
                                pageWidget: TakePhotos(
                                  title: data.title,
                                  images: data.imagesList,
                                ));
                            setState(() {
                              if (images != null) {
                                print("return Images = ${images.length}");
                                data.imagesList = images;
                                data.imageBase64.clear();
                                for (var fileImage in images) {
                                  data.imageBase64.add("${fileImage.path}");
                                }
                                print(data.imagesList.length);
                              }
                            });
                          },
                        ),
                        Divider()
                      ],
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

  submitAsset() async {
    var dataPost = {"Data": widget.dataAsset, "Images": {}};
    print("Submit");
    ecsLib.showDialogLoadingLib(context, content: "Image compressing");
    try {
      for (int i = 0; i < listKeepImageData.length; i++) {
        var tempModelImage = listKeepImageData[i];
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
        for (var modelImage in listKeepImageData) {
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
      Repository.addAsset(body: dataPost)
          .timeout(Duration(seconds: 60))
          .then((res) async {
        print("<--- Response");
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
                .whenComplete(() {
              ecsLib.pushPageAndClearAllScene(
                  context: context, pageWidget: MainPage());
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
  }
}

class Name<T> {
  void getSomething(T value) {
    print(value);
  }
}

// data.imagesList.length > 0
//     ? ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: data.imagesList.length,
//         shrinkWrap: true,
//         itemBuilder: (BuildContext context,
//             int index) {
//           return Container(
//               margin: EdgeInsets.fromLTRB(
//                   10, 5, 0, 10),
//               // width: 50.0,
//               // height: 50.0,
//               child: TextBuilder.build(
//                   title:
//                       "Images have ${data.imagesList.length}")
//               // Image.file(
//               //   data.imagesList[index],
//               //   fit: BoxFit.cover,
//               // ),
//               );
//         },
//       )
//     : Container(),
