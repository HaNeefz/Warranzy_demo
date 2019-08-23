class RepositoryOfAsset {
  bool status;
  WarranzyUsed warranzyUsed;
  WarranzyLog warranzyLog;

  RepositoryOfAsset({this.status, this.warranzyUsed, this.warranzyLog});

  RepositoryOfAsset.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    warranzyUsed = json['WarranzyUsed'] != null
        ? new WarranzyUsed.fromJson(json['WarranzyUsed'])
        : null;
    warranzyLog = json['WarranzyLog'] != null
        ? new WarranzyLog.fromJson(json['WarranzyLog'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.warranzyUsed != null) {
      data['WarranzyUsed'] = this.warranzyUsed.toJson();
    }
    if (this.warranzyLog != null) {
      data['WarranzyLog'] = this.warranzyLog.toJson();
    }
    return data;
  }
}

class WarranzyUsed {
  String wTokenID;
  String custUserID;
  String custCountryCode;
  String pdtCatCode;
  String pdtGroup;
  String pdtPlace;
  String brandCode;
  String title;
  String serialNo;
  String lotNo;
  String salesPrice;
  String warrantyNo;
  String warrantyExpire;
  String custRemark;
  String createType;
  String createDate;
  String lastModiflyDate;
  String exWarrantyStatus;
  String tradeStatus;

  WarranzyUsed(
      {this.wTokenID,
      this.custUserID,
      this.custCountryCode,
      this.pdtCatCode,
      this.pdtGroup,
      this.pdtPlace,
      this.brandCode,
      this.title,
      this.serialNo,
      this.lotNo,
      this.salesPrice,
      this.warrantyNo,
      this.warrantyExpire,
      this.custRemark,
      this.createType,
      this.createDate,
      this.lastModiflyDate,
      this.exWarrantyStatus,
      this.tradeStatus});

  WarranzyUsed.fromJson(Map<String, dynamic> json) {
    wTokenID = json['WTokenID'];
    custUserID = json['CustUserID'];
    custCountryCode = json['CustCountryCode'];
    pdtCatCode = json['PdtCatCode'];
    pdtGroup = json['PdtGroup'];
    pdtPlace = json['PdtPlace'];
    brandCode = json['BrandCode'];
    title = json['Title'];
    serialNo = json['SerialNo'];
    lotNo = json['LotNo'];
    salesPrice = json['SalesPrice'];
    warrantyNo = json['WarrantyNo'];
    warrantyExpire = json['WarrantyExpire'];
    custRemark = json['CustRemark'];
    createType = json['CreateType'];
    createDate = json['CreateDate'];
    lastModiflyDate = json['LastModiflyDate'];
    exWarrantyStatus = json['ExWarrantyStatus'];
    tradeStatus = json['TradeStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['WTokenID'] = this.wTokenID;
    data['CustUserID'] = this.custUserID;
    data['CustCountryCode'] = this.custCountryCode;
    data['PdtCatCode'] = this.pdtCatCode;
    data['PdtGroup'] = this.pdtGroup;
    data['PdtPlace'] = this.pdtPlace;
    data['BrandCode'] = this.brandCode;
    data['Title'] = this.title;
    data['SerialNo'] = this.serialNo;
    data['LotNo'] = this.lotNo;
    data['SalesPrice'] = this.salesPrice;
    data['WarrantyNo'] = this.warrantyNo;
    data['WarrantyExpire'] = this.warrantyExpire;
    data['CustRemark'] = this.custRemark;
    data['CreateType'] = this.createType;
    data['CreateDate'] = this.createDate;
    data['LastModiflyDate'] = this.lastModiflyDate;
    data['ExWarrantyStatus'] = this.exWarrantyStatus;
    data['TradeStatus'] = this.tradeStatus;
    return data;
  }
}

class WarranzyLog {
  String wTokenID;
  String logDate;
  String logType;
  String partyCode;
  String partyCountryCode;
  String warrantyNo;
  String warranzyEndDate;
  String fileAttachID;

  WarranzyLog(
      {this.wTokenID,
      this.logDate,
      this.logType,
      this.partyCode,
      this.partyCountryCode,
      this.warrantyNo,
      this.warranzyEndDate,
      this.fileAttachID});

  WarranzyLog.fromJson(Map<String, dynamic> json) {
    wTokenID = json['WTokenID'];
    logDate = json['LogDate'];
    logType = json['LogType'];
    partyCode = json['PartyCode'];
    partyCountryCode = json['PartyCountryCode'];
    warrantyNo = json['WarrantyNo'];
    warranzyEndDate = json['WarranzyEndDate'];
    fileAttachID = json['FileAttach_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['WTokenID'] = this.wTokenID;
    data['LogDate'] = this.logDate;
    data['LogType'] = this.logType;
    data['PartyCode'] = this.partyCode;
    data['PartyCountryCode'] = this.partyCountryCode;
    data['WarrantyNo'] = this.warrantyNo;
    data['WarranzyEndDate'] = this.warranzyEndDate;
    data['FileAttach_ID'] = this.fileAttachID;
    return data;
  }
}
