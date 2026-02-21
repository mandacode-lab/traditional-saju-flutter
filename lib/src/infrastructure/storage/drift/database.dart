import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:traditional_saju/src/infrastructure/storage/drift/tables/user_info_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [UserInfoTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  static AppDatabase? _instance;

  static AppDatabase get instance {
    if (_instance != null) return _instance!;
    throw Exception('AppDatabase not initialized. Call initialize() first.');
  }

  @override
  int get schemaVersion => 1;

  static Future<void> closeDatabase() async {
    await _instance?.close();
    _instance = null;
  }

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'saju.db');
    final file = File(path);

    _instance = AppDatabase(NativeDatabase.createInBackground(file));
  }
}
