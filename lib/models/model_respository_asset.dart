import 'dart:convert';

import 'package:warranzy_demo/models/model_get_brand_name.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';

import 'model_repository_asset_scan.dart';
import 'model_user.dart';

class RepositoryOfAsset {
  bool status;
  WarranzyUsed warranzyUsed;
  WarranzyLog warranzyLog;
  List<FilePool> filePool;
  String message;
  GetBrandName brand;

  RepositoryOfAsset(
      {this.status,
      this.warranzyUsed,
      this.warranzyLog,
      this.filePool,
      this.message,
      this.brand});

  RepositoryOfAsset.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    warranzyUsed = json['WarranzyUsed'] != null
        ? new WarranzyUsed.fromJson(json['WarranzyUsed'])
        : null;
    warranzyLog = json['WarranzyLog'] != null
        ? new WarranzyLog.fromJson(json['WarranzyLog'])
        : null;
    if (json['FilePool'] != null) {
      filePool = new List<FilePool>();
      json['FilePool'].forEach((v) {
        filePool.add(new FilePool.fromJson(v));
      });
    }
    brand = json['BrandName'] != null
        ? GetBrandName.fromJson(json['BrandName'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.warranzyUsed != null) {
      data['WarranzyUsed'] = this.warranzyUsed.toJson();
    }
    if (this.warranzyLog != null) {
      data['WarranzyLog'] = this.warranzyLog.toJson();
    }
    if (this.filePool != null) {
      data['FilePool'] = this.filePool.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class WarranzyUsed {
//   String wTokenID;
//   String custUserID;
//   String custCountryCode;
//   String pdtCatCode;
//   String pdtGroup;
//   String pdtPlace;
//   String brandCode;
//   String title;
//   String serialNo;
//   String lotNo;
//   String salesPrice;
//   String warrantyNo;
//   String warrantyExpire;
//   String custRemark;
//   String createType;
//   String createDate;
//   String lastModiflyDate;
//   String exWarrantyStatus;
//   String tradeStatus;
//   String slcName;

//   WarranzyUsed(
//       {this.wTokenID,
//       this.custUserID,
//       this.custCountryCode,
//       this.pdtCatCode,
//       this.pdtGroup,
//       this.pdtPlace,
//       this.brandCode,
//       this.title,
//       this.serialNo,
//       this.lotNo,
//       this.salesPrice,
//       this.warrantyNo,
//       this.warrantyExpire,
//       this.custRemark,
//       this.createType,
//       this.createDate,
//       this.lastModiflyDate,
//       this.exWarrantyStatus,
//       this.slcName,
//       this.tradeStatus});

//   WarranzyUsed.fromJson(Map<String, dynamic> json) {
//     wTokenID = json['WTokenID'];
//     custUserID = json['CustUserID'];
//     custCountryCode = json['CustCountryCode'];
//     pdtCatCode = json['PdtCatCode'];
//     pdtGroup = json['PdtGroup'];
//     pdtPlace = json['PdtPlace'];
//     brandCode = json['BrandCode'];
//     title = json['Title'];
//     serialNo = json['SerialNo'];
//     lotNo = json['LotNo'];
//     salesPrice = json['SalesPrice'];
//     warrantyNo = json['WarrantyNo'];
//     warrantyExpire = json['WarrantyExpire'];
//     custRemark = json['CustRemark'];
//     createType = json['CreateType'];
//     createDate = json['CreateDate'];
//     lastModiflyDate = json['LastModiflyDate'];
//     slcName = json['SLCName'] ?? "-";
//     exWarrantyStatus = json['ExWarrantyStatus'];
//     tradeStatus = json['TradeStatus'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['WTokenID'] = this.wTokenID;
//     data['CustUserID'] = this.custUserID;
//     data['CustCountryCode'] = this.custCountryCode;
//     data['PdtCatCode'] = this.pdtCatCode;
//     data['PdtGroup'] = this.pdtGroup;
//     data['PdtPlace'] = this.pdtPlace;
//     data['BrandCode'] = this.brandCode;
//     data['Title'] = this.title;
//     data['SerialNo'] = this.serialNo;
//     data['LotNo'] = this.lotNo;
//     data['SalesPrice'] = this.salesPrice;
//     data['WarrantyNo'] = this.warrantyNo;
//     data['WarrantyExpire'] = this.warrantyExpire;
//     data['CustRemark'] = this.custRemark;
//     data['CreateType'] = this.createType;
//     data['CreateDate'] = this.createDate;
//     data['LastModiflyDate'] = this.lastModiflyDate;
//     data['ExWarrantyStatus'] = this.exWarrantyStatus;
//     data['SLCName'] = this.slcName;
//     data['TradeStatus'] = this.tradeStatus;
//     return data;
//   }
// }

// class WarranzyLog {
//   String wTokenID;
//   String logDate;
//   String logType;
//   String partyCode;
//   String partyCountryCode;
//   String warrantyNo;
//   String warranzyEndDate;
//   String fileAttachID;

//   WarranzyLog(
//       {this.wTokenID,
//       this.logDate,
//       this.logType,
//       this.partyCode,
//       this.partyCountryCode,
//       this.warrantyNo,
//       this.warranzyEndDate,
//       this.fileAttachID});

//   WarranzyLog.fromJson(Map<String, dynamic> json) {
//     wTokenID = json['WTokenID'];
//     logDate = json['LogDate'];
//     logType = json['LogType'];
//     partyCode = json['PartyCode'];
//     partyCountryCode = json['PartyCountryCode'];
//     warrantyNo = json['WarrantyNo'];
//     warranzyEndDate = json['WarranzyEndDate'];
//     fileAttachID = json['FileAttach_ID'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['WTokenID'] = this.wTokenID;
//     data['LogDate'] = this.logDate;
//     data['LogType'] = this.logType;
//     data['PartyCode'] = this.partyCode;
//     data['PartyCountryCode'] = this.partyCountryCode;
//     data['WarrantyNo'] = this.warrantyNo;
//     data['WarranzyEndDate'] = this.warranzyEndDate;
//     data['FileAttach_ID'] = this.fileAttachID;
//     return data;
//   }
// }

// class FilePool {
//   String fileID;
//   String fileName;
//   String fileType;
//   String fileDescription;
//   String fileData;
//   String lastUpdate;

//   FilePool(
//       {this.fileID,
//       this.fileName,
//       this.fileType,
//       this.fileDescription,
//       this.fileData,
//       this.lastUpdate});

//   FilePool.fromJson(Map<String, dynamic> json) {
//     fileID = json['FileID'];
//     fileName = json['FileName'];
//     fileType = json['FileType'];
//     fileDescription = json['FileDescription'];
//     fileData = json['FileData'];
//     lastUpdate = json['LastUpdate'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['FileID'] = this.fileID;
//     data['FileName'] = this.fileName;
//     data['FileType'] = this.fileType;
//     data['FileDescription'] = this.fileDescription;
//     data['FileData'] = this.fileData;
//     data['LastUpdate'] = this.lastUpdate;
//     return data;
//   }
// }

class ResponseDetailOfAsset {
  bool status;
  ModelDataAsset data;
  ModelDataScan dataScan;
  String message;
  WarranzyUsed warranzyUsed;
  WarranzyLog warranzyLog;

  ResponseDetailOfAsset(
      {this.status,
      this.data,
      this.message,
      this.dataScan,
      this.warranzyLog,
      this.warranzyUsed});

  ResponseDetailOfAsset.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    data =
        json['Data'] != null ? new ModelDataAsset.fromJson(json['Data']) : null;
    dataScan = json['Product'] != null
        ? new ModelDataScan.fromJson(json['Product'])
        : null;
    warranzyLog = json['WarranzyLog'] != null
        ? WarranzyLog.fromJson(json['WarranzyLog'])
        : null;
    warranzyUsed = json['WarranzyUsed'] != null
        ? WarranzyUsed.fromJson(json['WarranzyUsed'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (this.dataScan != null) data['Product'] = this.dataScan.toJson();
    if (this.warranzyLog != null)
      data['WarranzyLog'] = this.warranzyLog.toJson();
    if (this.warranzyUsed != null)
      data['WarranzyUsed'] = this.warranzyUsed.toJson();
    return data;
  }
}

class ModelDataAsset {
  String wTokenID;
  String custUserID;
  String custCountryCode;
  String pdtCatCode;
  CatName modelCatName;
  BrandName modelBrandName;
  String pdtGroup;
  String groupCat;
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
  String logDate;
  String logType;
  String partyCode;
  String partyCountryCode;
  String warranzyEndDate;
  String fileAttachID;
  String imageMain;
  String images;
  String alertDate;
  String slcName;
  int alertDateNo;
  String geoLocation;

  ModelDataAsset(
      {this.wTokenID,
      this.custUserID,
      this.custCountryCode,
      this.pdtCatCode,
      this.groupCat,
      this.modelCatName,
      this.modelBrandName,
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
      this.tradeStatus,
      this.logDate,
      this.logType,
      this.partyCode,
      this.partyCountryCode,
      this.warranzyEndDate,
      this.fileAttachID,
      this.images,
      this.slcName,
      this.alertDate,
      this.alertDateNo,
      this.geoLocation});

  ModelDataAsset.fromJson(Map<String, dynamic> json) {
    wTokenID = json['WTokenID'];
    custUserID = json['CustUserID'];
    custCountryCode = json['CustCountryCode'];
    pdtCatCode = json['PdtCatCode'];
    modelCatName = json['CatName'] != null
        ? CatName.fromJson(jsonDecode(json['CatName']))
        : null;
    modelBrandName = json['BrandName'] != null
        ? BrandName.fromJson(jsonDecode(json['BrandName']))
        : null;
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
    logDate = json['LogDate'];
    logType = json['LogType'];
    partyCode = json['PartyCode'];
    partyCountryCode = json['PartyCountryCode'];
    warranzyEndDate = json['WarranzyEndDate'];
    fileAttachID = json['FileAttach_ID'];
    imageMain = json['ImageMain'];
    images = json['Images'];
    slcName = json['SLCName'];
    alertDate = json['AlertDate'];
    alertDateNo = json['AlertDateNo'];
    geoLocation = json['Geolocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['WTokenID'] = this.wTokenID;
    data['CustUserID'] = this.custUserID;
    data['CustCountryCode'] = this.custCountryCode;
    data['PdtCatCode'] = this.pdtCatCode;
    if (data != null) data['CatName'] = this.modelCatName.toJson();
    if (data != null) data['BrandName'] = this.modelBrandName.toJson();
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
    data['LogDate'] = this.logDate;
    data['LogType'] = this.logType;
    data['PartyCode'] = this.partyCode;
    data['PartyCountryCode'] = this.partyCountryCode;
    data['WarranzyEndDate'] = this.warranzyEndDate;
    data['FileAttach_ID'] = this.fileAttachID;
    data['Images'] = this.images;
    data['SLCName'] = this.slcName;
    data['AlertDate'] = this.alertDate;
    data['AlertDateNo'] = this.alertDateNo;
    data['Geolocation'] = this.geoLocation;
    return data;
  }
}

class ResponseAssetOnline {
  bool status;
  List<ModelDataAsset> data;
  String message;
  dynamic statusSession;

  ResponseAssetOnline(
      {this.status, this.data, this.message, this.statusSession});

  ResponseAssetOnline.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    statusSession = json['Status_Session'];
    message = json['Message'];
    if (json['Data'] != null) {
      data = new List<ModelDataAsset>();
      json['Data'].forEach((v) {
        data.add(new ModelDataAsset.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseImage {
  bool status;
  String message;
  List<FilePool> filePool;

  ResponseImage({this.status, this.filePool, this.message});

  ResponseImage.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['FilePool'] != null) {
      filePool = new List<FilePool>();
      json['FilePool'].forEach((v) {
        filePool.add(new FilePool.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.filePool != null) {
      data['FilePool'] = this.filePool.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
