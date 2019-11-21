import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:warranzy_demo/models/model_get_brand_name.dart';

class FirestoreState extends ChangeNotifier {
  final Firestore _firestore = Firestore();
  FirestoreState();
  bool isFetching = false;
  bool isFetchingBrandName = false;
  List<GetBrandName> _allBrands = [];
  String _brandName;
  String _documentID;

  List<GetBrandName> get allBrand => _allBrands;
  String get brandName => _brandName;
  String get documentID => _documentID;

  fetchBrands() {
    _firestore.collection("BrandName").getDocuments().then((querySnapshot) {
      if (querySnapshot.documents.length > 0) {
        querySnapshot.documents.forEach((brands) {
          Map<String, dynamic> brandsData = {
            "DocumentID": "${brands.documentID}"
          };
          brandsData.addAll(brands.data);
          _allBrands.add(GetBrandName.fromJson(brandsData));
          isFetchingBrandName = true;
        });
      }
    });
  }

  String getBrandName({@required String documentID}) {
    String tempName;
    if (_allBrands.length > 0) {
      var temp = _allBrands.where((brands) => brands.documentID == documentID);
      if (temp.toList().length > 0) {
        tempName = temp.first.modelBrandName.modelEN.en;
        notifyListeners();
        return tempName;
      } else {
        return null;
      }
    } else
      return null;
  }
}
