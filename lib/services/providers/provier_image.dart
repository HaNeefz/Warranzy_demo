import 'dart:io';

import 'package:flutter/material.dart';

class ImageDataState with ChangeNotifier {
  List<File> _imageData = List<File>();
  List<File> get amountImage => _imageData;

  set addImageToList(File image) {
    _imageData.add(image);    
    notifyListeners();
  }

  int get imageLength => _imageData.length;

  bool get limitImage => _imageData.length == 4;

  removeAll() => _imageData.clear();

  set remove(int index) {
    _imageData.removeAt(index);
    notifyListeners();
  }
}
