import 'package:flutter/widgets.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';

class AssetState extends ChangeNotifier {
  List<ModelDataAsset> _allAsset = [];
  Future<List<ModelDataAsset>> tempAllAssets;
  
  Future<List<ModelDataAsset>> get allAssets async {
    _allAsset = await DBProviderAsset.db.getAllDataAsset();
    return _allAsset;
  }

  Future<List<ModelDataAsset>> getAllAssets() async {
    if (tempAllAssets == null) {
      return allAssets;
    } else {
      return tempAllAssets;
    }
  }

  refreshAsset() async {
    _allAsset = await DBProviderAsset.db.getAllDataAsset();
    notifyListeners();
  }
}
