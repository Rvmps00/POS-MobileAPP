import 'package:drift/drift.dart';

class AddonToppingsTable extends Table {
  @override
  String get tableName => 'addon_toppings';

  TextColumn get id => text()();
  TextColumn get productId => text()();
  TextColumn get name => text()();
  TextColumn get nameEn => text().nullable()();
  IntColumn get price => integer().withDefault(const Constant(0))();
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();
  IntColumn get stockQty => integer().withDefault(const Constant(0))();
  IntColumn get lowStockThreshold => integer().withDefault(const Constant(10))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
