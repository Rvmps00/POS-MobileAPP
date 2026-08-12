// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_dao.dart';

// ignore_for_file: type=lint
mixin _$CatalogDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTableTable get categoriesTable => attachedDatabase.categoriesTable;
  $ProductsTableTable get productsTable => attachedDatabase.productsTable;
  $DefaultIngredientsTableTable get defaultIngredientsTable =>
      attachedDatabase.defaultIngredientsTable;
  $AddonToppingsTableTable get addonToppingsTable =>
      attachedDatabase.addonToppingsTable;
  CatalogDaoManager get managers => CatalogDaoManager(this);
}

class CatalogDaoManager {
  final _$CatalogDaoMixin _db;
  CatalogDaoManager(this._db);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(
        _db.attachedDatabase,
        _db.categoriesTable,
      );
  $$ProductsTableTableTableManager get productsTable =>
      $$ProductsTableTableTableManager(_db.attachedDatabase, _db.productsTable);
  $$DefaultIngredientsTableTableTableManager get defaultIngredientsTable =>
      $$DefaultIngredientsTableTableTableManager(
        _db.attachedDatabase,
        _db.defaultIngredientsTable,
      );
  $$AddonToppingsTableTableTableManager get addonToppingsTable =>
      $$AddonToppingsTableTableTableManager(
        _db.attachedDatabase,
        _db.addonToppingsTable,
      );
}
