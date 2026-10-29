import 'package:drift/drift.dart';

@DataClassName('ExpensesTableData')
class ExpensesTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get title => text()();
  IntColumn get amount => integer()(); // Stored as integer Rupiah
  TextColumn get category => text()(); // 'INGREDIENTS', 'OPERATIONAL', 'SALARY', 'SUPPLIES', 'OTHER'
  TextColumn get paymentSource => text().withDefault(const Constant('CASH_DRAWER'))(); // 'CASH_DRAWER', 'BANK_TRANSFER', 'OWNER_POCKET'
  TextColumn get notes => text().nullable()();
  TextColumn get receiptImagePath => text().nullable()();
  DateTimeColumn get expenseDate => dateTime()();
  TextColumn get shiftId => text().nullable()();
  TextColumn get createdByStaffId => text().nullable()();
  TextColumn get createdByName => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
