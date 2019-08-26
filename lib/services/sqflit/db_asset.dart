import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'dart:convert';

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
      TradeStatus TEXT
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
      PRIMARY KEY("WTokenID","LogDate")
    )""");

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

  Future<Iterable<RepositoryOfAssetFromSqflite>> getAllDataAsset() async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM $tableWarranzyUsed,$tableFilePool"); // $tableWarranzyLog, $tableFilePool

    // List<RepositoryOfAssetFromSqflite> response = res.isNotEmpty
    //     ? res.map((v) => RepositoryOfAssetFromSqflite.fromJson(v))
    //     : [];
    // return response;
    if (res.isNotEmpty) {
      // JsonEncoder encoder = JsonEncoder.withIndent(" ");
      Iterable<RepositoryOfAssetFromSqflite> temp =
          res.map((v) => RepositoryOfAssetFromSqflite.fromJson(v));
      return temp;
      // res.map((v) {
      //   String prettyprint = encoder.convert(v);
      //   print("WarranzyUsed => " + prettyprint);
      //   // RepositoryOfAssetFromSqflite.fromJson(v);
      //   print("gotAllDataAsset");
      // }).toList();
      // return temp;
    } else
      return [];
  }

  Future getAllDataAssetTest() async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM $tableWarranzyUsed"); // $tableWarranzyLog, $tableFilePool
    var filePool = await db.query(tableFilePool);
    if (res.isNotEmpty) {
      if (filePool.isNotEmpty) {
        // res.addAll(filePool);
        print(res);
      } else
        return [];
      // JsonEncoder encoder = JsonEncoder.withIndent(" ");
      // res.map((v) {
      //   String prettyprint = encoder.convert(v);
      //   print("WarranzyUsed => " + prettyprint);
      //   // RepositoryOfAssetFromSqflite.fromJson(v);
      //   print("<----------------gotAllDataAsset");
      // }).toList();
      // return temp;
    } else {
      return [];
    }
  }

  Future<bool> insertDataWarranzyUesd(WarranzyUsed data) async {
    final db = await database;
    try {
      var res = await db.insert(tableWarranzyUsed, data.toJson());
      if (res == 1) {
        print("insert $tableWarranzyUsed complete");
        return true;
      } else
        return false;
    } catch (e) {
      print("Error insertWarranzyUsed => $e");
      return false;
    }
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
