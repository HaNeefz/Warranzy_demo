import 'dart:convert' as jsonProvider;

class RepositoryInitalApp {
  bool status;
  List<Country> country;
  List<TimeZone> timeZone;
  List<ProductCatagory> productCatagory;

  RepositoryInitalApp(
      {this.status, this.country, this.timeZone, this.productCatagory});

  RepositoryInitalApp.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
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
    if (json['ProductCatagory'] != null) {
      productCatagory = new List<ProductCatagory>();
      json['ProductCatagory'].forEach((v) {
        productCatagory.add(new ProductCatagory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.country != null) {
      data['Country'] = this.country.map((v) => v.toJson()).toList();
    }
    if (this.timeZone != null) {
      data['TimeZone'] = this.timeZone.map((v) => v.toJson()).toList();
    }
    if (this.productCatagory != null) {
      data['ProductCatagory'] =
          this.productCatagory.map((v) => v.toJson()).toList();
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

class ProductCatagory {
  String catCode;
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

  ProductCatagory(
      {this.catCode,
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
      this.lastUpdate});

  ProductCatagory.fromJson(Map<String, dynamic> json) {
    catCode = json['CatCode'];
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
    return data;
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
