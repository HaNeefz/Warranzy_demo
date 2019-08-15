import 'dart:convert' as jsonProvider;

class GetBrandName {
  ModelBrandName modelBrandName;
  String description;
  String manCode;
  String lastUpdate;
  String fileIDLogo;
  String brandActive;

  GetBrandName(
      {this.modelBrandName,
      this.description,
      this.manCode,
      this.lastUpdate,
      this.fileIDLogo,
      this.brandActive});

  GetBrandName.fromJson(Map<String, dynamic> json) {
    modelBrandName =
        json['BrandName'] != null ? new ModelBrandName.fromJson(json) : null;
    description = json['Description'];
    manCode = json['ManCode'];
    lastUpdate = json['LastUpdate'];
    brandActive = json['BrandActive'];
    fileIDLogo = json['FileID_Logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.modelBrandName != null) {
      data['BrandName'] = this.modelBrandName;
    }
    data['Description'] = this.description;
    data['ManCode'] = this.manCode;
    data['LastUpdate'] = this.lastUpdate;
    data['FileID_Logo'] = this.fileIDLogo;
    data['BrandActive'] = this.brandActive;
    return data;
  }
}

class ModelBrandName {
  String brandName;
  ModelEN modelEN;

  ModelBrandName({this.brandName, this.modelEN});

  ModelBrandName.fromJson(Map<String, dynamic> json) {
    brandName = json['BrandName'];
    var jsonDecode = jsonProvider.jsonDecode(json['BrandName']);
    if (json['BrandName'] != null) modelEN = ModelEN.fromJson(jsonDecode);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrandName'] = this.brandName;
    return data;
  }
}

class ModelEN {
  String en;

  ModelEN({this.en});

  ModelEN.fromJson(Map<String, dynamic> json) {
    var jsonDecode = json['EN'];
    en = jsonDecode;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrandName']['en'] = this.en;
    return data;
  }
}
