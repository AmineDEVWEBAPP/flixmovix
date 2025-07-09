import 'package:sqflite/sqflite.dart';

import '../utils/methodes.dart';

class SQFliteService {
  SQFliteService._();

  static final SQFliteService _instance = SQFliteService._();

  final String dbPath = 'appData.db';

  final String tableName = 'appData';

  static Future init() async {
    logger('SQFlite init');
    Database db = await openDatabase(_instance.dbPath);

    // check if appData table is exist
    List appVarsIsExest = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='${_instance.tableName}'");

    // if the table is not exist it will be created
    if (appVarsIsExest.isEmpty) {
      logger('SQFlite create table');
      await db.rawQuery(
          "CREATE TABLE `${_instance.tableName}`(`${DbColumns.searchSuggestion.name}` TEXT)");
    }
  }

  static Future<bool> write(dynamic value, DbColumns column) async {
    logger('SQFlite write (column: ${column.name} value: $value)');
    Database db = await openDatabase(_instance.dbPath);

    int status = await db.insert(_instance.tableName, {column.name: value});
    db.close();
    return status == 1 ? true : false;
  }

  static Future<List<Map<String, Object?>>> read({
    List<DbColumns>? columns,
  }) async {
    logger('SQFlite read');
    Database db = await openDatabase(_instance.dbPath);

    List<Map<String, Object?>> data = await db.query(_instance.tableName,
        columns: columns?.map((el) => el.name).toList());
    db.close();
    return data;
  }

  static Future<bool> delete(DbColumns column, dynamic value) async {
    logger('SQFlite delete');
    Database db = await openDatabase(_instance.dbPath);

    int status = await db.delete(_instance.tableName,
        where: '${column.name}=?', whereArgs: [value]);
    db.close();
    return status == 1 ? true : false;
  }
}

enum DbColumns { searchSuggestion }
