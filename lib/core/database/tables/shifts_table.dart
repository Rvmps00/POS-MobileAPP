import 'package:drift/drift.dart';

@DataClassName('ShiftEntry')
class ShiftsTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  RealColumn get startingCash => real()();
  RealColumn get expectedEndingCash => real().nullable()();
  RealColumn get actualEndingCash => real().nullable()();
  TextColumn get status => text().withDefault(const Constant('OPEN'))(); // OPEN, CLOSED
  TextColumn get cashierId => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}
