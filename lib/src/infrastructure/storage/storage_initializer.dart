import 'package:traditional_saju/src/infrastructure/storage/drift/database.dart';

class StorageInitializer {
  static Future<void> initialize() async {
    await AppDatabase.initialize();
  }

  static Future<void> close() async {
    await AppDatabase.closeDatabase();
  }
}
