import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/categories_table.dart';
import 'tables/products_table.dart';
import 'tables/default_ingredients_table.dart';
import 'tables/addon_toppings_table.dart';
import 'daos/catalog_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    CategoriesTable,
    ProductsTable,
    DefaultIngredientsTable,
    AddonToppingsTable,
  ],
  daos: [CatalogDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'lesehan_surya_pos.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
