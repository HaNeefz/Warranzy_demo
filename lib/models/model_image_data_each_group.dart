import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';
import 'package:warranzy_demo/tools/ECS_lib.dart';

import '../main.dart';

class ImageDataEachGroup {
  String title;
  List<File> imagesList;
  List<String> imageBase64;
  List<String> imageUrl;
  List<Uint8List> imageUint8List;
  List<String> tempBase64;
  static final _ecsLib = getIt.get<ECSLib>();

  ImageDataEachGroup(
      {this.title,
      this.imagesList = const [],
      this.imageBase64 = const [],
      this.imageUint8List = const [],
      this.tempBase64 = const [],
      this.imageUrl = const []});

  // ImageDataEachGroup.
  Future<ImageDataEachGroup> changeToBase64(ImageDataEachGroup images) async {
    Completer<ImageDataEachGroup> completer = Completer();
    ImageDataEachGroup _images = images;
    if (images.imagesList.length > 0) {
      images.imagesList.forEach((tempImageList) {
        _images.tempBase64.add(base64Encode(tempImageList.readAsBytesSync()));
        print("_images.tempBase64 : ${_images.tempBase64}");
      });
    }
    if (images.imageBase64.length > 0) {
      images.imageBase64.forEach((String imageKey) async {
        await DBProviderAsset.db.getImagePoolReturn(imageKey).then((fileData) {
          _images.tempBase64.add(fileData.first.fileData);
          print("fileData.first.fileData : ${_images.tempBase64}");
          completer.complete(_images);
        });
      });
    }
    return completer.future;
  }

  static Future<String> changeImageFileToBase64(File imageFile) async {
    Completer<String> _completer = Completer<String>();
    // File _newSize;
    Directory tempDir = await getTemporaryDirectory();
    print("begin changeImageFileToBase64");
    await _ecsLib
        .compressFile(
      file: imageFile,
      targetPath: tempDir.path + "/${imageFile.path.split("/").last}",
      minWidth: 600,
      minHeight: 480,
      quality: 80,
    )
        .then((newFile) {
      // print("_newSize : ${base64Encode(newFile.readAsBytesSync())}");
      _completer.complete(base64Encode(newFile.readAsBytesSync()));
      print("end");
    });
    return _completer.future;
  }

  static Future<String> changeImageKeyToBase64(String imageKey) async {
    Completer<String> _completer = Completer<String>();
    print("begin changeImageKeyToBase64");

    await DBProviderAsset.db.getImagePoolReturn(imageKey).then((v) {
      // print("temp : ${v.first.fileData}");
      _completer.complete(v.first.fileData);
      print("end");
    });

    return _completer.future;
  }
}
