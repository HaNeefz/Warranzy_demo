import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/services/sqflit/db_asset.dart';

class AssetState extends ChangeNotifier {
  AssetState() {
    fetchData();
  }

  bool _isFetching = false;
  List<ModelDataAsset> _assets = [];

  List<ModelDataAsset> get assets => _assets;
  bool get isFecthing => _isFetching;

  Future<void> fetchData() async {
    // _isFetching = false;
    // notifyListeners();
    _assets = await DBProviderAsset.db.getAllDataAsset();
    // _isFetching = true;
    // notifyListeners();
  }

  int showCurrent(ModelDataAsset object) {
    return _assets.indexOf(object);
  }

  addDataAsset(ModelDataAsset object, String wTokenID) {
    print("=============Data Before Add=================");
    print("wTokenID -> : ${object.wTokenID}");
    print("Name : ${object.title}");
    print("FileAttach : ${object.fileAttachID}");
    print("CreateType : ${object.createType}");
    print("==============================");
    _assets.add(object);
    print("Added Asset WTokenID : ${_assets.last.wTokenID}");
    print("------------------------------");
    notifyListeners();
    _assets.forEach((data) {
      print("=============Data After Add=================");
      print("wTokenID -> : ${data.wTokenID}");
      print("Name : ${data.title}");
      print("FileAttach : ${data.fileAttachID}");
      print("CreateType : ${data.createType}");
      print("------------------------------");
    });
  }

  updateDataAsset(ModelDataAsset object) {
    _assets[_assets.indexOf(object)] = object;
    notifyListeners();
  }

  deletedAsset({String wTokenID}) {
    var temp = _assets.where((item) => item.wTokenID == wTokenID);
    if (temp.length > 0) {
      if (_assets.remove(temp.first) == true) {
        notifyListeners();
      }
    }
  }

  set editAsset(Map<String, dynamic> dataAsset) {}
}

class AssetStateTest {
  BehaviorSubject<List<ModelDataAsset>> _subjectAsset;

  AssetStateTest({List<ModelDataAsset> assets}) {
    _subjectAsset = BehaviorSubject<List<ModelDataAsset>>.seeded(assets ?? []);
    initAsset();
  }
  bool _isFetching = false;
  List<ModelDataAsset> _assets = [];

  Observable<List<ModelDataAsset>> get stream => _subjectAsset.stream;
  bool get isFetching => _isFetching;

  initAsset() async {
    _isFetching = true;
    _assets = await DBProviderAsset.db.getAllDataAsset();
    _isFetching = false;
    _subjectAsset.sink.add(_assets);
  }

  void addAsset(ModelDataAsset object) {
    _assets.add(object);
    _subjectAsset.sink.add(_assets);
  }

  void removeAsset(String currentAsset) {
    var temp = _assets.where((asset) => asset.wTokenID == currentAsset);
    if (temp.length > 0) {
      if (_assets.remove(temp.first) == true) {
        _subjectAsset.sink.add(_assets);
      }
    } else {
      print("Not found Asset at WTokenID : $currentAsset.");
    }
  }

  void dispose() {
    _subjectAsset.close();
  }
}
