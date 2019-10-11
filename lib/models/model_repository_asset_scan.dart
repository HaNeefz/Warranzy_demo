class RepositoryAssetScan {
  bool status;
  ModelDataScan data;
  String message;

  RepositoryAssetScan({this.status, this.data, this.message});

  RepositoryAssetScan.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    data =
        json['Data'] != null ? new ModelDataScan.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class ModelDataScan {
  String wTokenID;
  String manCode;
  String brandCode;
  String productID;
  String serialNo;
  String lotNo;
  String specDetail;
  String mFGDate;
  String sLCCode;
  String sLCBranchNo;
  String manName;
  String catCode;
  String productType;
  String model;
  String description;
  String productName;
  int monthOfWarranty;
  String groupID;
  List<String> fileImageID;
  String warrantyNo;

  ModelDataScan(
      {this.wTokenID,
      this.manCode,
      this.brandCode,
      this.productID,
      this.serialNo,
      this.lotNo,
      this.specDetail,
      this.mFGDate,
      this.sLCCode,
      this.sLCBranchNo,
      this.manName,
      this.catCode,
      this.productType,
      this.model,
      this.description,
      this.productName,
      this.monthOfWarranty,
      this.groupID,
      this.fileImageID,
      this.warrantyNo});

  ModelDataScan.fromJson(Map<String, dynamic> json) {
    wTokenID = json['WTokenID'];
    manCode = json['ManCode'];
    brandCode = json['BrandCode'];
    productID = json['ProductID'];
    serialNo = json['SerialNo'];
    lotNo = json['LotNo'];
    specDetail = json['SpecDetail'];
    mFGDate = json['MFGDate'];
    sLCCode = json['SLCCode'];
    sLCBranchNo = json['SLCBranchNo'];
    manName = json['ManName'];
    catCode = json['CatCode'];
    productType = json['ProductType'];
    model = json['Model'];
    description = json['Description'];
    productName = json['ProductName'];
    monthOfWarranty = json['MonthOfWarranty'];
    groupID = json['GroupID'];
    fileImageID = json['FileImage_ID'].cast<String>();
    warrantyNo = json['WarrantyNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['WTokenID'] = this.wTokenID;
    data['ManCode'] = this.manCode;
    data['BrandCode'] = this.brandCode;
    data['ProductID'] = this.productID;
    data['SerialNo'] = this.serialNo;
    data['LotNo'] = this.lotNo;
    data['SpecDetail'] = this.specDetail;
    data['MFGDate'] = this.mFGDate;
    data['SLCCode'] = this.sLCCode;
    data['SLCBranchNo'] = this.sLCBranchNo;
    data['ManName'] = this.manName;
    data['CatCode'] = this.catCode;
    data['ProductType'] = this.productType;
    data['Model'] = this.model;
    data['Description'] = this.description;
    data['ProductName'] = this.productName;
    data['MonthOfWarranty'] = this.monthOfWarranty;
    data['GroupID'] = this.groupID;
    data['FileImage_ID'] = this.fileImageID;
    data['WarrantyNo'] = this.warrantyNo;
    return data;
  }
}
