import 'package:cloud_firestore/cloud_firestore.dart';

class SearchBrandName {
  static Future<QuerySnapshot> searchByName({String searchField}) async {
    return await Firestore.instance
        .collection("BrandName")
        .where("BrandName.EN", isGreaterThanOrEqualTo: searchField) //SearchKey
        .getDocuments();
  }
  static getBrandName() {
    return Firestore.instance.collection("BrandName").snapshots();
  }
}
