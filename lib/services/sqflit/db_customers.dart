import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warranzy_demo/models/model_mas_cust.dart';

class DBProviderCustomer {
  DBProviderCustomer._();
  static final DBProviderCustomer db = DBProviderCustomer._();

  static Database _database;
  get getDB => database;
  final String tableName = "Customer";
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
    await database.execute("CREATE TABLE $tableName ("
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
        "$columnPackageType TEXT"
        ")");
  }

  //------------------------------------------------------------------------------
  //----------------------------------CRUD----------------------------------------
  Future<bool> addDataCustomer(ModelCustomers data) async {
    final db = await database;
    var res;
    try {
      res = await db.insert(tableName, data.toJson());
      print(res);
    } catch (e) {
      print("Can't insert data customer");
    }
    return res > 0 ? true : false;
  }

  Future<ModelCustomers> getDataCustomer() async {
    final db = await database;
    try {
      var res = await db.query(tableName);
      return res.map((data) => ModelCustomers.fromJson(data)).toList().first;
    } catch (e) {
      print("error gerData $e");
      return null;
    }
  }

  Future<String> getIDCustomer() async {
    final db = await database;
    try {
      var res = await db.query(tableName, columns: [columnCustUserID]);
      ModelCustomers data =
          res.map((data) => ModelCustomers.fromJson(data)).toList().first;
      return data.custUserID;
    } catch (e) {
      print("error gerData $e");
      return null;
    }
  }

  Future<bool> checkHasCustomer() async {
    final db = await database;
    var res = await db.query(tableName);
    if (res.isNotEmpty)
      return true;
    else
      return false;
  }

  getDataCustomerByID(int id) async {
    final db = await database;
    var res = await db
        .query(tableName, where: '$columnCustUserID = ?', whereArgs: [id]);

    return res.isNotEmpty ? ModelCustomers.fromJson(res.first) : null;
  }

  updateCustomer(ModelCustomers data) async {
    final db = await database;
    var res = await db.update(tableName, data.toJson(),
        where: '$columnCustUserID = ?', whereArgs: [data.custUserID]);

    return res;
  }

  Future<bool> updateCustomerFieldPinCode(ModelCustomers data) async {
    final db = await database;
    var row = {columnPINcode: data.pINcode};
    try {
      var res = await db.update(tableName, row,
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
      db.delete(tableName, where: '$columnCustUserID = ?', whereArgs: [id]);
      print(id);
    } catch (e) {
      print("ERROR DELECT CUST $e");
    }
  }

  Future<bool> deleteAllDataOfCustomer() async {
    final db = await database;
    try {
      await db.delete(tableName);
      print("deleted");
      return true;
    } catch (e) {
      print("ERROR DELECT CUST $e");
      return false;
    }
  }
}
