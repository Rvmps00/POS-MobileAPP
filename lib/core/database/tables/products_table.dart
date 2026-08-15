import 'package:drift/drift.dart';
import '../converters/json_list_converter.dart';

class ProductsTable extends Table {
  @override
  String get tableName => 'products';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nameEn => text().nullable()();
  TextColumn get description => text().nullable()();
  IntColumn get basePrice => integer()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();
  IntColumn get stockQty => integer().withDefault(const Constant(0))();
  IntColumn get lowStockThreshold => integer().withDefault(const Constant(10))();
  TextColumn get variations => text().map(const StringListConverter()).nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
