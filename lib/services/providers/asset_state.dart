import 'package:flutter/widgets.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';

class AssetState extends ChangeNotifier {
  AssetState();

  bool _isFetching = false;
  List<ModelDataAsset> _assets = [];

  List<ModelDataAsset> get assets => _assets;
  bool get isFecthing => _isFetching;

  Future<void> fetchData() async {
    _assets = await DBProviderAsset.db.getAllDataAsset();
    if (_assets.length > 0) {
      _isFetching = true;
      notifyListeners();
    }
  }
}
