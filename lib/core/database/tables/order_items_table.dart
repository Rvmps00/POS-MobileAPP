import 'package:drift/drift.dart';
import '../converters/json_list_converter.dart';

@DataClassName('OrderItemsTableData')
class OrderItemsTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get orderId => text()(); // UUID
  TextColumn get productId => text()(); // UUID
  TextColumn get productName => text()();
  IntColumn get quantity => integer()();
  IntColumn get basePrice => integer()();
  IntColumn get toppingTotal => integer().withDefault(const Constant(0))();
  IntColumn get lineTotal => integer()();

  // Stored as JSON strings
  TextColumn get removedIngredients =>
      text().map(const StringListConverter()).nullable()();
  TextColumn get addedToppings =>
      text().map(const MapListConverter()).nullable()();

  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
