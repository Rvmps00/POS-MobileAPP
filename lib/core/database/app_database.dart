import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/categories_table.dart';
import 'tables/products_table.dart';
import 'tables/default_ingredients_table.dart';
import 'tables/addon_toppings_table.dart';
import 'tables/orders_table.dart';
import 'tables/order_items_table.dart';
import 'tables/stock_history_table.dart';
import 'tables/sync_queue_table.dart';
import 'tables/shifts_table.dart';
import 'daos/catalog_dao.dart';
import 'converters/json_list_converter.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    CategoriesTable,
    ProductsTable,
    DefaultIngredientsTable,
    AddonToppingsTable,
    OrdersTable,
    OrderItemsTable,
    StockHistoryTable,
    SyncQueueTable,
    ShiftsTable,
  ],
  daos: [CatalogDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Add new columns to existing tables
          await m.addColumn(productsTable, productsTable.lowStockThreshold);
          await m.addColumn(addonToppingsTable, addonToppingsTable.stockQty);
          await m.addColumn(
            addonToppingsTable,
            addonToppingsTable.lowStockThreshold,
          );

          // Create new tables
          await m.createTable(stockHistoryTable);
          await m.createTable(syncQueueTable);
        }
        if (from < 3) {
          // Add Orders tables that were missed in earlier migrations
          await m.createTable(ordersTable);
          await m.createTable(orderItemsTable);
        }
        if (from < 4) {
          await m.addColumn(productsTable, productsTable.variations);
          await m.addColumn(orderItemsTable, orderItemsTable.selectedVariation);
        }
        if (from < 5) {
          await m.createTable(shiftsTable);
        }
      },
    );
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'lesehan_surya_pos.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
