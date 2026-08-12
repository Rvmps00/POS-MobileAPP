import 'package:drift/drift.dart';

@DataClassName('OrdersTableData')
class OrdersTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get orderNumber => text()();
  TextColumn get orderType => text()(); // 'DINE_IN' or 'TAKEAWAY'
  IntColumn get tableNumber => integer().nullable()();
  IntColumn get subtotal => integer()(); // stored as int (rupiah)
  IntColumn get taxAmount => integer()();
  IntColumn get grandTotal => integer()();
  TextColumn get paymentMethod => text().withDefault(const Constant('CASH'))();
  TextColumn get paymentStatus => text().withDefault(const Constant('PAID'))();
  IntColumn get cashReceived => integer().nullable()();
  IntColumn get cashChange => integer().nullable()();
  TextColumn get status => text().withDefault(const Constant('COMPLETED'))();
  TextColumn get cashierId => text().nullable()(); // UUID
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
