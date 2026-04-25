import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'app.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT,
          email TEXT,
          password TEXT
        )
        ''');
      },
    );
  }

  static String encrypt(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  static Future register(String u, String e, String p) async {
    final dbClient = await db;

    await dbClient.insert(
      'users',
      {
        'username': u,
        'email': e,
        'password': encrypt(p),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<bool> login(String u, String p) async {
    final dbClient = await db;

    final res = await dbClient.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [u, encrypt(p)],
    );

    return res.isNotEmpty;
  }
}
