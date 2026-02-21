import 'package:drift/drift.dart';

class UserInfoTable extends Table {
  TextColumn get gender => text()();
  TextColumn get jobStatus => text()();
  TextColumn get datingStatus => text()();
  DateTimeColumn get birthdate => dateTime()();
  BoolColumn get permanent => boolean()();
}
