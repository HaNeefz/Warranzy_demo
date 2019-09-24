import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
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
      CatName TEXT,
      ManCode TEXT,
      BrandName TEXT,
      ProductID TEXT,
      MFGDate TEXT,
      EXPDate TEXT,
      SLCCode TEXT,
      SLCBranchNo TEXT,
      SLCCountryCode TEXT,
      BlockchainID TEXT
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

  Future<List<ModelDataAsset>> getAllDataAsset() async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM $tableWarranzyUsed, $tableWarranzyLog WHERE $tableWarranzyUsed.WTokenID = $tableWarranzyLog.WTokenID"); // $tableWarranzyLog, $tableFilePool
    JsonEncoder encoder = JsonEncoder.withIndent(" ");
    List<ModelDataAsset> temp = [];
    if (res.isNotEmpty) {
      res.forEach((v) {
        String prettyprint = encoder.convert(v);
        print("Data => " + prettyprint);
        // var map = {"Status":true,"Data":}
        temp.add(ModelDataAsset.fromJson(v));
      });

      // print("added[0] ${encoder.convert(temp[0].toJson())}");
      // print("added[1] ${encoder.convert(temp[1].toJson())}");

      return temp;
    } else {
      return [];
    }
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

  /*
  SqfliteDatabaseException (DatabaseException(Error Domain=FMDatabase Code=1 "table WarranzyUsed has no column named BrandName" UserInfo={NSLocalizedDescription=table WarranzyUsed has no column named BrandName}) sql 'INSERT INTO WarranzyUsed (WTokenID, CustBuyDate, CustUserID, CustCountryCode, PdtCatCode, CatName, BrandName, PdtGroup, PdtPlace, CustRemark, ManCode, BrandCode, ProductID, SerialNo, LotNo, MFGDate, EXPDate, SalesPrice, CreateDate, CreateType, LastModiflyDate, WarrantyNo, WarrantyExpire, SLCCode, SLCBranchNo, SLCCountryCode, BlockchainID, ExWarrantyStatus, TradeStatus, Title, SLCName) VALUES (?, NULL, ?, ?, ?, NULL, NULL, ?, ?, ?, NULL, ?, NULL, ?, ?, NULL, NULL, ?, ?, ?, ?, ?, ?, NULL, NULL, NULL, NULL, NULL, NULL, ?, ?)' args [ca3f5-TH-1082acd47e204bd58004406e1, ca3f58b3a0214aaaa68a, TH, A001, Car, Home, ThunderBolt used connect others devices, 27afd78de7aa42d, 18274782919382891, 12, 131, 2019-09-12 09:05:32+00, C, 2019-09-19 04:25:51+00, , 2019-09-12 12:16:40+00, ThunderBolt, PowerBuy]}) */
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
