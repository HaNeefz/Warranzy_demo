import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/services/method/scan_qr.dart';

/*
  All this file db.asset.dart have 3 table
    - Table Country
    - Table TimeZone
    - Table ProductCategory
 */

class DBProviderInitialApp {
  DBProviderInitialApp._();
  static final DBProviderInitialApp db = DBProviderInitialApp._();

  static Database _database;
  get getDB => database;
  final String tableCountry = "Country";
  final String tableTimeZone = "TimeZone";
  final String tableProductCategory = "ProductCategory";

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'TableInitialApp.db');

    var database = await openDatabase(dbPath,
        version: 1, onCreate: onCreateTableInitialApp);
    return database;
  }

  onCreateTableInitialApp(Database database, int version) async {
    await database.execute("""CREATE TABLE $tableCountry (
      Code TEXT PRIMARY KEY,
      CountryName TEXT,
      Area TEXT,
      Currency TEXT,
      Prefix TEXT,
      PriceSMS TEXT,
      Language TEXT,
      UpdateDate TEXT     
    )""");
    await database.execute("""CREATE TABLE $tableTimeZone(
      Code TEXT,
      TimeZone TEXT,
      GMT TEXT,
      DST TEXT,
      rawOffset TEXT,
      UpdateDate TEXT,
      PRIMARY KEY("Code","TimeZone")
    )""");

    await database.execute("""CREATE TABLE $tableProductCategory(
      CatCode TEXT PRIMARY KEY,
      CatName TEXT,
      Image_Box TEXT,
      Image_Product TEXT,
      Image_Document TEXT,
      Image_Serial TEXT,
      Image_ChassisNo TEXT,
      Image_Warranty TEXT,
      Image_Receipt TEXT,
      Image_SellerCard TEXT,
      Image_Other TEXT,
      LastUpdate TEXT
    )""");
  }

  Future deleteAllDataIn3Table() async {
    final db = await database;
    await db
        .delete(tableCountry)
        .then((v) => print("Delete tableCountry => $v"));
    await db
        .delete(tableTimeZone)
        .then((v) => print("Delete tableTimeZone => $v"));
    await db
        .delete(tableProductCategory)
        .then((v) => print("Delete tableProductCategory => $v"));
  }

  Future<bool> insertDataInToTableCountry(Country country) async {
    final db = await database;
    var res = await db.insert(tableCountry, country.toJson());
    if (res == 1) {
      print("insert $tableCountry complete");
      return true;
    } else
      return false;
  }

  Future<bool> insertDataInToTableTimeZone(TimeZone timeZone) async {
    final db = await database;
    var res = await db.insert(tableTimeZone, timeZone.toJson());
    if (res == 1) {
      print("insert $tableTimeZone complete");
      return true;
    } else
      return false;
  }

  Future<bool> insertDataInToTableProductCategory(ProductCatagory data) async {
    final db = await database;
    var res = await db.insert(tableProductCategory, data.toJson());
    if (res == 1) {
      print("insert $tableProductCategory complete");
      return true;
    } else
      return false;
  }

  Future getAllDataCountry() async {
    final db = await database;
    try {
      var res = await db.query(tableCountry);
      JsonEncoder encoder = JsonEncoder.withIndent(" ");
      res.forEach((v) {
        String prettyprint = encoder.convert(v);
        print("$tableCountry => " + prettyprint);
      });
    } catch (e) {
      print("Error $tableCountry => $e");
    }
  }

  Future getAllDataTimeZone() async {
    final db = await database;
    try {
      var res = await db.query(tableTimeZone);
      JsonEncoder encoder = JsonEncoder.withIndent(" ");
      res.forEach((v) {
        String prettyprint = encoder.convert(v);
        print("$tableTimeZone => " + prettyprint);
      });
    } catch (e) {
      print("Error $tableTimeZone => $e");
    }
  }

  Future<List<ProductCatagory>> getAllDataProductCategory() async {
    final db = await database;
    try {
      var res = await db.rawQuery(
          "SELECT * FROM $tableProductCategory ORDER BY $tableProductCategory.CatCode ASC"); //query(tableProductCategory)
      // JsonEncoder encoder = JsonEncoder.withIndent(" ");
      // String prettyprint = encoder.convert(v);
      // print("$tableProductCategory => " + prettyprint);
      List<ProductCatagory> listProductCat = List<ProductCatagory>();
      res.forEach((v) {
        listProductCat.add(ProductCatagory.fromJson(v));
      });
      print("CurrentLanguage => ${allTranslations.currentLanguage}");
      var lang = allTranslations.currentLanguage.toString().toUpperCase();
      listProductCat.forEach((v) {
        var decode = jsonDecode(v.catName)[lang];
        v.catName = decode;
        // print("${v.catCode} | ${v.catName}");
      });
      return listProductCat;
    } catch (e) {
      print("Error $tableProductCategory => $e");
      return [];
    }
  }
}
