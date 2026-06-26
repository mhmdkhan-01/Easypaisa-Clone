import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  Database? myDB;

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    String dbPath = join(appDir.path, "transactionDB.db");

    return await openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE transactions (
        s_no INTEGER PRIMARY KEY AUTOINCREMENT,
        trx_date TEXT,
        trx_time TEXT,
        receiver TEXT,
        amount INTEGER
      )
    ''');
      },
    );
  }

  Future<bool> addTransaction({
    required String date,
    required String time,
    required String to,
    required int amount,
  }) async {
    Database db = await getDB();
    int rowsEffected = await db.insert('transactions', {
      'trx_date': date,
      'trx_time': time,
      'receiver': to,
      'amount': amount,
    });
    return rowsEffected > 0;
  }

  Future<List<Map<String, dynamic>>> getAllTransactions() async {
    Database db = await getDB();

    List<Map<String, dynamic>> allTrx = await db.query(
      'transactions',
      orderBy: 's_no DESC',
    );

    return allTrx;
  }
}
