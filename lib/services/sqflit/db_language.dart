import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warranzy_demo/models/model_language.dart';

class DBProviderLanguage {
  DBProviderLanguage._();
  static final DBProviderLanguage db = DBProviderLanguage._();

  static Database _database;
  get getDB => database;
  final String tableName = "Language";

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'languageDB.db');

    var database = await openDatabase(dbPath, version: 1, onCreate: languageDb);

    return database;
  }

  void languageDb(Database database, int version) async {
    await database.execute('''create table $tableName ( 
  id integer primary key autoincrement, 
  name text not null)''');
  }

  //------------------------------------------------------------------------------
  //----------------------------------CRUD----------------------------------------
  Future<bool> addDataLanguage(ModelLanguage data) async {
    final db = await database;
    var res = await db.insert(tableName, data.toJson());
    if (res == 1)
      return true;
    else
      return false;
  }

  getDataLanguage() async {
    final db = await database;
    var res = await db.query(tableName);
    List<ModelLanguage> data = res.isNotEmpty
        ? res.map((data) => ModelLanguage.fromJson(data)).toList()
        : [];

    return data.first.name;
  }

  getDataLanguageByID(int id) async {
    final db = await database;
    var res = await db.query(tableName, where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ModelLanguage.fromJson(res.first) : null;
  }

  Future<bool> checkHasLanguage() async {
    final db = await database;
    var res = await db.query(tableName);
    if (res.isNotEmpty)
      return true;
    else
      return false;
  }

  updateLanguage(ModelLanguage data) async {
    final db = await database;
    var res = await db.update(tableName, data.toJson(),
        where: 'id = ?', whereArgs: [data.id]);

    return res;
  }

  deleteLanguage(int id) async {
    final db = await database;

    db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
