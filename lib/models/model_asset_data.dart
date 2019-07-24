import 'package:flutter/material.dart';

class ModelAssetData {
  final int id;
  final String title;
  final String content;
  final String expire;
  final String category;
  final Widget image;

  ModelAssetData(
      {this.id,
      this.title,
      this.content,
      this.expire,
      this.category,
      this.image});

  List<ModelAssetData> listModelData = [];
  List<ModelAssetData> pushData() {
    for (var i = 0; i < 10; i++) {
      listModelData.add(ModelAssetData(
          id: i,
          title: "Dyson V7 Trigger",
          content:
              "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text.",
          expire: "Warranty Date : 24.05.2019 - 24.05.2020",
          category: "Category",
          image: null));
    }
    return listModelData;
  }
}

class ModelAssetsData {
  final int id;
  final String brandName;
  final String manuFacturerName;
  final String manuFacturerID;
  final String serialNo;
  final String lotNo;
  final String mfgDate;
  final String expireDate;
  final String productDetail;
  final String shopForSales;
  final String shopBranch;
  final String shopCountry;
  final String purchaseDate;
  final String warrantyNo;
  final String warrantyExpireDate;
  final String productCategory;
  final String productGroup;
  final String productPlace;
  final String productPrice;
  final String note;
  final Widget image;

  ModelAssetsData(
      {this.id,
      this.brandName,
      this.manuFacturerName,
      this.manuFacturerID,
      this.serialNo,
      this.lotNo,
      this.mfgDate,
      this.expireDate,
      this.productDetail,
      this.shopForSales,
      this.shopBranch,
      this.shopCountry,
      this.purchaseDate,
      this.warrantyNo,
      this.warrantyExpireDate,
      this.productCategory,
      this.productGroup,
      this.productPlace,
      this.productPrice,
      this.note,
      this.image});

  List<ModelAssetsData> listModelData = [];
  List<ModelAssetsData> pushData() {
    for (var i = 0; i < 10; i++) {
      listModelData.add(ModelAssetsData(
          id: i,
          brandName: "Dyson Electric",
          manuFacturerName: "Dyson V7 Trigger",
          manuFacturerID: "Dyson123456",
          serialNo: "DS12345678",
          lotNo: "DS000001",
          mfgDate: "01.05.18",
          expireDate: "12.09.19",
          productDetail:
              "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text.",
          shopForSales: "Central",
          shopBranch: "Powerbuy",
          shopCountry: "Bangkok",
          purchaseDate: "12.12.19",
          warrantyNo: "12.12.19",
          warrantyExpireDate: "12.12.22",
          productCategory: "Cleaning",
          productGroup: "Cleaning",
          productPlace: "Home",
          productPrice: "29,999 THB",
          note:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam",
          image: null));
    }
    return listModelData;
  }
}
