import 'package:sqflite/sqflite.dart';

import '../config/enums.dart';
import '../utils/methodes.dart';

class StorageService {
  StorageService._();
  static final StorageService _instance = StorageService._();
  String dbPath = 'appStorage.db';
  String tableName = 'appVars';

  static Future init() async {
    logger('init db');
    Database db = await openDatabase(_instance.dbPath);

    // check if the table is exect
    var results = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='${_instance.tableName}'");

    if (results.isEmpty) {
      logger('create table');
      await db.rawQuery(
          "CREATE TABLE `${_instance.tableName}`(`${DbColumns.themeMode.name}` TEXT, `${DbColumns.isFirstOpen.name}` BOOLEAN)");
    }

    await db.close();
  }

  static Future write(DbColumns key, var value) async {
    logger('Storage write (key: ${key.name} , value: $value)');
    Database db = await openDatabase(_instance.dbPath);

    // check if data is exect
    var result = await db
        .rawQuery("SELECT `${key.name}` FROM  `${_instance.tableName}`");
    if (result.isEmpty) {
      await db.rawQuery(
          "INSERT INTO `${_instance.tableName}` (`${key.name}`)VALUES('$value')");
    } else {
      await update(key, value);
    }

    await db.close();
  }

  static Future<Map<String, Object?>> read(DbColumns key) async {
    logger('Storage read');
    Database db = await openDatabase(_instance.dbPath);

    List<Map<String, Object?>> dt =
        await db.rawQuery("SELECT `${key.name}` FROM `${_instance.tableName}`");
    if (dt.isNotEmpty) {
      return dt[0];
    } else {
      return {};
    }
  }

  static Future update(DbColumns key, var value) async {
    logger('Storage update');
    Database db = await openDatabase(_instance.dbPath);
    await db
        .rawQuery("UPDATE `${_instance.tableName}` SET `${key.name}`='$value'");
    await db.close();
  }
}
