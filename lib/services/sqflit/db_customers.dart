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
        "$columnCustUserID INTEGER PRIMARY KEY AUTOINCREMENT,"
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

  getDataCustomer() async {
    final db = await database;
    var res = await db.query(tableName);
    List<ModelCustomers> data = res.isNotEmpty
        ? res.map((data) => ModelCustomers.fromJson(data)).toList()
        : [];

    return data;
  }

  getDataCustomerByID(int id) async {
    final db = await database;
    var res = await db.query(tableName, where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ModelCustomers.fromJson(res.first) : null;
  }

  updateCustomer(ModelCustomers data) async {
    final db = await database;
    var res = await db.update(tableName, data.toJson(),
        where: 'id = ?', whereArgs: [data.custUserID]);

    return res;
  }

  deleteCustomer(int id) async {
    final db = await database;

    db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
