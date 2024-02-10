import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 3;
  static final table = 'books';

  static final columnId = '_id';
  static final columnTitle = 'title';
  static final columnAuthor = 'author';
  static final columnCategory = 'category';
  static final columnPrice = 'price';
  static final columnAddedTime = 'addedTime';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnAuthor TEXT NOT NULL,
            $columnCategory TEXT NOT NULL,
            $columnPrice TEXT NOT NULL,
            $columnAddedTime TEXT NOT NULL
          )
          ''');
  }
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // バージョン1からバージョン2へのアップグレードロジック
      await db.execute("ALTER TABLE books ADD COLUMN price TEXT");
    }
    // さらに新しいバージョンへのアップグレードが必要な場合は、ここにロジックを追加
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await database;
    return await db.query(table);
  }

  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> resetDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // データベースファイルを削除
    await deleteDatabase(path);

    // _databaseをnullに設定して、再初期化を強制
    _database = null;

    // データベースを再初期化
    await database;
  }
  Future<double> getTotalAmount() async {
    Database db = await database;
    // CASTを使ってTEXT型のpriceをREALに変換
    String sql = 'SELECT SUM(CAST(price AS REAL)) as total FROM books';
    var result = await db.rawQuery(sql);
    double total = result[0]['total'] != null ? (result[0]['total'] as num).toDouble() : 0.0;
    return total;
  }

  Future<List<Map<String, dynamic>>> getMonthlyAmount() async {
    Database db = await database;
    String sql = '''
  SELECT
    strftime('%Y-%m', addedTime) as month,
    SUM(CAST(price AS REAL)) as monthlyTotal
  FROM
    books
  GROUP BY
    month
  ORDER BY
    month DESC
  ''';
    var result = await db.rawQuery(sql);
    return result;
  }



}
