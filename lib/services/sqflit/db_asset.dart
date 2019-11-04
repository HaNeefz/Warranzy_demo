import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warranzy_demo/models/model_get_brand_name.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'dart:convert';

import 'package:warranzy_demo/models/model_user.dart';

/*
  All this file db.asset.dart have 3 table
    - Table Warranzyused
    - Table WarranzyLog
    - Table FilePool
 */
class DBProviderAsset {
  DBProviderAsset._();
  static final DBProviderAsset db = DBProviderAsset._();

  static Database _database;
  get getDB => database;
  final String tableWarranzyUsed = "WarranzyUsed";
  final String tableWarranzyLog = "WarramzyLog";
  final String tableFilePool = "FilePool";
  final String tableBrand = "Brand";

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'TableAsset.db');

    var database = await openDatabase(dbPath,
        version: 1, onCreate: onCreateAllTableAboutAsset);

    return database;
  }
  /*
CustBuyDate
CatName****
ManCode
BranName****
ProductID
MFGDate
EXPDate
SLCCode
SLCBranchNo
SLCCountryCode
BlockchainID */

  void onCreateAllTableAboutAsset(Database database, int version) async {
    await database.execute("""create table $tableWarranzyUsed ( 
      WTokenID TEXT primary key,
      CustUserID TEXT,
      CustCountryCode TEXT,
      PdtCatCode TEXT,
      PdtGroup TEXT,
      PdtPlace TEXT,
      BrandCode TEXT,
      Title TEXT,
      SerialNo TEXT,
      LotNo TEXT,
      SalesPrice TEXT,
      WarrantyNo TEXT,
      WarrantyExpire TEXT,
      CustRemark TEXT,
      CreateType TEXT,
      CreateDate TEXT,
      LastModiflyDate TEXT,
      ExWarrantyStatus TEXT,
      TradeStatus TEXT,
      SLCName TEXT,
      CustBuyDate TEXT,
      ManCode TEXT,
      ProductID TEXT,
      MFGDate TEXT,
      EXPDate TEXT,
      SLCCode TEXT,
      SLCBranchNo TEXT,
      SLCCountryCode TEXT,
      BlockchainID TEXT,
      AlertDate TEXT
        )""");
    await database.execute("""create table $tableWarranzyLog (
      WTokenID TEXT,
      LogDate TEXT,
      LogType TEXT,
      PartyCode TEXT,
      PartyCountryCode TEXT,
      WarrantyNo TEXT,
      WarranzyEndDate TEXT,
      FileAttach_ID TEXT,
      PartyBranchNo TEXT,
      WarranzyBeginDate TEXT,
      WarranzyPrice TEXT,
      BlockchainID TEXT,
      Geolocation TEXT,
      PRIMARY KEY("WTokenID","LogDate")
    )""");
    /*
PartyBranchNo
WarranzyBeginDate
WarranzyPrice
BlockchainID */

    await database.execute("""create table $tableFilePool(
      FileID PRIMARY KEY,
      FileName TEXT,
      FileType TEXT,
      FileDescription TEXT,
      FileData TEXT,
      LastUpdate TEXT
    )""");

    await database.execute("""CREATE TABLE $tableBrand(
      DocumentID PRIMARY KEY,
      BrandName TEXT,
      Description TEXT,
      ManCode TEXT,
      LastUpdate TEXT,
      BrandActive TEXT,
      FileID_Logo TEXT
    )""");
  }

  //------------------------------------------------------------------------------
  //----------------------------------CRUD----------------------------------------

  Future deleteAllAsset() async {
    final db = await database;
    await db
        .delete(tableWarranzyUsed)
        .then((v) => print("Delete tableWarranzyUsed => $v"));
    await db
        .delete(tableWarranzyLog)
        .then((v) => print("Delete tableWarranzyLog => $v"));
    await db
        .delete(tableFilePool)
        .then((v) => print("Delete tableFilePool => $v"));
  }

  Future deleteAssetByWToken({String wTokenID, List<String> imageKey}) async {
    final db = await database;
    await db
        .rawDelete(
            "DELETE FROM $tableWarranzyUsed WHERE WTokenID = '$wTokenID'")
        .then((onValue) {
      print("Deleted $tableWarranzyUsed => $onValue at WTokenID = $wTokenID");
    }).catchError(
            (onError) => print("Error delete $tableWarranzyUsed : $onError"));
    await db
        .rawDelete("DELETE FROM $tableWarranzyLog WHERE WTokenID = '$wTokenID'")
        .then((onValue) {
      print("Deleted $tableWarranzyLog => $onValue at WTokenID = $wTokenID");
    }).catchError(
            (onError) => print("Error delete $tableWarranzyLog : $onError"));

    imageKey.map((key) async {
      await deleteImagePoolByKey(key);
    }).toList();
  }

  Future deleteImagePoolByKey(String key) async {
    final db = await database;
    await db
        .rawDelete("DELETE FROM $tableFilePool WHERE FileID = '$key'")
        .then((i) {
      print("Deleted key $key : return $i");
    }).catchError((onError) => print("Error delete $tableFilePool : $onError"));
  }

  Future<int> updateWarranzyLog({String wTokenID, String fileAttach}) async {
    final db = await database;
    try {
      return await db.rawUpdate(
          "UPDATE $tableWarranzyLog SET FileAttach_ID = '$fileAttach' WHERE WTokenID = '$wTokenID'");
    } catch (e) {
      return null;
    }
  }

  Future<int> updateImagePoolForEditImageAsset(
      {List<String> oldFileID, FilePool filePool}) async {
    final db = await database;
    try {
      if (oldFileID.length > 0 && oldFileID != null) {
        oldFileID.forEach((fileID) async {
          int deleteOldImage = await db
              .delete(tableFilePool, where: "FileID = ?", whereArgs: [fileID]);
          print("deletedOldImage : $deleteOldImage");
        });
      }
      int completed = await db.insert(tableFilePool, filePool.toJson());
      print(
          "update imagePool : $completed <Realy! this method is insert newImage>");
      return completed >= 0 ? completed : null;
    } catch (e) {
      return null;
    }
  }

  Future<int> updateImagePool({FilePool filePool}) async {
    final db = await database;
    try {
      int completed = await db.update(tableFilePool, filePool.toJson(),
          where: "FileID = ?", whereArgs: [filePool.fileID]);
      print("update imagePool : $completed");
      return completed >= 0 ? completed : null;
    } catch (e) {
      return null;
    }
  }

  Future<int> updateFileDataOfImagePoolToBase64({FilePool filePool}) async {
    final db = await database;
    try {
      int completed = await db.update(
          tableFilePool, {"FileData": filePool.fileData},
          where: "FileID = ?", whereArgs: [filePool.fileID]);
      print("update imagePool to base64 : $completed");
      return completed >= 0 ? completed : null;
    } catch (e) {
      return null;
    }
  }

  Future<List<ModelDataAsset>> getAllDataAsset() async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM $tableWarranzyUsed, $tableWarranzyLog WHERE $tableWarranzyUsed.WTokenID = $tableWarranzyLog.WTokenID ORDER BY $tableWarranzyUsed.LastModiflyDate DESC"); // $tableWarranzyLog, $tableFilePool
    // var filePool = await db.rawQuery("SE")
    JsonEncoder encoder = JsonEncoder.withIndent(" ");
    List<ModelDataAsset> temp = [];
    if (res.isNotEmpty) {
      print("--------------------");
      res.forEach((v) {
        String prettyprint = encoder.convert(v);
        print("DataAssetSQLite => $prettyprint");
        temp.add(ModelDataAsset.fromJson(v));
      });

      return temp;
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> getImagePool(String fileID) async {
    final db = await database;
    var tempImageValue = await db.rawQuery(
        "SELECT FileDescription,FileData FROM $tableFilePool WHERE FileID = '$fileID'");
    if (tempImageValue.isNotEmpty) {
      return tempImageValue.first;
    } else
      return null;
  }

  Future<List<FilePool>> getImagePoolReturn(String fileID) async {
    final db = await database;
    List<FilePool> filePool = [];
    var tempImageValue = await db
        .rawQuery("SELECT * FROM $tableFilePool WHERE FileID = '$fileID'");
    if (tempImageValue.isNotEmpty) {
      print("key : $fileID");
      tempImageValue.forEach((v) => filePool.add(FilePool.fromJson(v)));
      return filePool;
    } else
      print("getImage is Empty at key : $fileID");
    return [];
  }

  Future<bool> hasDataAsset() async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM $tableWarranzyUsed, $tableWarranzyLog WHERE $tableWarranzyUsed.WTokenID = $tableWarranzyLog.WTokenID");

    if (res.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> insertDataWarranzyUesd(WarranzyUsed data) async {
    final db = await database;

    var res = await db.insert(tableWarranzyUsed, data.toJson());
    if (res > 1) {
      print("insert $tableWarranzyUsed complete");
      return true;
    } else
      return false;
    // } catch (e) {
    // print("Error insertWarranzyUsed => $e");
    // return false;
    // }
  }

  Future<bool> insertDataWarranzyLog(WarranzyLog data) async {
    final db = await database;
    var res = await db.insert(tableWarranzyLog, data.toJson());
    if (res > 1) {
      print("insert $tableWarranzyLog complete");
      return true;
    } else
      return false;
  }

  Future<bool> insertDataFilePool(FilePool data) async {
    final db = await database;
    var res = await db.insert(tableFilePool, data.toJson());
    if (res > 0) {
      print("insert $tableFilePool complete");
      return true;
    } else
      return false;
  }

  Future<bool> inserDataBrand(GetBrandName data) async {
    final db = await database;
    var res = await db.insert(tableBrand, data.toJson());
    if (res >= 1) {
      // print("insert $tableBrand complete");
      return true;
    } else
      return false;
  }

  Future<List<WarranzyUsed>> getAllDataWarranzyUsed() async {
    final db = await database;
    var res = await db.query(tableWarranzyUsed);
    List<WarranzyUsed> data = res.isNotEmpty
        ? res.map((data) => WarranzyUsed.fromJson(data)).toList()
        : [];
    return data;
  }

  Future<List<WarranzyLog>> getAllDataWarranzyLog() async {
    final db = await database;
    var res = await db.query(tableWarranzyLog);
    List<WarranzyLog> data = res.isNotEmpty
        ? res.map((data) => WarranzyLog.fromJson(data)).toList()
        : [];
    return data;
  }

  Future<List<FilePool>> getAllDataFilePool() async {
    final db = await database;
    var res = await db.query(tableFilePool);
    JsonEncoder encoder = JsonEncoder.withIndent(" ");
    res.forEach((v) {
      String prettyprint = encoder.convert(v);
      print("DataAsset => $prettyprint");
    });
    List<FilePool> data = res.isNotEmpty
        ? res.map((data) => FilePool.fromJson(data)).toList()
        : [];
    return data;
  }

  Future<String> getBrandName(String brandCode) async {
    print(brandCode);
    final db = await database;
    try {
      var res = await db.rawQuery(
          "SELECT BrandName FROM $tableBrand WHERE DocumentID = '$brandCode'");
      print(res.first['BrandName']);
      return res.isNotEmpty
          ? jsonDecode(res.first['BrandName'])['EN']
          : "BrandName is Empty";
    } catch (e) {
      return "Catch Errer $e";
    }
  }

  Future<List<GetBrandName>> getAllBrandName() async {
    final db = await database;
    try {
      var res = await db.rawQuery("SELECT * FROM $tableBrand");
      // JsonEncoder encoder = JsonEncoder.withIndent(" ");
      // String prettyprint = encoder.convert(res);
      // print("Brand => $prettyprint");
      return res.isNotEmpty
          ? res.map((f) => GetBrandName.fromJson(f)).toList()
          : "BrandName is Empty";
    } catch (e) {
      print("Catch getAllBrandName $e");
      return [];
    }
  }

  Future<bool> updateBrandName(GetBrandName brand) async {
    final db = await database;
    try {
      var res = await db.update("$tableBrand", brand.toJson());
      if (res >= 1) {
        print("Updated brand.");
        return true;
      } else
        return false;
    } catch (e) {
      print("Catch getAllBrandName $e");
      return false;
    }
  }

//-------------------------------------------------------------------------------------

  // getDataLanguage() async {
  //   final db = await database;
  //   var res = await db.query(tableName);
  //   List<ModelLanguage> data = res.isNotEmpty
  //       ? res.map((data) => ModelLanguage.fromJson(data)).toList()
  //       : [];

  //   return data.first.name;
  // }

  // getDataLanguageByID(int id) async {
  //   final db = await database;
  //   var res = await db.query(tableName, where: 'id = ?', whereArgs: [id]);

  //   return res.isNotEmpty ? ModelLanguage.fromJson(res.first) : null;
  // }

  // Future<bool> checkHasLanguage() async {
  //   final db = await database;
  //   var res = await db.query(tableName);
  //   if (res.isNotEmpty)
  //     return true;
  //   else
  //     return false;
  // }

  // updateLanguage(ModelLanguage data) async {
  //   final db = await database;
  //   var res = await db.update(tableName, data.toJson(),
  //       where: 'id = ?', whereArgs: [data.id]);

  //   return res;
  // }

  // deleteLanguage(int id) async {
  //   final db = await database;

  //   db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  // }
}
