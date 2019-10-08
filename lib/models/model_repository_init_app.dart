import 'dart:convert' as jsonProvider;

import 'dart:convert';

class RepositoryInitalApp {
  bool status;
  String message;
  List<Country> country;
  List<TimeZone> timeZone;
  List<ProductCategory> productCategory;
  List<GroupCategory> groupCategory;

  RepositoryInitalApp(
      {this.status,
      this.message,
      this.country,
      this.timeZone,
      this.productCategory,
      this.groupCategory});

  RepositoryInitalApp.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Country'] != null) {
      country = new List<Country>();
      json['Country'].forEach((v) {
        country.add(new Country.fromJson(v));
      });
    }
    if (json['TimeZone'] != null) {
      timeZone = new List<TimeZone>();
      json['TimeZone'].forEach((v) {
        timeZone.add(new TimeZone.fromJson(v));
      });
    }
    if (json['ProductCategory'] != null) {
      productCategory = new List<ProductCategory>();
      json['ProductCategory'].forEach((v) {
        productCategory.add(new ProductCategory.fromJson(v));
      });
    }
    if (json['GroupCategory'] != null) {
      groupCategory = new List<GroupCategory>();
      json['GroupCategory'].forEach((v) {
        groupCategory.add(new GroupCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.country != null) {
      data['Country'] = this.country.map((v) => v.toJson()).toList();
    }
    if (this.timeZone != null) {
      data['TimeZone'] = this.timeZone.map((v) => v.toJson()).toList();
    }
    if (this.productCategory != null) {
      data['ProductCategory'] =
          this.productCategory.map((v) => v.toJson()).toList();
    }
    if (this.groupCategory != null) {
      data['GroupCategory'] =
          this.groupCategory.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Country {
  String code;
  String countryName;
  String area;
  String currency;
  int prefix;
  String priceSMS;
  String language;
  String updateDate;

  Country(
      {this.code,
      this.countryName,
      this.area,
      this.currency,
      this.prefix,
      this.priceSMS,
      this.language,
      this.updateDate});

  Country.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    countryName = json['CountryName'];
    area = json['Area'];
    currency = json['Currency'];
    prefix = json['Prefix'];
    priceSMS = json['PriceSMS'];
    language = json['Language'];
    updateDate = json['UpdateDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['CountryName'] = this.countryName;
    data['Area'] = this.area;
    data['Currency'] = this.currency;
    data['Prefix'] = this.prefix;
    data['PriceSMS'] = this.priceSMS;
    data['Language'] = this.language;
    data['UpdateDate'] = this.updateDate;
    return data;
  }
}

class TimeZone {
  String code;
  String timeZone;
  String gMT;
  String dST;
  String rawOffset;
  String updateDate;

  TimeZone(
      {this.code,
      this.timeZone,
      this.gMT,
      this.dST,
      this.rawOffset,
      this.updateDate});

  TimeZone.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    timeZone = json['TimeZone'];
    gMT = json['GMT'];
    dST = json['DST'];
    rawOffset = json['rawOffset'];
    updateDate = json['UpdateDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['TimeZone'] = this.timeZone;
    data['GMT'] = this.gMT;
    data['DST'] = this.dST;
    data['rawOffset'] = this.rawOffset;
    data['UpdateDate'] = this.updateDate;
    return data;
  }
}

class ProductCategory {
  String catCode;
  CatName modelCatName;
  String catName;
  String imageBox;
  String imageProduct;
  String imageDocument;
  String imageSerial;
  String imageChassisNo;
  String imageWarranty;
  String imageReceipt;
  String imageSellerCard;
  String imageOther;
  String lastUpdate;
  String groupID;
  String logo;
  String keepLogo;

  ProductCategory(
      {this.catCode,
      this.modelCatName,
      this.catName,
      this.imageBox,
      this.imageProduct,
      this.imageDocument,
      this.imageSerial,
      this.imageChassisNo,
      this.imageWarranty,
      this.imageReceipt,
      this.imageSellerCard,
      this.imageOther,
      this.lastUpdate,
      this.groupID,
      this.logo,
      this.keepLogo});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    catCode = json['CatCode'];
    modelCatName = json['CatName'] != null
        ? CatName.fromJson(jsonDecode(json['CatName']))
        : null;
    catName = json['CatName'];
    imageBox = json['Image_Box'];
    imageProduct = json['Image_Product'];
    imageDocument = json['Image_Document'];
    imageSerial = json['Image_Serial'];
    imageChassisNo = json['Image_ChassisNo'];
    imageWarranty = json['Image_Warranty'];
    imageReceipt = json['Image_Receipt'];
    imageSellerCard = json['Image_SellerCard'];
    imageOther = json['Image_Other'];
    lastUpdate = json['LastUpdate'];
    groupID = json['GroupID'];
    logo = json['Logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CatCode'] = this.catCode;
    data['CatName'] = this.catName;
    data['Image_Box'] = this.imageBox;
    data['Image_Product'] = this.imageProduct;
    data['Image_Document'] = this.imageDocument;
    data['Image_Serial'] = this.imageSerial;
    data['Image_ChassisNo'] = this.imageChassisNo;
    data['Image_Warranty'] = this.imageWarranty;
    data['Image_Receipt'] = this.imageReceipt;
    data['Image_SellerCard'] = this.imageSellerCard;
    data['Image_Other'] = this.imageOther;
    data['LastUpdate'] = this.lastUpdate;
    data['GroupID'] = this.groupID;
    data['Logo'] = this.logo;
    return data;
  }
}

class GroupCategory {
  String groupID;
  GroupName modelGroupName;
  String groupName;
  String lastUpdate;
  String logo;
  String keepLogo;
  GroupCategory(
      {this.groupID,
      this.modelGroupName,
      this.groupName,
      this.lastUpdate,
      this.logo,
      this.keepLogo});

  GroupCategory.fromJson(Map<String, dynamic> json) {
    groupID = json['GroupID'];
    modelGroupName = json['GroupName'] != null
        ? GroupName.fromJson(jsonDecode(json['GroupName']))
        : null;
    groupName = json['GroupName'];
    lastUpdate = json['LastUpdate'];
    logo = json['Logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GroupID'] = this.groupID;
    // if (this.groupName != null) data['GroupName'] = this.groupName;
    data['GroupName'] = this.groupName;
    data['LastUpdate'] = this.lastUpdate;
    data['Logo'] = this.logo;
    return data;
  }
}

class GroupName {
  String eN;
  String tH;

  GroupName({this.eN, this.tH});

  GroupName.fromJson(Map<String, dynamic> json) {
    eN = json['EN'];
    tH = json['TH'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EN'] = this.eN;
    data['TH'] = this.tH;
    return data;
  }
}

class RelatedImage {
  final ProductCategory category;
  List<String> _reletedImage = [];
  RelatedImage({this.category});

  List<String> listRelatedImage() {
    String wanted = "Y";
    if (category.imageProduct == wanted) _reletedImage.add("Image_Product");
    if (category.imageBox == wanted) _reletedImage.add("Image_Box");
    if (category.imageDocument == wanted) _reletedImage.add("Image_Document");
    if (category.imageSerial == wanted) _reletedImage.add("Image_Serial");
    if (category.imageChassisNo == wanted) _reletedImage.add("Image_ChassisNo");
    if (category.imageWarranty == wanted) _reletedImage.add("Image_Warranty");
    if (category.imageReceipt == wanted) _reletedImage.add("Image_Receipt");
    if (category.imageSellerCard == wanted)
      _reletedImage.add("Image_SellerCard");
    if (category.imageOther == wanted) _reletedImage.add("Image_Other");
    return _reletedImage;
  }
}

class CatName {
  String eN;
  String tH;

  CatName({this.eN, this.tH});

  CatName.fromJson(Map<String, dynamic> json) {
    // print("Before jsonDeocde => ${json['CatName']}");
    // var jsonDecode = jsonProvider.jsonDecode(json['CatName']);
    // print("After jsonDeocde => ${jsonDecode['CatName']}");
    eN = json['EN'];
    tH = json['TH'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EN'] = this.eN;
    data['TH'] = this.tH;
    return data;
  }
}
