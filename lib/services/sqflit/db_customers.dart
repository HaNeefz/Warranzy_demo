import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warranzy_demo/models/model_user.dart';
// import 'package:warranzy_demo/models/model_mas_cust.dart';

class DBProviderCustomer {
  DBProviderCustomer._();
  static final DBProviderCustomer db = DBProviderCustomer._();

  static Database _database;
  get getDB => database;
  final String tableCustomer = "Customer";
  final String columnCustUserID = "CustUserID";
  final String columnCustName = "CustName";
  final String columnHomeAddress = "HomeAddress";
  final String columnCountryCode = "CountryCode";
  final String columnCustEmail = "CustEmail";
  final String columnMobilePhone = "MobilePhone";
  final String columnNotificationID = "NotificationID";
  final String columnPINcode = "PINcode";
  final String columnDeviceID = "DeviceID";
  final String columnGender = "Gender";
  final String columnBirthYear = "BirthYear";
  final String columnSpecialPass = "SpecialPass";
  final String columnPackageType = "PackageType";
  final String columnCreateDate = "CreateDate";
  final String columnLastUpdate = "LastUpdate";
  final String columnImageProfile = "ImageProfile";

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'customerDB.db');

    var database = await openDatabase(dbPath, version: 1, onCreate: customerDb);
    return database;
  }

  void customerDb(Database database, int version) async {
    await database.execute("CREATE TABLE $tableCustomer ("
        "$columnCustUserID TEXT PRIMARY KEY,"
        "$columnCustName TEXT,"
        "$columnHomeAddress TEXT,"
        "$columnCountryCode TEXT,"
        "$columnCustEmail TEXT,"
        "$columnMobilePhone TEXT,"
        "$columnNotificationID TEXT,"
        "$columnPINcode TEXT,"
        "$columnDeviceID TEXT,"
        "$columnGender TEXT,"
        "$columnBirthYear TEXT,"
        "$columnSpecialPass TEXT,"
        "$columnPackageType TEXT,"
        "$columnCreateDate TEXT,"
        "$columnLastUpdate TEXT,"
        "$columnImageProfile TEXT"
        ")");
  }

  //------------------------------------------------------------------------------
  //----------------------------------CRUD----------------------------------------
  Future<bool> addDataCustomer(ModelCustomers data) async {
    final db = await database;
    var res;
    try {
      res = await db.insert(tableCustomer, data.toJson());
      print(res);
    } catch (e) {
      print("Can't insert data customer $e");
    }
    return res > 0;
  }

  Future<String> getNameCustomer() async {
    final db = await database;
    try {
      var res = await db.query(tableCustomer, columns: [columnCustName]);
      print(res);
      return res.first['$columnCustName'];
    } catch (e) {
      return "null";
    }
  }

  Future<ModelCustomers> getDataCustomer() async {
    final db = await database;
    try {
      var res = await db.query(tableCustomer);
      return res.map((data) => ModelCustomers.fromJson(data)).toList().first;
    } catch (e) {
      print("error getData $e");
      return null;
    }
  }

  Future<bool> getSpecialPass() async {
    final db = await database;
    try {
      var res = await db.query(tableCustomer, columns: [columnSpecialPass]);
      return res.isNotEmpty
          ? res.first['SpecialPass'] == "Y" ? true : false
          : false; // if null then default false cause allow scan something.
    } catch (e) {
      print("error getData $e");
      return null;
    }
  }

  Future<String> getIDCustomer() async {
    final db = await database;
    try {
      var res = await db.query(tableCustomer, columns: [columnCustUserID]);
      ModelCustomers data =
          res.map((data) => ModelCustomers.fromJson(data)).toList().first;
      return data.custUserID;
    } catch (e) {
      print("error getData $e");
      return null;
    }
  }

  Future<bool> checkHasCustomer() async {
    final db = await database;
    var res = await db.query(tableCustomer);
    if (res.isNotEmpty)
      return true;
    else
      return false;
  }

  getDataCustomerByID(int id) async {
    final db = await database;
    var res = await db
        .query(tableCustomer, where: '$columnCustUserID = ?', whereArgs: [id]);

    return res.isNotEmpty ? ModelCustomers.fromJson(res.first) : null;
  }

  updateCustomer(ModelCustomers data) async {
    final db = await database;
    var res = await db.update(tableCustomer, data.toJson(),
        where: '$columnCustUserID = ?', whereArgs: [data.custUserID]);

    return res;
  }

  updatePinCode(ModelCustomers data) async {
    final db = await database;
    var res = await db.update(tableCustomer, {"PINcode": data.pINcode},
        where: '$columnCustUserID = ?', whereArgs: [data.custUserID]);
    print("update PINCODE : $res");
    return res;
  }

  Future<bool> updateSpecialPass(ModelCustomers data) async {
    final db = await database;
    var res = await db.update(tableCustomer, {"SpecialPass": data.specialPass},
        where: '$columnCustUserID = ?', whereArgs: [data.custUserID]);
    print("update SpecialPass : $res");
    return res > 0;
  }

  Future<bool> updateUpdateImageProfile(ModelCustomers data) async {
    final db = await database;
    var res = await db.update(
        tableCustomer, {"ImageProfile": data.imageProfile},
        where: '$columnCustUserID = ?', whereArgs: [data.custUserID]);
    print("update ImageProfile : $res");
    return res > 0;
  }

  updateCustomerUsedEditProfile(
      {String custUserID, Map<String, dynamic> values}) async {
    final db = await database;
    var res;
    try {
      res = await db.update(tableCustomer, values,
          where: '$columnCustUserID = ?', whereArgs: [custUserID]);
      print("Update Used For Edit Profile : $res");
      return res > 0 ? true : false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCustomerFieldPinCode(ModelCustomers data) async {
    final db = await database;
    var row = {columnPINcode: data.pINcode};
    try {
      var res = await db.update(tableCustomer, row,
          where: '$columnCustUserID = ?', whereArgs: [data.custUserID]);
      if (res != null) {
        print("Updated");
        return true;
      } else
        return false;
    } catch (e) {
      print("Catch update => $e");
      return false;
    }
  }

  deleteCustomer(int id) async {
    final db = await database;
    try {
      db.delete(tableCustomer, where: '$columnCustUserID = ?', whereArgs: [id]);
      print(id);
    } catch (e) {
      print("ERROR DELECT CUST $e");
    }
  }

  Future<bool> deleteAllDataOfCustomer() async {
    final db = await database;
    try {
      await db.delete(tableCustomer);
      print("deleted");
      return true;
    } catch (e) {
      print("ERROR DELECT CUST $e");
      return false;
    }
  }
}
