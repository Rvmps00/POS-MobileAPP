import 'package:drift/drift.dart';

@DataClassName('StockHistoryData')
class StockHistoryTable extends Table {
  @override
  String get tableName => 'stock_history';

  TextColumn get id => text()(); // UUID
  TextColumn get productId => text()(); // FK → products.id or addon_toppings.id
  TextColumn get itemType => text().withDefault(const Constant('PRODUCT'))(); // PRODUCT or TOPPING
  IntColumn get previousQty => integer()();
  IntColumn get newQty => integer()();
  TextColumn get changeType => text()(); // SALE, RESTOCK, ADJUSTMENT, WASTE
  IntColumn get changeAmount => integer()(); // can be negative
  TextColumn get notes => text().nullable()();
  TextColumn get userId => text().nullable()(); // FK → auth.users.id
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
