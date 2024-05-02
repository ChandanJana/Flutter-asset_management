import 'package:mindteck_iot/models/login_model.dart';
import 'package:mindteck_iot/resource/app_database.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, AppDatabase.database),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE ${AppDatabase.userTable}(${AppDatabase.userId} TEXT PRIMARY KEY, ${AppDatabase.tenantId} TEXT, ${AppDatabase.tenantName} TEXT, ${AppDatabase.email} TEXT, ${AppDatabase.token} TEXT, ${AppDatabase.firstName} TEXT, ${AppDatabase.lastName} TEXT, ${AppDatabase.contactNumber} TEXT, ${AppDatabase.registrationDate} TEXT, ${AppDatabase.lastLogin} TEXT , ${AppDatabase.roleName} TEXT, ${AppDatabase.roleId} TEXT)',
          //'CREATE TABLE ${AppDatabase.userTable}(${AppDatabase.userId} TEXT PRIMARY KEY, ${AppDatabase.email} TEXT, ${AppDatabase.token} TEXT, ${AppDatabase.name} TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        //_onUpgrade(db, oldVersion, newVersion, AppDatabase.database, AppDatabase.name, 'TEXT');
      },
      version: AppDatabase.databaseVersion,
    );
    return db;
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(AppDatabase.userTable, row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> query() async {
    final db = await database;
    final data = await db.query(AppDatabase.userTable);
    print('User data $data');
    return data;
  }

  Future<List<LoginModel>> queryAll() async {
    final db = await database;
    final data = await db.query(AppDatabase.userTable);
    print('User data $data');
    List<LoginModel> login =
        data.map((item) => LoginModel.fromJson(item)).toList();

    print('User login $login');
    return login;
  }

  Future<int> update(Map<String, dynamic> row) async {
    final db = await database;
    return await db.update(AppDatabase.userTable, row,
        where: '${AppDatabase.userId} = ?', whereArgs: [row['id']]);
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(AppDatabase.userTable,
        where: '${AppDatabase.userId} = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    final db = await database;
    return await db.delete(AppDatabase.userTable);
  }
}
