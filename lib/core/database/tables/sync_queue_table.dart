import 'package:drift/drift.dart';

@DataClassName('SyncQueueData')
class SyncQueueTable extends Table {
  @override
  String get tableName => 'sync_queue';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get tableName_ => text().named('table_name')();
  TextColumn get recordId => text()();
  TextColumn get operation => text()(); // INSERT, UPDATE, DELETE
  TextColumn get payload => text()(); // JSON string
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get status => text().withDefault(const Constant('PENDING'))(); // PENDING, SYNCED, FAILED
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
}
