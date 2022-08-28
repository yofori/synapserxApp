import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:synapserx_prescriber/models/formulary.dart';
import 'package:flutter/services.dart';

class SqliteService {
  static const String databaseName = "synapserxdb.db";
  static Database? db;

  static Future<Database> initiateDb() async {
    var databasesPath = await getDatabasesPath();
    final path = join(databasesPath, databaseName);
    // Check if the database exists
    bool exists = await databaseExists(path);
    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets/db", databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    return db = await openDatabase(path, readOnly: true);
  }

  // get all the drugs in the database
  static Future<List<Medicines>> getMedicines() async {
    final db = await initiateDb();

    final List<Map<String, Object?>> queryResult = await db.query('medicines');
    return queryResult.map((e) => Medicines.fromMap(e)).toList();
  }
}
