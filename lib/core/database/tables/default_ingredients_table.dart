import 'package:drift/drift.dart';

class DefaultIngredientsTable extends Table {
  @override
  String get tableName => 'default_ingredients';

  TextColumn get id => text()();
  TextColumn get productId => text()();
  TextColumn get name => text()();
  TextColumn get nameEn => text().nullable()();
  BoolColumn get isRemovable => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
