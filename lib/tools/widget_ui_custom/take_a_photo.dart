import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:warranzy_demo/models/model_image_data_each_group.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';

import 'image_list_builder.dart';
import 'text_builder.dart';

class TakePhotos extends StatefulWidget {
  final String title;
  final List<File> images;
  final ImageDataEachGroup imageEachGroup;
  TakePhotos({Key key, this.title, this.images, this.imageEachGroup})
      : super(key: key);

  _TakePhotosState createState() => _TakePhotosState();
}

class _TakePhotosState extends State<TakePhotos> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  List<File> images = [];
  List<String> listImagekeyForGetSQLite = [];
  List<String> listTempKey = [];

  getImageFromSQLite(List<String> listKey) async {
    listKey.forEach((key) async {
      await DBProviderAsset.db.getImagePoolReturn(key).then((data) {
        setState(() {
          listImagekeyForGetSQLite.add(data.first.fileData);
          listTempKey.add(key);
        });
        print("listImagekey : $listImagekeyForGetSQLite");
      });
    });
  }

  Future<String> imageFileToBase64(File file) async {
    Directory tempDir = await getTemporaryDirectory();
    print("begin changeImageFileToBase64");
    File _newSized = await ecsLib.compressFile(
      file: file,
      targetPath: tempDir.path + "/${file.path.split("/").last}",
      minWidth: 600,
      minHeight: 480,
      quality: 80,
    );
    return _newSized != null ? base64Encode(_newSized.readAsBytesSync()) : null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.imageEachGroup.tempBase64.length > 0) {
      setState(() =>
          listImagekeyForGetSQLite = List.of(widget.imageEachGroup.tempBase64));
    } else {
      // if (widget.imageEachGroup.imagesList.length > 0) {
      //   widget.imageEachGroup.imagesList.forEach((file) async {
      //     listImagekeyForGetSQLite.add(await imageFileToBase64(file));
      //     setState(() {});
      //   });
      // }
      if (widget.imageEachGroup.imageBase64.length > 0) {
        getImageFromSQLite(widget.imageEachGroup.imageBase64);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title ?? 'Take a Photos',
            style: TextStyleCustom.STYLE_APPBAR,
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                widget.imageEachGroup.imagesList = images;
                widget.imageEachGroup.imageBase64 = listTempKey;
                widget.imageEachGroup.tempBase64 = listImagekeyForGetSQLite;
                Navigator.pop(context, widget.imageEachGroup);
              }),
        ),
        body: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: listImagekeyForGetSQLite.length > 0 || images.length > 0
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              if (listImagekeyForGetSQLite.length > 0)
                                ImageListBuilder.build(
                                    context: context,
                                    imageData: listImagekeyForGetSQLite,
                                    isImageBase64: true,
                                    crossAxisCount: 2,
                                    heroTag: "imageOld",
                                    editAble: true,
                                    onClicked: (index) {
                                      print("ImageOld indexOf($index)");
                                      if (listImagekeyForGetSQLite.length > 0)
                                        setState(() {
                                          listImagekeyForGetSQLite
                                              .removeAt(index);
                                          // listTempKey.removeAt(index);
                                        });
                                    }),
                              // Divider(),
                              // if (images.length > 0)
                              //   ImageListBuilder.build(
                              //       context: context,
                              //       imageData: images,
                              //       crossAxisCount: 2,
                              //       heroTag: "imageOldFile",
                              //       editAble: true,
                              //       onClicked: (index) {
                              //         print("ImageOld indexOf($index)");
                              //         if (images.length > 0)
                              //           setState(() {
                              //             images.removeAt(index);
                              //           });
                              //       }),
                            ],
                          )
                        ],
                      )
                    : Center(
                        child: TextBuilder.build(
                            title: "Empty photos, Please take a photos."))),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "TakePhoto",
              child: Icon(Icons.add_a_photo, size: 35),
              onPressed: () async {
                var image = await ecsLib.getImage();
                // print(image);
                if (image != null) {
                  listImagekeyForGetSQLite.add(await imageFileToBase64(image));
                  setState(() {
                    // images.add(image);
                    // print("images : $images");
                  });
                }
              },
            ),
            SizedBox(
              height: 5,
            ),
            FloatingActionButton(
              backgroundColor: Colors.red[200],
              heroTag: "Gallery",
              child: Icon(
                Icons.add_photo_alternate,
                size: 35,
              ),
              onPressed: () async {
                var image = await ecsLib.getImageFromGallery();
                // print(image);
                if (image != null) {
                  listImagekeyForGetSQLite.add(await imageFileToBase64(image));
                  setState(() {
                    // images.add(image);
                    // print("images : $images");
                  });
                }
              },
            ),
          ],
        ));
  }
}
