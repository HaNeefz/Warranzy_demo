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

  Future deleteAssetByWToken(String wTokenID) async {
    final db = await database;
    await db
        .rawDelete(
            "DELETE FROM $tableWarranzyUsed WHERE WTokenID = '$wTokenID'")
        .then((onValue) {
      print("Deleted $tableWarranzyUsed => $onValue at WTokenID = $wTokenID");
    });
    await db
        .rawDelete("DELETE FROM $tableWarranzyLog WHERE WTokenID = '$wTokenID'")
        .then((onValue) {
      print("Deleted $tableWarranzyLog => $onValue at WTokenID = $wTokenID");
    });
    // await db.delete(tableWarranzyUsed, where: 'WTokenID', whereArgs: [
    //   '$wTokenID'
    // ]).then((v) => print("Delete tableWarranzyUsed => $v"));
    // await db.delete(tableWarranzyLog, where: 'WTokenID', whereArgs: [
    //   '$wTokenID'
    // ]).then((v) => print("Delete tableWarranzyLog => $v"));
  }

  Future<List<ModelDataAsset>> getAllDataAsset() async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM $tableWarranzyUsed, $tableWarranzyLog WHERE $tableWarranzyUsed.WTokenID = $tableWarranzyLog.WTokenID ORDER BY $tableWarranzyUsed.LastModiflyDate DESC"); // $tableWarranzyLog, $tableFilePool
    // var filePool = await db.rawQuery("SE")
    JsonEncoder encoder = JsonEncoder.withIndent(" ");
    List<ModelDataAsset> temp = [];
    Map<String, dynamic> dataAsset = {};
    if (res.isNotEmpty) {
      print("--------------------");
      res.forEach((v) {
        String prettyprint = encoder.convert(v);
        print("DataOnline => $prettyprint");
        temp.add(ModelDataAsset.fromJson(v));
      });

      // print("added[0] ${encoder.convert(temp[0].toJson())}");
      // print("added[1] ${encoder.convert(temp[1].toJson())}");

      return temp;
    } else {
      return [];
    }
  }

  Future<String> getMainImage() async {
    final db = await database;
    String imageMain;
    var res = await db.rawQuery(
        "SELECT * FROM $tableWarranzyUsed, $tableWarranzyLog WHERE $tableWarranzyUsed.WTokenID = $tableWarranzyLog.WTokenID");
    Map<String, dynamic> map = Map<String, dynamic>.from(res.first);
    int counter = 0;
    map = jsonDecode(map["FileAttach_ID"]);
    print(map);
    map.forEach((k, v) async {
      if (counter == 0) {
        // print("$k | $v");
        List vv = v as List;
        String vvv = vv.first;
        // print(vvv);
        // imageMain = await getImagePool(vvv);
        counter++;
      }
    });
    print(imageMain);
    return imageMain;
  }

  Future<String> getImagePool(String fileID) async {
    final db = await database;
    var tempImageValue = await db
        .rawQuery("SELECT FileID FROM $tableFilePool WHERE FileID = '$fileID'");
    if (tempImageValue.isNotEmpty) {
      return tempImageValue.first['FileID'];
    } else
      return "";
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
    if (res == 1) {
      print("insert $tableWarranzyLog complete");
      return true;
    } else
      return false;
  }

  Future<bool> insertDataFilePool(FilePool data) async {
    final db = await database;
    var res = await db.insert(tableFilePool, data.toJson());
    if (res == 1) {
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

  Future<String> getAllBrandName() async {
    final db = await database;
    try {
      var res = await db.rawQuery("SELECT * FROM $tableBrand");
      // print(res.first['BrandName']);
      JsonEncoder encoder = JsonEncoder.withIndent(" ");
      String prettyprint = encoder.convert(res);
      print("Brand => $prettyprint");
      return res.isNotEmpty ? res.first['BrandName'] : "BrandName is Empty";
    } catch (e) {
      return "Catch Errer $e";
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
