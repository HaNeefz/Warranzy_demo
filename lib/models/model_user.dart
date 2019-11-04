import 'dart:convert';

class RepositoryUser {
  bool status;
  ModelCustomers data;
  DataAssetUsed dataAssetUsed;
  String message;

  RepositoryUser({this.status, this.data, this.dataAssetUsed, this.message});

  RepositoryUser.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    data =
        json['Data'] != null ? new ModelCustomers.fromJson(json['Data']) : null;
    dataAssetUsed = json['Data_Asset_Used'] != null
        ? new DataAssetUsed.fromJson(json['Data_Asset_Used'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (this.dataAssetUsed != null) {
      data['Data_Asset_Used'] = this.dataAssetUsed.toJson();
    }
    return data;
  }
}

class ModelCustomers {
  String custName;
  String homeAddress;
  String countryCode;
  String custEmail;
  String mobilePhone;
  String notificationID;
  String pINcode;
  String deviceID;
  String packageType;
  String gender;
  String birthYear;
  String specialPass;
  String createDate;
  String custUserID;

  ModelCustomers(
      {this.custName,
      this.homeAddress,
      this.countryCode,
      this.custEmail,
      this.mobilePhone,
      this.notificationID,
      this.pINcode,
      this.deviceID,
      this.packageType,
      this.gender,
      this.birthYear,
      this.specialPass,
      this.createDate,
      this.custUserID});

  ModelCustomers.fromJson(Map<String, dynamic> json) {
    custName = json['CustName'];
    homeAddress = json['HomeAddress'];
    countryCode = json['CountryCode'];
    custEmail = json['CustEmail'];
    mobilePhone = json['MobilePhone'];
    notificationID = json['NotificationID'];
    pINcode = json['PINcode'];
    deviceID = json['DeviceID'];
    packageType = json['PackageType'];
    gender = json['Gender'];
    birthYear = json['BirthYear'];
    specialPass = json['SpecialPass'];
    createDate = json['CreateDate'];
    custUserID = json['CustUserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustName'] = this.custName;
    data['HomeAddress'] = this.homeAddress;
    data['CountryCode'] = this.countryCode;
    data['CustEmail'] = this.custEmail;
    data['MobilePhone'] = this.mobilePhone;
    data['NotificationID'] = this.notificationID;
    data['PINcode'] = this.pINcode;
    data['DeviceID'] = this.deviceID;
    data['PackageType'] = this.packageType;
    data['Gender'] = this.gender;
    data['BirthYear'] = this.birthYear;
    data['SpecialPass'] = this.specialPass;
    data['CreateDate'] = this.createDate;
    data['CustUserID'] = this.custUserID;
    return data;
  }
}

class DataAssetUsed {
  List<WarranzyUsed> warranzyUsed;
  List<WarranzyLog> warranzyLog;
  List<FilePool> filePool;

  DataAssetUsed({this.warranzyUsed, this.warranzyLog, this.filePool});

  DataAssetUsed.fromJson(Map<String, dynamic> json) {
    if (json['WarranzyUsed'] != null) {
      warranzyUsed = new List<WarranzyUsed>();
      json['WarranzyUsed'].forEach((v) {
        warranzyUsed.add(new WarranzyUsed.fromJson(v));
      });
    }
    if (json['WarranzyLog'] != null) {
      warranzyLog = new List<WarranzyLog>();
      json['WarranzyLog'].forEach((v) {
        warranzyLog.add(new WarranzyLog.fromJson(v));
      });
    }
    if (json['FilePool'] != null) {
      filePool = new List<FilePool>();
      json['FilePool'].forEach((v) {
        filePool.add(new FilePool.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.warranzyUsed != null) {
      data['WarranzyUsed'] = this.warranzyUsed.map((v) => v.toJson()).toList();
    }
    if (this.warranzyLog != null) {
      data['WarranzyLog'] = this.warranzyLog.map((v) => v.toJson()).toList();
    }
    if (this.filePool != null) {
      data['FilePool'] = this.filePool.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WarranzyUsed {
  String wTokenID;
  String custBuyDate;
  String custUserID;
  String custCountryCode;
  String pdtCatCode;
  String pdtGroup;
  String pdtPlace;
  String custRemark;
  String manCode;
  String brandCode;
  String productID;
  String serialNo;
  String lotNo;
  String mFGDate;
  String eXPDate;
  dynamic salesPrice;
  String createDate;
  String createType;
  String lastModiflyDate;
  String warrantyNo;
  String warrantyExpire;
  String sLCCode;
  String sLCBranchNo;
  String sLCCountryCode;
  String blockchainID;
  String exWarrantyStatus;
  String tradeStatus;
  String title;
  String sLCName;
  CatName modelCatName;
  BrandName modelBrandName;
  String alertDate;

  WarranzyUsed(
      {this.wTokenID,
      this.custBuyDate,
      this.custUserID,
      this.custCountryCode,
      this.pdtCatCode,
      this.pdtGroup,
      this.pdtPlace,
      this.custRemark,
      this.manCode,
      this.brandCode,
      this.productID,
      this.serialNo,
      this.lotNo,
      this.mFGDate,
      this.eXPDate,
      this.salesPrice,
      this.createDate,
      this.createType,
      this.lastModiflyDate,
      this.warrantyNo,
      this.warrantyExpire,
      this.sLCCode,
      this.sLCBranchNo,
      this.sLCCountryCode,
      this.blockchainID,
      this.exWarrantyStatus,
      this.tradeStatus,
      this.title,
      this.sLCName,
      this.modelCatName,
      this.modelBrandName,
      this.alertDate});

  WarranzyUsed.fromJson(Map<String, dynamic> json) {
    wTokenID = json['WTokenID'];
    custBuyDate = json['CustBuyDate'];
    custUserID = json['CustUserID'];
    custCountryCode = json['CustCountryCode'];
    pdtCatCode = json['PdtCatCode'];
    modelCatName = json['CatName'] != null
        ? CatName.fromJson(jsonDecode(json['CatName']))
        : null;
    pdtGroup = json['PdtGroup'];
    pdtPlace = json['PdtPlace'];
    custRemark = json['CustRemark'];
    manCode = json['ManCode'];
    brandCode = json['BrandCode'];
    modelBrandName = json['BrandName'] != null
        ? BrandName.fromJson(jsonDecode(json['BrandName']))
        : null;
    productID = json['ProductID'];
    serialNo = json['SerialNo'];
    lotNo = json['LotNo'];
    mFGDate = json['MFGDate'];
    eXPDate = json['EXPDate'];
    salesPrice = json['SalesPrice'];
    createDate = json['CreateDate'];
    createType = json['CreateType'];
    lastModiflyDate = json['LastModiflyDate'];
    warrantyNo = json['WarrantyNo'];
    warrantyExpire = json['WarrantyExpire'];
    sLCCode = json['SLCCode'];
    sLCBranchNo = json['SLCBranchNo'];
    sLCCountryCode = json['SLCCountryCode'];
    blockchainID = json['BlockchainID'];
    exWarrantyStatus = json['ExWarrantyStatus'];
    tradeStatus = json['TradeStatus'];
    title = json['Title'];
    sLCName = json['SLCName'];
    alertDate = json['AlertDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['WTokenID'] = this.wTokenID;
    data['CustBuyDate'] = this.custBuyDate;
    data['CustUserID'] = this.custUserID;
    data['CustCountryCode'] = this.custCountryCode;
    data['PdtCatCode'] = this.pdtCatCode;
    // if (data != null) data['CatName'] = this.modelCatName.toJson();
    // if (data != null) data['BrandName'] = this.modelBrandName.toJson();
    // data['CatName'] = this.modelCatName;
    // data['BrandName'] = this.modelBrandName;
    data['PdtGroup'] = this.pdtGroup;
    data['PdtPlace'] = this.pdtPlace;
    data['CustRemark'] = this.custRemark;
    data['ManCode'] = this.manCode;
    data['BrandCode'] = this.brandCode;
    data['ProductID'] = this.productID;
    data['SerialNo'] = this.serialNo;
    data['LotNo'] = this.lotNo;
    data['MFGDate'] = this.mFGDate;
    data['EXPDate'] = this.eXPDate;
    data['SalesPrice'] = this.salesPrice;
    data['CreateDate'] = this.createDate;
    data['CreateType'] = this.createType;
    data['LastModiflyDate'] = this.lastModiflyDate;
    data['WarrantyNo'] = this.warrantyNo;
    data['WarrantyExpire'] = this.warrantyExpire;
    data['SLCCode'] = this.sLCCode;
    data['SLCBranchNo'] = this.sLCBranchNo;
    data['SLCCountryCode'] = this.sLCCountryCode;
    data['BlockchainID'] = this.blockchainID;
    data['ExWarrantyStatus'] = this.exWarrantyStatus;
    data['TradeStatus'] = this.tradeStatus;
    data['Title'] = this.title;
    data['SLCName'] = this.sLCName;
    data['AlertDate'] = this.alertDate;
    return data;
  }
}

class WarranzyLog {
  String wTokenID;
  String logDate;
  String logType;
  String partyCode;
  String partyBranchNo;
  String partyCountryCode;
  String warrantyNo;
  String warranzyBeginDate;
  String warranzyEndDate;
  String warranzyPrice;
  String fileAttachID;
  String blockchainID;
  String geoLocation;

  WarranzyLog(
      {this.wTokenID,
      this.logDate,
      this.logType,
      this.partyCode,
      this.partyBranchNo,
      this.partyCountryCode,
      this.warrantyNo,
      this.warranzyBeginDate,
      this.warranzyEndDate,
      this.warranzyPrice,
      this.fileAttachID,
      this.blockchainID,
      this.geoLocation});

  WarranzyLog.fromJson(Map<String, dynamic> json) {
    wTokenID = json['WTokenID'];
    logDate = json['LogDate'];
    logType = json['LogType'];
    partyCode = json['PartyCode'];
    partyBranchNo = json['PartyBranchNo'];
    partyCountryCode = json['PartyCountryCode'];
    warrantyNo = json['WarrantyNo'];
    warranzyBeginDate = json['WarranzyBeginDate'];
    warranzyEndDate = json['WarranzyEndDate'];
    warranzyPrice = json['WarranzyPrice'];
    fileAttachID = json['FileAttach_ID'];
    blockchainID = json['BlockchainID'];
    geoLocation = json['Geolocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['WTokenID'] = this.wTokenID;
    data['LogDate'] = this.logDate;
    data['LogType'] = this.logType;
    data['PartyCode'] = this.partyCode;
    data['PartyBranchNo'] = this.partyBranchNo;
    data['PartyCountryCode'] = this.partyCountryCode;
    data['WarrantyNo'] = this.warrantyNo;
    data['WarranzyBeginDate'] = this.warranzyBeginDate;
    data['WarranzyEndDate'] = this.warranzyEndDate;
    data['WarranzyPrice'] = this.warranzyPrice;
    data['FileAttach_ID'] = this.fileAttachID;
    data['BlockchainID'] = this.blockchainID;
    data["Geolocation"] = this.geoLocation;
    return data;
  }
}

class FilePool {
  String fileID;
  String fileName;
  String fileType;
  String fileDescription;
  String fileData;
  String lastUpdate;

  FilePool(
      {this.fileID,
      this.fileName,
      this.fileType,
      this.fileDescription,
      this.fileData,
      this.lastUpdate});

  FilePool.fromJson(Map<String, dynamic> json) {
    fileID = json['FileID'];
    fileName = json['FileName'];
    fileType = json['FileType'];
    fileDescription = json['FileDescription'];
    fileData = json['FileData'];
    lastUpdate = json['LastUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FileID'] = this.fileID;
    data['FileName'] = this.fileName;
    data['FileType'] = this.fileType;
    data['FileDescription'] = this.fileDescription;
    data['FileData'] = this.fileData;
    data['LastUpdate'] = this.lastUpdate;
    return data;
  }
}

class CatName {
  String eN;
  String tH;

  CatName({this.eN, this.tH});

  CatName.fromJson(Map<String, dynamic> json) {
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

class BrandName {
  String eN;

  BrandName({this.eN});

  BrandName.fromJson(Map<String, dynamic> json) {
    eN = json['EN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EN'] = this.eN;
    return data;
  }
}
