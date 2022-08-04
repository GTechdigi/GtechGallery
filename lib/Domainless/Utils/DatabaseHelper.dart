import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "GtechApp.db";
  static final _databaseVersion = 1;

  static final gtAppListTable = 'GtAppList';
  static final gtAppBuildListTable = 'GtAppBuildList';

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $gtAppListTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        appKey TEXT,
        buildKey TEXT,
        buildName TEXT,
        buildIcon TEXT,
        buildVersion TEXT,
        buildVersionNo TEXT,
        buildBuildVersion TEXT,
        buildCreated TEXT,
        buildType TEXT,
        buildIdentifier TEXT,
        buildFileName TEXT,
        buildFileSize TEXT
      )
      ''');

    await db.execute('''
      CREATE TABLE $gtAppBuildListTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        appKey TEXT,
        buildKey TEXT,
        buildName TEXT,
        buildIcon TEXT,
        buildVersion TEXT,
        buildVersionNo TEXT,
        buildBuildVersion TEXT,
        buildCreated TEXT,
        buildType TEXT,
        buildIdentifier TEXT,
        buildFileName TEXT,
        buildFileSize TEXT,
        buildEnv TEXT
      )
      ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    try {
      var id = await db.insert(table, row);
      //print('inserted row id in local: $id');
      return id;
    } catch (e) {
      //print("error: $e");
      return -1;
    }
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>?> queryAllRows(String table) async {
    Database db = await instance.database;
    try {
      var rows = await db.query(table);
      //print('$table query all rows:');
      // rows.forEach((row) => print(row));
      return rows;
    } catch (e) {
      //print("error: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> queryRowsWhere(
      String table, Map<String, dynamic> where,
      {int limit = 20, int offset = 0}) async {
    Database db = await instance.database;

    var whereClause = where.keys.map((e) => "$e = ?").join(" AND ");
    var whereArgs = where.values.toList();

    try {
      var rows = await db.query(table,
          where: whereClause,
          whereArgs: whereArgs,
          limit: limit,
          orderBy: "id DESC",
          offset: offset);
      //print('$table query ${rows.length} rows');
      return rows;
    } catch (e) {
      //print("error: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> queryRowsWhereOrderBy(
      String table, Map<String, dynamic> where, String orderBy,
      {int limit = 20, int offset = 0}) async {
    Database db = await instance.database;

    var whereClause = where.keys.map((e) => "$e = ?").join(" AND ");
    var whereArgs = where.values.toList();

    try {
      var rows = await db.query(table,
          where: whereClause,
          whereArgs: whereArgs,
          limit: limit,
          orderBy: orderBy,
          offset: offset);
      //print('$table query ${rows.length} rows');
      return rows;
    } catch (e) {
      //print("error: $e");
      return null;
    }
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<Object?> queryRowCount(String table,
      {required Map<String, dynamic> where}) async {
    Database db = await instance.database;
    try {
      if (where != null) {
        var whereClause = where.keys.map((e) => "$e = ?").join(" AND ");
        var whereArgs = where.values.toList();

        var row = await db.query(
          table,
          columns: ["COUNT(*)"],
          where: whereClause,
          whereArgs: whereArgs,
        );
        print('$table row count: $row');
        return row.first.values.first;
      }

      var rowCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $table'));
      print('$table row count: $rowCount');
      return rowCount;
    } catch (e) {
      //print("error: $e");
      return -1;
    }
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row, String table,
      Map<String, dynamic> where) async {
    Database db = await instance.database;
    try {
      var rowsAffected = await db.update(table, row,
          where: '${where.keys.first} = ?', whereArgs: [where.values.first]);
      //print('updated $rowsAffected row(s)');
      return rowsAffected;
    } catch (e) {
      //print("error: $e");
      return -1;
    }
  }

  Future<int> insertOrUpdate(Map<String, dynamic> row, String table,
      Map<String, dynamic> where) async {
    var rowCount = await queryRowCount(table, where: where);
    if(rowCount is int && rowCount > 0) {
      // Update
      return update(row, table, where);
    } else {
      // Insert
      where.forEach((key, value) {
        row[key] = value;
      });
      return insert(row, table);
    }
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String id, String table) async {
    Database db = await instance.database;
    try {
      var rowsDeleted =
          await db.delete(table, where: 'id = ?', whereArgs: [id]);
      //print('deleted $rowsDeleted row(s): row $id');
      return rowsDeleted;
    } catch (e) {
      //print("error: $e");
      return -1;
    }
  }

  // Future<int> truncateTable(String table) async {
  //   Database db = await instance.database;
  //   try {
  //     var truncate = await db.rawQuery("TRUNCATE TABLE $table");

  //     print('truncate table $table is $truncate');
  //     return 1;
  //   } catch (e) {
  //     print("error: $e");
  //     return -1;
  //   }
  // }

  Future<int> deleteAllRows(String table) async {
    Database db = await instance.database;
    try {
      var rowsDeleted = await db.delete(table);
      //print('deleted $rowsDeleted row(s)');
      return rowsDeleted;
    } catch (e) {
      //print("error: $e");
      return -1;
    }
  }
}
