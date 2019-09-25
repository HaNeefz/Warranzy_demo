import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/services/method/scan_qr.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:http/http.dart' as http;

/*
  All this file db.asset.dart have 3 table
    - Table Country
    - Table TimeZone
    - Table ProductCategory
 */

class DBProviderInitialApp {
  DBProviderInitialApp._();
  static final DBProviderInitialApp db = DBProviderInitialApp._();
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  static Database _database;
  get getDB => database;
  final String tableCountry = "Country";
  final String tableTimeZone = "TimeZone";
  final String tableGroupCategory = "ProductCategory";
  final String tableProductSubCategory = "ProductSubCategory";

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
    await database.execute("""CREATE TABLE $tableGroupCategory(
      GroupID PRIMARY KEY,
      GroupName TEXT,
      LastUpdate TEXT,
      Logo TEXT,
      KeepLogo TEXT
    )""");
    await database.execute("""CREATE TABLE $tableProductSubCategory(
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
      LastUpdate TEXT,
      GroupID TEXT,
      Logo TEXT,
      KeepLogo TEXT
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
        .delete(tableProductSubCategory)
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

  Future<bool> insertDataInToTableProductSubCategory(
      ProductCategory data) async {
    final db = await database;
    var res = await db.insert(tableProductSubCategory, data.toJson());
    if (res == 1) {
      print("insert $tableProductSubCategory complete");
      return true;
    } else
      return false;
  }

  Future<bool> insertDataInToTableGroupCategory(GroupCategory data) async {
    final db = await database;
    var res = await db.insert(tableGroupCategory, data.toJson());
    if (res == 1) {
      print("insert $tableGroupCategory complete");
      return true;
    } else
      return false;
  }

  Future<bool> updateIconGroupCategory(GroupCategory data) async {
    final db = await database;
    var getContentLogo = await http.get(data.logo);
    var byte = getContentLogo.bodyBytes;
    var base64 = base64Encode(byte);
    var res = await db.rawUpdate(
        "UPDATE $tableGroupCategory SET KeepLogo =  '$base64' WHERE GroupID = '${data.groupID}'");
    if (res == 1) {
      print("UpdateLogo $tableGroupCategory complete");
      return true;
    } else
      return false;
  }

  Future<bool> updateIconSubCategory(ProductCategory data) async {
    final db = await database;
    var getContentLogo = await http.get(data.logo);
    var byte = getContentLogo.bodyBytes;
    var base64 = base64Encode(byte);
    var res = await db.rawUpdate(
        "UPDATE $tableProductSubCategory SET KeepLogo =  '$base64' WHERE CatCode = '${data.catCode}'");
    if (res == 1) {
      print("UpdateLogo $tableProductSubCategory complete");
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

  Future<String> getCountryCodeByTimeZone(String timezone) async {
    final db = await database;
    try {
      var res = await db.rawQuery(
          "SELECT Code FROM $tableTimeZone WHERE TimeZone = '$timezone'");
      return res.first["Code"];
    } catch (e) {
      print("Error $tableTimeZone => $e");
      return "";
    }
  }

  Future<List<GroupCategory>> getGroupCategory() async {
    final db = await database;
    try {
      var res = await db.rawQuery(
          "SELECT * FROM $tableGroupCategory ORDER BY $tableGroupCategory.GroupID ASC"); //query(tableGroupCategory)
      List<GroupCategory> listProductCat = List<GroupCategory>();
      res.forEach((v) {
        JsonEncoder encoder = JsonEncoder.withIndent(" ");
        String prettyprint = encoder.convert(v);
        print("$tableGroupCategory => " + prettyprint);
        listProductCat.add(GroupCategory.fromJson(v));
      });
      return listProductCat;
    } catch (e) {
      print("Error $tableGroupCategory => $e");
      return [];
    }
  }

  Future<List<GroupCategory>> getAllGroupCategory() async {
    final db = await database;
    try {
      var res = await db.rawQuery(
          "SELECT * FROM $tableGroupCategory ORDER BY $tableGroupCategory.GroupID ASC"); //query(tableGroupCategory)
      List<GroupCategory> listProductCat = List<GroupCategory>();
      res.forEach((v) {
        // JsonEncoder encoder = JsonEncoder.withIndent(" ");
        // String prettyprint = encoder.convert(v);
        // print("$tableGroupCategory => " + prettyprint);
        listProductCat.add(GroupCategory.fromJson(v));
      });
      return listProductCat;
    } catch (e) {
      print("Error $tableGroupCategory => $e");
      return [];
    }
  }

  Future<List<GroupCategory>> getGroupCategoryBySubCat({String groupID}) async {
    final db = await database;
    try {
      var res = await db.rawQuery(
          "SELECT * FROM $tableGroupCategory WHERE GroupID = '$groupID' ORDER BY $tableGroupCategory.GroupID ASC"); //query(tableGroupCategory)
      List<GroupCategory> listProductCat = List<GroupCategory>();
      res.forEach((v) {
        // JsonEncoder encoder = JsonEncoder.withIndent(" ");
        // String prettyprint = encoder.convert(v);
        // print("$tableGroupCategory => " + prettyprint);
        listProductCat.add(GroupCategory.fromJson(v));
      });
      return listProductCat;
    } catch (e) {
      print("Error $tableGroupCategory => $e");
      return [];
    }
  }

  Future<List<ProductCategory>> getSubCategoryByGroupID(
      {String groupID}) async {
    final db = await database;
    try {
      var res = await db.rawQuery(
          "SELECT * FROM $tableProductSubCategory WHERE GroupID = '$groupID' ORDER BY $tableProductSubCategory.CatCode ASC"); //query(tableGroupCategory)
      List<ProductCategory> listProductCat = List<ProductCategory>();
      res.forEach((v) {
        listProductCat.add(ProductCategory.fromJson(v));
      });
      return listProductCat;
    } catch (e) {
      print("Error $tableGroupCategory => $e");
      return [];
    }
  }

  Future<String> getGroupCategoryByCatCode({String catCode}) async {
    final db = await database;
    try {
      var res = await db.rawQuery(
          "SELECT GroupID FROM $tableProductSubCategory WHERE CatCode = '$catCode' ORDER BY $tableProductSubCategory.CatCode ASC"); //query(tableGroupCategory)

      return res.first['GroupID'];
    } catch (e) {
      print("Error $tableGroupCategory => $e");
      return null;
    }
  }

  Future<List<ProductCategory>> getAllDataProductCategory() async {
    final db = await database;
    try {
      var res = await db.rawQuery(
          "SELECT * FROM $tableProductSubCategory ORDER BY $tableProductSubCategory.CatCode ASC"); //query(tableProductCategory)
      // JsonEncoder encoder = JsonEncoder.withIndent(" ");
      // String prettyprint = encoder.convert(v);
      // print("$tableProductCategory => " + prettyprint);
      List<ProductCategory> listProductCat = List<ProductCategory>();
      res.forEach((v) {
        listProductCat.add(ProductCategory.fromJson(v));
      });
      return listProductCat;
    } catch (e) {
      print("Error $tableProductSubCategory => $e");
      return [];
    }
  }

  Future<ProductCategory> getDataProductCategoryByID(String catCode) async {
    final db = await database;
    try {
      var res = await db.rawQuery(
          "SELECT * FROM $tableProductSubCategory WHERE CatCode = '$catCode'"); //query(tableProductCategory)
      // JsonEncoder encoder = JsonEncoder.withIndent(" ");
      // String prettyprint = encoder.convert(v);
      // print("$tableProductCategory => " + prettyprint);
      return ProductCategory.fromJson(res.first);
    } catch (e) {
      print("Error $tableProductSubCategory => $e");
      return null;
    }
  }

  Future<String> getProductCatName({String id, String lang}) async {
    final db = await database;
    try {
      var response = await db.rawQuery(
          "SELECT CatName FROM $tableProductSubCategory WHERE CatCode = '$id'");
      if (response.isNotEmpty) {
        var catNameDecode = jsonDecode(response.first["CatName"]);
        // print("CatName : ${catNameDecode[lang.toUpperCase()]}");
        return catNameDecode[lang.toUpperCase()];
      } else {
        print("data is empty");
        return "CatName is empty";
      }
    } catch (e) {
      print("catch => $e");
      return "catch $e";
    }
  }
}
