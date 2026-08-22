import 'package:drift/drift.dart';

class StaffProfilesTable extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get role => text()(); // CASHIER, MANAGER, OWNER
  TextColumn get pin => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
