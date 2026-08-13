// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameEn,
    icon,
    sortOrder,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final String id;
  final String name;
  final String? nameEn;
  final String? icon;
  final int sortOrder;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CategoriesTableData({
    required this.id,
    required this.name,
    this.nameEn,
    this.icon,
    required this.sortOrder,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CategoriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      icon: serializer.fromJson<String?>(json['icon']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameEn': serializer.toJson<String?>(nameEn),
      'icon': serializer.toJson<String?>(icon),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CategoriesTableData copyWith({
    String? id,
    String? name,
    Value<String?> nameEn = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    int? sortOrder,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CategoriesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
    icon: icon.present ? icon.value : this.icon,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      icon: data.icon.present ? data.icon.value : this.icon,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nameEn,
    icon,
    sortOrder,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameEn == this.nameEn &&
          other.icon == this.icon &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> nameEn;
  final Value<String?> icon;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String id,
    required String name,
    this.nameEn = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<CategoriesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameEn,
    Expression<String>? icon,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameEn != null) 'name_en': nameEn,
      if (icon != null) 'icon': icon,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? nameEn,
    Value<String?>? icon,
    Value<int>? sortOrder,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTableTable extends ProductsTable
    with TableInfo<$ProductsTableTable, ProductsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _basePriceMeta = const VerificationMeta(
    'basePrice',
  );
  @override
  late final GeneratedColumn<int> basePrice = GeneratedColumn<int>(
    'base_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAvailableMeta = const VerificationMeta(
    'isAvailable',
  );
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
    'is_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_available" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _stockQtyMeta = const VerificationMeta(
    'stockQty',
  );
  @override
  late final GeneratedColumn<int> stockQty = GeneratedColumn<int>(
    'stock_qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lowStockThresholdMeta = const VerificationMeta(
    'lowStockThreshold',
  );
  @override
  late final GeneratedColumn<int> lowStockThreshold = GeneratedColumn<int>(
    'low_stock_threshold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameEn,
    description,
    basePrice,
    categoryId,
    imageUrl,
    isAvailable,
    stockQty,
    lowStockThreshold,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('base_price')) {
      context.handle(
        _basePriceMeta,
        basePrice.isAcceptableOrUnknown(data['base_price']!, _basePriceMeta),
      );
    } else if (isInserting) {
      context.missing(_basePriceMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('is_available')) {
      context.handle(
        _isAvailableMeta,
        isAvailable.isAcceptableOrUnknown(
          data['is_available']!,
          _isAvailableMeta,
        ),
      );
    }
    if (data.containsKey('stock_qty')) {
      context.handle(
        _stockQtyMeta,
        stockQty.isAcceptableOrUnknown(data['stock_qty']!, _stockQtyMeta),
      );
    }
    if (data.containsKey('low_stock_threshold')) {
      context.handle(
        _lowStockThresholdMeta,
        lowStockThreshold.isAcceptableOrUnknown(
          data['low_stock_threshold']!,
          _lowStockThresholdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      basePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_price'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      isAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_available'],
      )!,
      stockQty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_qty'],
      )!,
      lowStockThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}low_stock_threshold'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductsTableTable createAlias(String alias) {
    return $ProductsTableTable(attachedDatabase, alias);
  }
}

class ProductsTableData extends DataClass
    implements Insertable<ProductsTableData> {
  final String id;
  final String name;
  final String? nameEn;
  final String? description;
  final int basePrice;
  final String? categoryId;
  final String? imageUrl;
  final bool isAvailable;
  final int stockQty;
  final int lowStockThreshold;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProductsTableData({
    required this.id,
    required this.name,
    this.nameEn,
    this.description,
    required this.basePrice,
    this.categoryId,
    this.imageUrl,
    required this.isAvailable,
    required this.stockQty,
    required this.lowStockThreshold,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['base_price'] = Variable<int>(basePrice);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['is_available'] = Variable<bool>(isAvailable);
    map['stock_qty'] = Variable<int>(stockQty);
    map['low_stock_threshold'] = Variable<int>(lowStockThreshold);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductsTableCompanion toCompanion(bool nullToAbsent) {
    return ProductsTableCompanion(
      id: Value(id),
      name: Value(name),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      basePrice: Value(basePrice),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      isAvailable: Value(isAvailable),
      stockQty: Value(stockQty),
      lowStockThreshold: Value(lowStockThreshold),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProductsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      description: serializer.fromJson<String?>(json['description']),
      basePrice: serializer.fromJson<int>(json['basePrice']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      stockQty: serializer.fromJson<int>(json['stockQty']),
      lowStockThreshold: serializer.fromJson<int>(json['lowStockThreshold']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameEn': serializer.toJson<String?>(nameEn),
      'description': serializer.toJson<String?>(description),
      'basePrice': serializer.toJson<int>(basePrice),
      'categoryId': serializer.toJson<String?>(categoryId),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'stockQty': serializer.toJson<int>(stockQty),
      'lowStockThreshold': serializer.toJson<int>(lowStockThreshold),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProductsTableData copyWith({
    String? id,
    String? name,
    Value<String?> nameEn = const Value.absent(),
    Value<String?> description = const Value.absent(),
    int? basePrice,
    Value<String?> categoryId = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    bool? isAvailable,
    int? stockQty,
    int? lowStockThreshold,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ProductsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
    description: description.present ? description.value : this.description,
    basePrice: basePrice ?? this.basePrice,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    isAvailable: isAvailable ?? this.isAvailable,
    stockQty: stockQty ?? this.stockQty,
    lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProductsTableData copyWithCompanion(ProductsTableCompanion data) {
    return ProductsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      description: data.description.present
          ? data.description.value
          : this.description,
      basePrice: data.basePrice.present ? data.basePrice.value : this.basePrice,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      isAvailable: data.isAvailable.present
          ? data.isAvailable.value
          : this.isAvailable,
      stockQty: data.stockQty.present ? data.stockQty.value : this.stockQty,
      lowStockThreshold: data.lowStockThreshold.present
          ? data.lowStockThreshold.value
          : this.lowStockThreshold,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('description: $description, ')
          ..write('basePrice: $basePrice, ')
          ..write('categoryId: $categoryId, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('stockQty: $stockQty, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nameEn,
    description,
    basePrice,
    categoryId,
    imageUrl,
    isAvailable,
    stockQty,
    lowStockThreshold,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameEn == this.nameEn &&
          other.description == this.description &&
          other.basePrice == this.basePrice &&
          other.categoryId == this.categoryId &&
          other.imageUrl == this.imageUrl &&
          other.isAvailable == this.isAvailable &&
          other.stockQty == this.stockQty &&
          other.lowStockThreshold == this.lowStockThreshold &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsTableCompanion extends UpdateCompanion<ProductsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> nameEn;
  final Value<String?> description;
  final Value<int> basePrice;
  final Value<String?> categoryId;
  final Value<String?> imageUrl;
  final Value<bool> isAvailable;
  final Value<int> stockQty;
  final Value<int> lowStockThreshold;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProductsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.description = const Value.absent(),
    this.basePrice = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsTableCompanion.insert({
    required String id,
    required String name,
    this.nameEn = const Value.absent(),
    this.description = const Value.absent(),
    required int basePrice,
    this.categoryId = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       basePrice = Value(basePrice);
  static Insertable<ProductsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameEn,
    Expression<String>? description,
    Expression<int>? basePrice,
    Expression<String>? categoryId,
    Expression<String>? imageUrl,
    Expression<bool>? isAvailable,
    Expression<int>? stockQty,
    Expression<int>? lowStockThreshold,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameEn != null) 'name_en': nameEn,
      if (description != null) 'description': description,
      if (basePrice != null) 'base_price': basePrice,
      if (categoryId != null) 'category_id': categoryId,
      if (imageUrl != null) 'image_url': imageUrl,
      if (isAvailable != null) 'is_available': isAvailable,
      if (stockQty != null) 'stock_qty': stockQty,
      if (lowStockThreshold != null) 'low_stock_threshold': lowStockThreshold,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? nameEn,
    Value<String?>? description,
    Value<int>? basePrice,
    Value<String?>? categoryId,
    Value<String?>? imageUrl,
    Value<bool>? isAvailable,
    Value<int>? stockQty,
    Value<int>? lowStockThreshold,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProductsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      stockQty: stockQty ?? this.stockQty,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (basePrice.present) {
      map['base_price'] = Variable<int>(basePrice.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (stockQty.present) {
      map['stock_qty'] = Variable<int>(stockQty.value);
    }
    if (lowStockThreshold.present) {
      map['low_stock_threshold'] = Variable<int>(lowStockThreshold.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('description: $description, ')
          ..write('basePrice: $basePrice, ')
          ..write('categoryId: $categoryId, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('stockQty: $stockQty, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DefaultIngredientsTableTable extends DefaultIngredientsTable
    with TableInfo<$DefaultIngredientsTableTable, DefaultIngredientsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DefaultIngredientsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRemovableMeta = const VerificationMeta(
    'isRemovable',
  );
  @override
  late final GeneratedColumn<bool> isRemovable = GeneratedColumn<bool>(
    'is_removable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_removable" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    name,
    nameEn,
    isRemovable,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'default_ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<DefaultIngredientsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    if (data.containsKey('is_removable')) {
      context.handle(
        _isRemovableMeta,
        isRemovable.isAcceptableOrUnknown(
          data['is_removable']!,
          _isRemovableMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DefaultIngredientsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DefaultIngredientsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
      isRemovable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_removable'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $DefaultIngredientsTableTable createAlias(String alias) {
    return $DefaultIngredientsTableTable(attachedDatabase, alias);
  }
}

class DefaultIngredientsTableData extends DataClass
    implements Insertable<DefaultIngredientsTableData> {
  final String id;
  final String productId;
  final String name;
  final String? nameEn;
  final bool isRemovable;
  final int sortOrder;
  const DefaultIngredientsTableData({
    required this.id,
    required this.productId,
    required this.name,
    this.nameEn,
    required this.isRemovable,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    map['is_removable'] = Variable<bool>(isRemovable);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  DefaultIngredientsTableCompanion toCompanion(bool nullToAbsent) {
    return DefaultIngredientsTableCompanion(
      id: Value(id),
      productId: Value(productId),
      name: Value(name),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
      isRemovable: Value(isRemovable),
      sortOrder: Value(sortOrder),
    );
  }

  factory DefaultIngredientsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DefaultIngredientsTableData(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      isRemovable: serializer.fromJson<bool>(json['isRemovable']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'name': serializer.toJson<String>(name),
      'nameEn': serializer.toJson<String?>(nameEn),
      'isRemovable': serializer.toJson<bool>(isRemovable),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  DefaultIngredientsTableData copyWith({
    String? id,
    String? productId,
    String? name,
    Value<String?> nameEn = const Value.absent(),
    bool? isRemovable,
    int? sortOrder,
  }) => DefaultIngredientsTableData(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    name: name ?? this.name,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
    isRemovable: isRemovable ?? this.isRemovable,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  DefaultIngredientsTableData copyWithCompanion(
    DefaultIngredientsTableCompanion data,
  ) {
    return DefaultIngredientsTableData(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      isRemovable: data.isRemovable.present
          ? data.isRemovable.value
          : this.isRemovable,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DefaultIngredientsTableData(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('isRemovable: $isRemovable, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, name, nameEn, isRemovable, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DefaultIngredientsTableData &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.nameEn == this.nameEn &&
          other.isRemovable == this.isRemovable &&
          other.sortOrder == this.sortOrder);
}

class DefaultIngredientsTableCompanion
    extends UpdateCompanion<DefaultIngredientsTableData> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> name;
  final Value<String?> nameEn;
  final Value<bool> isRemovable;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const DefaultIngredientsTableCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.isRemovable = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DefaultIngredientsTableCompanion.insert({
    required String id,
    required String productId,
    required String name,
    this.nameEn = const Value.absent(),
    this.isRemovable = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       name = Value(name);
  static Insertable<DefaultIngredientsTableData> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? name,
    Expression<String>? nameEn,
    Expression<bool>? isRemovable,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (nameEn != null) 'name_en': nameEn,
      if (isRemovable != null) 'is_removable': isRemovable,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DefaultIngredientsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? name,
    Value<String?>? nameEn,
    Value<bool>? isRemovable,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return DefaultIngredientsTableCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      isRemovable: isRemovable ?? this.isRemovable,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (isRemovable.present) {
      map['is_removable'] = Variable<bool>(isRemovable.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DefaultIngredientsTableCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('isRemovable: $isRemovable, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AddonToppingsTableTable extends AddonToppingsTable
    with TableInfo<$AddonToppingsTableTable, AddonToppingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AddonToppingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isAvailableMeta = const VerificationMeta(
    'isAvailable',
  );
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
    'is_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_available" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _stockQtyMeta = const VerificationMeta(
    'stockQty',
  );
  @override
  late final GeneratedColumn<int> stockQty = GeneratedColumn<int>(
    'stock_qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lowStockThresholdMeta = const VerificationMeta(
    'lowStockThreshold',
  );
  @override
  late final GeneratedColumn<int> lowStockThreshold = GeneratedColumn<int>(
    'low_stock_threshold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    name,
    nameEn,
    price,
    isAvailable,
    stockQty,
    lowStockThreshold,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'addon_toppings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AddonToppingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('is_available')) {
      context.handle(
        _isAvailableMeta,
        isAvailable.isAcceptableOrUnknown(
          data['is_available']!,
          _isAvailableMeta,
        ),
      );
    }
    if (data.containsKey('stock_qty')) {
      context.handle(
        _stockQtyMeta,
        stockQty.isAcceptableOrUnknown(data['stock_qty']!, _stockQtyMeta),
      );
    }
    if (data.containsKey('low_stock_threshold')) {
      context.handle(
        _lowStockThresholdMeta,
        lowStockThreshold.isAcceptableOrUnknown(
          data['low_stock_threshold']!,
          _lowStockThresholdMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AddonToppingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AddonToppingsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price'],
      )!,
      isAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_available'],
      )!,
      stockQty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_qty'],
      )!,
      lowStockThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}low_stock_threshold'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $AddonToppingsTableTable createAlias(String alias) {
    return $AddonToppingsTableTable(attachedDatabase, alias);
  }
}

class AddonToppingsTableData extends DataClass
    implements Insertable<AddonToppingsTableData> {
  final String id;
  final String productId;
  final String name;
  final String? nameEn;
  final int price;
  final bool isAvailable;
  final int stockQty;
  final int lowStockThreshold;
  final int sortOrder;
  const AddonToppingsTableData({
    required this.id,
    required this.productId,
    required this.name,
    this.nameEn,
    required this.price,
    required this.isAvailable,
    required this.stockQty,
    required this.lowStockThreshold,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    map['price'] = Variable<int>(price);
    map['is_available'] = Variable<bool>(isAvailable);
    map['stock_qty'] = Variable<int>(stockQty);
    map['low_stock_threshold'] = Variable<int>(lowStockThreshold);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  AddonToppingsTableCompanion toCompanion(bool nullToAbsent) {
    return AddonToppingsTableCompanion(
      id: Value(id),
      productId: Value(productId),
      name: Value(name),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
      price: Value(price),
      isAvailable: Value(isAvailable),
      stockQty: Value(stockQty),
      lowStockThreshold: Value(lowStockThreshold),
      sortOrder: Value(sortOrder),
    );
  }

  factory AddonToppingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AddonToppingsTableData(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      price: serializer.fromJson<int>(json['price']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      stockQty: serializer.fromJson<int>(json['stockQty']),
      lowStockThreshold: serializer.fromJson<int>(json['lowStockThreshold']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'name': serializer.toJson<String>(name),
      'nameEn': serializer.toJson<String?>(nameEn),
      'price': serializer.toJson<int>(price),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'stockQty': serializer.toJson<int>(stockQty),
      'lowStockThreshold': serializer.toJson<int>(lowStockThreshold),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  AddonToppingsTableData copyWith({
    String? id,
    String? productId,
    String? name,
    Value<String?> nameEn = const Value.absent(),
    int? price,
    bool? isAvailable,
    int? stockQty,
    int? lowStockThreshold,
    int? sortOrder,
  }) => AddonToppingsTableData(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    name: name ?? this.name,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
    price: price ?? this.price,
    isAvailable: isAvailable ?? this.isAvailable,
    stockQty: stockQty ?? this.stockQty,
    lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  AddonToppingsTableData copyWithCompanion(AddonToppingsTableCompanion data) {
    return AddonToppingsTableData(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      price: data.price.present ? data.price.value : this.price,
      isAvailable: data.isAvailable.present
          ? data.isAvailable.value
          : this.isAvailable,
      stockQty: data.stockQty.present ? data.stockQty.value : this.stockQty,
      lowStockThreshold: data.lowStockThreshold.present
          ? data.lowStockThreshold.value
          : this.lowStockThreshold,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AddonToppingsTableData(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('price: $price, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('stockQty: $stockQty, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    name,
    nameEn,
    price,
    isAvailable,
    stockQty,
    lowStockThreshold,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AddonToppingsTableData &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.nameEn == this.nameEn &&
          other.price == this.price &&
          other.isAvailable == this.isAvailable &&
          other.stockQty == this.stockQty &&
          other.lowStockThreshold == this.lowStockThreshold &&
          other.sortOrder == this.sortOrder);
}

class AddonToppingsTableCompanion
    extends UpdateCompanion<AddonToppingsTableData> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> name;
  final Value<String?> nameEn;
  final Value<int> price;
  final Value<bool> isAvailable;
  final Value<int> stockQty;
  final Value<int> lowStockThreshold;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const AddonToppingsTableCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.price = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AddonToppingsTableCompanion.insert({
    required String id,
    required String productId,
    required String name,
    this.nameEn = const Value.absent(),
    this.price = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       name = Value(name);
  static Insertable<AddonToppingsTableData> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? name,
    Expression<String>? nameEn,
    Expression<int>? price,
    Expression<bool>? isAvailable,
    Expression<int>? stockQty,
    Expression<int>? lowStockThreshold,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (nameEn != null) 'name_en': nameEn,
      if (price != null) 'price': price,
      if (isAvailable != null) 'is_available': isAvailable,
      if (stockQty != null) 'stock_qty': stockQty,
      if (lowStockThreshold != null) 'low_stock_threshold': lowStockThreshold,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AddonToppingsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? name,
    Value<String?>? nameEn,
    Value<int>? price,
    Value<bool>? isAvailable,
    Value<int>? stockQty,
    Value<int>? lowStockThreshold,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return AddonToppingsTableCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
      stockQty: stockQty ?? this.stockQty,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (stockQty.present) {
      map['stock_qty'] = Variable<int>(stockQty.value);
    }
    if (lowStockThreshold.present) {
      map['low_stock_threshold'] = Variable<int>(lowStockThreshold.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AddonToppingsTableCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('price: $price, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('stockQty: $stockQty, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrdersTableTable extends OrdersTable
    with TableInfo<$OrdersTableTable, OrdersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderNumberMeta = const VerificationMeta(
    'orderNumber',
  );
  @override
  late final GeneratedColumn<String> orderNumber = GeneratedColumn<String>(
    'order_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderTypeMeta = const VerificationMeta(
    'orderType',
  );
  @override
  late final GeneratedColumn<String> orderType = GeneratedColumn<String>(
    'order_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tableNumberMeta = const VerificationMeta(
    'tableNumber',
  );
  @override
  late final GeneratedColumn<int> tableNumber = GeneratedColumn<int>(
    'table_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<int> subtotal = GeneratedColumn<int>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxAmountMeta = const VerificationMeta(
    'taxAmount',
  );
  @override
  late final GeneratedColumn<int> taxAmount = GeneratedColumn<int>(
    'tax_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grandTotalMeta = const VerificationMeta(
    'grandTotal',
  );
  @override
  late final GeneratedColumn<int> grandTotal = GeneratedColumn<int>(
    'grand_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('CASH'),
  );
  static const VerificationMeta _paymentStatusMeta = const VerificationMeta(
    'paymentStatus',
  );
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
    'payment_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PAID'),
  );
  static const VerificationMeta _cashReceivedMeta = const VerificationMeta(
    'cashReceived',
  );
  @override
  late final GeneratedColumn<int> cashReceived = GeneratedColumn<int>(
    'cash_received',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cashChangeMeta = const VerificationMeta(
    'cashChange',
  );
  @override
  late final GeneratedColumn<int> cashChange = GeneratedColumn<int>(
    'cash_change',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('COMPLETED'),
  );
  static const VerificationMeta _cashierIdMeta = const VerificationMeta(
    'cashierId',
  );
  @override
  late final GeneratedColumn<String> cashierId = GeneratedColumn<String>(
    'cashier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderNumber,
    orderType,
    tableNumber,
    subtotal,
    taxAmount,
    grandTotal,
    paymentMethod,
    paymentStatus,
    cashReceived,
    cashChange,
    status,
    cashierId,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrdersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('order_number')) {
      context.handle(
        _orderNumberMeta,
        orderNumber.isAcceptableOrUnknown(
          data['order_number']!,
          _orderNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_orderNumberMeta);
    }
    if (data.containsKey('order_type')) {
      context.handle(
        _orderTypeMeta,
        orderType.isAcceptableOrUnknown(data['order_type']!, _orderTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_orderTypeMeta);
    }
    if (data.containsKey('table_number')) {
      context.handle(
        _tableNumberMeta,
        tableNumber.isAcceptableOrUnknown(
          data['table_number']!,
          _tableNumberMeta,
        ),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('tax_amount')) {
      context.handle(
        _taxAmountMeta,
        taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_taxAmountMeta);
    }
    if (data.containsKey('grand_total')) {
      context.handle(
        _grandTotalMeta,
        grandTotal.isAcceptableOrUnknown(data['grand_total']!, _grandTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_grandTotalMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('payment_status')) {
      context.handle(
        _paymentStatusMeta,
        paymentStatus.isAcceptableOrUnknown(
          data['payment_status']!,
          _paymentStatusMeta,
        ),
      );
    }
    if (data.containsKey('cash_received')) {
      context.handle(
        _cashReceivedMeta,
        cashReceived.isAcceptableOrUnknown(
          data['cash_received']!,
          _cashReceivedMeta,
        ),
      );
    }
    if (data.containsKey('cash_change')) {
      context.handle(
        _cashChangeMeta,
        cashChange.isAcceptableOrUnknown(data['cash_change']!, _cashChangeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('cashier_id')) {
      context.handle(
        _cashierIdMeta,
        cashierId.isAcceptableOrUnknown(data['cashier_id']!, _cashierIdMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrdersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orderNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_number'],
      )!,
      orderType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_type'],
      )!,
      tableNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}table_number'],
      ),
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal'],
      )!,
      taxAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_amount'],
      )!,
      grandTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grand_total'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      paymentStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_status'],
      )!,
      cashReceived: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cash_received'],
      ),
      cashChange: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cash_change'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      cashierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cashier_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OrdersTableTable createAlias(String alias) {
    return $OrdersTableTable(attachedDatabase, alias);
  }
}

class OrdersTableData extends DataClass implements Insertable<OrdersTableData> {
  final String id;
  final String orderNumber;
  final String orderType;
  final int? tableNumber;
  final int subtotal;
  final int taxAmount;
  final int grandTotal;
  final String paymentMethod;
  final String paymentStatus;
  final int? cashReceived;
  final int? cashChange;
  final String status;
  final String? cashierId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const OrdersTableData({
    required this.id,
    required this.orderNumber,
    required this.orderType,
    this.tableNumber,
    required this.subtotal,
    required this.taxAmount,
    required this.grandTotal,
    required this.paymentMethod,
    required this.paymentStatus,
    this.cashReceived,
    this.cashChange,
    required this.status,
    this.cashierId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_number'] = Variable<String>(orderNumber);
    map['order_type'] = Variable<String>(orderType);
    if (!nullToAbsent || tableNumber != null) {
      map['table_number'] = Variable<int>(tableNumber);
    }
    map['subtotal'] = Variable<int>(subtotal);
    map['tax_amount'] = Variable<int>(taxAmount);
    map['grand_total'] = Variable<int>(grandTotal);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['payment_status'] = Variable<String>(paymentStatus);
    if (!nullToAbsent || cashReceived != null) {
      map['cash_received'] = Variable<int>(cashReceived);
    }
    if (!nullToAbsent || cashChange != null) {
      map['cash_change'] = Variable<int>(cashChange);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || cashierId != null) {
      map['cashier_id'] = Variable<String>(cashierId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OrdersTableCompanion toCompanion(bool nullToAbsent) {
    return OrdersTableCompanion(
      id: Value(id),
      orderNumber: Value(orderNumber),
      orderType: Value(orderType),
      tableNumber: tableNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(tableNumber),
      subtotal: Value(subtotal),
      taxAmount: Value(taxAmount),
      grandTotal: Value(grandTotal),
      paymentMethod: Value(paymentMethod),
      paymentStatus: Value(paymentStatus),
      cashReceived: cashReceived == null && nullToAbsent
          ? const Value.absent()
          : Value(cashReceived),
      cashChange: cashChange == null && nullToAbsent
          ? const Value.absent()
          : Value(cashChange),
      status: Value(status),
      cashierId: cashierId == null && nullToAbsent
          ? const Value.absent()
          : Value(cashierId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory OrdersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdersTableData(
      id: serializer.fromJson<String>(json['id']),
      orderNumber: serializer.fromJson<String>(json['orderNumber']),
      orderType: serializer.fromJson<String>(json['orderType']),
      tableNumber: serializer.fromJson<int?>(json['tableNumber']),
      subtotal: serializer.fromJson<int>(json['subtotal']),
      taxAmount: serializer.fromJson<int>(json['taxAmount']),
      grandTotal: serializer.fromJson<int>(json['grandTotal']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      cashReceived: serializer.fromJson<int?>(json['cashReceived']),
      cashChange: serializer.fromJson<int?>(json['cashChange']),
      status: serializer.fromJson<String>(json['status']),
      cashierId: serializer.fromJson<String?>(json['cashierId']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderNumber': serializer.toJson<String>(orderNumber),
      'orderType': serializer.toJson<String>(orderType),
      'tableNumber': serializer.toJson<int?>(tableNumber),
      'subtotal': serializer.toJson<int>(subtotal),
      'taxAmount': serializer.toJson<int>(taxAmount),
      'grandTotal': serializer.toJson<int>(grandTotal),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'cashReceived': serializer.toJson<int?>(cashReceived),
      'cashChange': serializer.toJson<int?>(cashChange),
      'status': serializer.toJson<String>(status),
      'cashierId': serializer.toJson<String?>(cashierId),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OrdersTableData copyWith({
    String? id,
    String? orderNumber,
    String? orderType,
    Value<int?> tableNumber = const Value.absent(),
    int? subtotal,
    int? taxAmount,
    int? grandTotal,
    String? paymentMethod,
    String? paymentStatus,
    Value<int?> cashReceived = const Value.absent(),
    Value<int?> cashChange = const Value.absent(),
    String? status,
    Value<String?> cashierId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => OrdersTableData(
    id: id ?? this.id,
    orderNumber: orderNumber ?? this.orderNumber,
    orderType: orderType ?? this.orderType,
    tableNumber: tableNumber.present ? tableNumber.value : this.tableNumber,
    subtotal: subtotal ?? this.subtotal,
    taxAmount: taxAmount ?? this.taxAmount,
    grandTotal: grandTotal ?? this.grandTotal,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    cashReceived: cashReceived.present ? cashReceived.value : this.cashReceived,
    cashChange: cashChange.present ? cashChange.value : this.cashChange,
    status: status ?? this.status,
    cashierId: cashierId.present ? cashierId.value : this.cashierId,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  OrdersTableData copyWithCompanion(OrdersTableCompanion data) {
    return OrdersTableData(
      id: data.id.present ? data.id.value : this.id,
      orderNumber: data.orderNumber.present
          ? data.orderNumber.value
          : this.orderNumber,
      orderType: data.orderType.present ? data.orderType.value : this.orderType,
      tableNumber: data.tableNumber.present
          ? data.tableNumber.value
          : this.tableNumber,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      grandTotal: data.grandTotal.present
          ? data.grandTotal.value
          : this.grandTotal,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      cashReceived: data.cashReceived.present
          ? data.cashReceived.value
          : this.cashReceived,
      cashChange: data.cashChange.present
          ? data.cashChange.value
          : this.cashChange,
      status: data.status.present ? data.status.value : this.status,
      cashierId: data.cashierId.present ? data.cashierId.value : this.cashierId,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdersTableData(')
          ..write('id: $id, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('orderType: $orderType, ')
          ..write('tableNumber: $tableNumber, ')
          ..write('subtotal: $subtotal, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('cashReceived: $cashReceived, ')
          ..write('cashChange: $cashChange, ')
          ..write('status: $status, ')
          ..write('cashierId: $cashierId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderNumber,
    orderType,
    tableNumber,
    subtotal,
    taxAmount,
    grandTotal,
    paymentMethod,
    paymentStatus,
    cashReceived,
    cashChange,
    status,
    cashierId,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdersTableData &&
          other.id == this.id &&
          other.orderNumber == this.orderNumber &&
          other.orderType == this.orderType &&
          other.tableNumber == this.tableNumber &&
          other.subtotal == this.subtotal &&
          other.taxAmount == this.taxAmount &&
          other.grandTotal == this.grandTotal &&
          other.paymentMethod == this.paymentMethod &&
          other.paymentStatus == this.paymentStatus &&
          other.cashReceived == this.cashReceived &&
          other.cashChange == this.cashChange &&
          other.status == this.status &&
          other.cashierId == this.cashierId &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OrdersTableCompanion extends UpdateCompanion<OrdersTableData> {
  final Value<String> id;
  final Value<String> orderNumber;
  final Value<String> orderType;
  final Value<int?> tableNumber;
  final Value<int> subtotal;
  final Value<int> taxAmount;
  final Value<int> grandTotal;
  final Value<String> paymentMethod;
  final Value<String> paymentStatus;
  final Value<int?> cashReceived;
  final Value<int?> cashChange;
  final Value<String> status;
  final Value<String?> cashierId;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const OrdersTableCompanion({
    this.id = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.orderType = const Value.absent(),
    this.tableNumber = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.cashReceived = const Value.absent(),
    this.cashChange = const Value.absent(),
    this.status = const Value.absent(),
    this.cashierId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersTableCompanion.insert({
    required String id,
    required String orderNumber,
    required String orderType,
    this.tableNumber = const Value.absent(),
    required int subtotal,
    required int taxAmount,
    required int grandTotal,
    this.paymentMethod = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.cashReceived = const Value.absent(),
    this.cashChange = const Value.absent(),
    this.status = const Value.absent(),
    this.cashierId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orderNumber = Value(orderNumber),
       orderType = Value(orderType),
       subtotal = Value(subtotal),
       taxAmount = Value(taxAmount),
       grandTotal = Value(grandTotal);
  static Insertable<OrdersTableData> custom({
    Expression<String>? id,
    Expression<String>? orderNumber,
    Expression<String>? orderType,
    Expression<int>? tableNumber,
    Expression<int>? subtotal,
    Expression<int>? taxAmount,
    Expression<int>? grandTotal,
    Expression<String>? paymentMethod,
    Expression<String>? paymentStatus,
    Expression<int>? cashReceived,
    Expression<int>? cashChange,
    Expression<String>? status,
    Expression<String>? cashierId,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderNumber != null) 'order_number': orderNumber,
      if (orderType != null) 'order_type': orderType,
      if (tableNumber != null) 'table_number': tableNumber,
      if (subtotal != null) 'subtotal': subtotal,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (grandTotal != null) 'grand_total': grandTotal,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (cashReceived != null) 'cash_received': cashReceived,
      if (cashChange != null) 'cash_change': cashChange,
      if (status != null) 'status': status,
      if (cashierId != null) 'cashier_id': cashierId,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? orderNumber,
    Value<String>? orderType,
    Value<int?>? tableNumber,
    Value<int>? subtotal,
    Value<int>? taxAmount,
    Value<int>? grandTotal,
    Value<String>? paymentMethod,
    Value<String>? paymentStatus,
    Value<int?>? cashReceived,
    Value<int?>? cashChange,
    Value<String>? status,
    Value<String?>? cashierId,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return OrdersTableCompanion(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      orderType: orderType ?? this.orderType,
      tableNumber: tableNumber ?? this.tableNumber,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      cashReceived: cashReceived ?? this.cashReceived,
      cashChange: cashChange ?? this.cashChange,
      status: status ?? this.status,
      cashierId: cashierId ?? this.cashierId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orderNumber.present) {
      map['order_number'] = Variable<String>(orderNumber.value);
    }
    if (orderType.present) {
      map['order_type'] = Variable<String>(orderType.value);
    }
    if (tableNumber.present) {
      map['table_number'] = Variable<int>(tableNumber.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<int>(subtotal.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<int>(taxAmount.value);
    }
    if (grandTotal.present) {
      map['grand_total'] = Variable<int>(grandTotal.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (cashReceived.present) {
      map['cash_received'] = Variable<int>(cashReceived.value);
    }
    if (cashChange.present) {
      map['cash_change'] = Variable<int>(cashChange.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (cashierId.present) {
      map['cashier_id'] = Variable<String>(cashierId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersTableCompanion(')
          ..write('id: $id, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('orderType: $orderType, ')
          ..write('tableNumber: $tableNumber, ')
          ..write('subtotal: $subtotal, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('cashReceived: $cashReceived, ')
          ..write('cashChange: $cashChange, ')
          ..write('status: $status, ')
          ..write('cashierId: $cashierId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTableTable extends OrderItemsTable
    with TableInfo<$OrderItemsTableTable, OrderItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _basePriceMeta = const VerificationMeta(
    'basePrice',
  );
  @override
  late final GeneratedColumn<int> basePrice = GeneratedColumn<int>(
    'base_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toppingTotalMeta = const VerificationMeta(
    'toppingTotal',
  );
  @override
  late final GeneratedColumn<int> toppingTotal = GeneratedColumn<int>(
    'topping_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lineTotalMeta = const VerificationMeta(
    'lineTotal',
  );
  @override
  late final GeneratedColumn<int> lineTotal = GeneratedColumn<int>(
    'line_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
  removedIngredients =
      GeneratedColumn<String>(
        'removed_ingredients',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<String>?>(
        $OrderItemsTableTable.$converterremovedIngredientsn,
      );
  @override
  late final GeneratedColumnWithTypeConverter<
    List<Map<String, dynamic>>?,
    String
  >
  addedToppings =
      GeneratedColumn<String>(
        'added_toppings',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<Map<String, dynamic>>?>(
        $OrderItemsTableTable.$converteraddedToppingsn,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    productId,
    productName,
    quantity,
    basePrice,
    toppingTotal,
    lineTotal,
    removedIngredients,
    addedToppings,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('base_price')) {
      context.handle(
        _basePriceMeta,
        basePrice.isAcceptableOrUnknown(data['base_price']!, _basePriceMeta),
      );
    } else if (isInserting) {
      context.missing(_basePriceMeta);
    }
    if (data.containsKey('topping_total')) {
      context.handle(
        _toppingTotalMeta,
        toppingTotal.isAcceptableOrUnknown(
          data['topping_total']!,
          _toppingTotalMeta,
        ),
      );
    }
    if (data.containsKey('line_total')) {
      context.handle(
        _lineTotalMeta,
        lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItemsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      basePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_price'],
      )!,
      toppingTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}topping_total'],
      )!,
      lineTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_total'],
      )!,
      removedIngredients: $OrderItemsTableTable.$converterremovedIngredientsn
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}removed_ingredients'],
            ),
          ),
      addedToppings: $OrderItemsTableTable.$converteraddedToppingsn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}added_toppings'],
        ),
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OrderItemsTableTable createAlias(String alias) {
    return $OrderItemsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterremovedIngredients =
      const StringListConverter();
  static TypeConverter<List<String>?, String?> $converterremovedIngredientsn =
      NullAwareTypeConverter.wrap($converterremovedIngredients);
  static TypeConverter<List<Map<String, dynamic>>, String>
  $converteraddedToppings = const MapListConverter();
  static TypeConverter<List<Map<String, dynamic>>?, String?>
  $converteraddedToppingsn = NullAwareTypeConverter.wrap(
    $converteraddedToppings,
  );
}

class OrderItemsTableData extends DataClass
    implements Insertable<OrderItemsTableData> {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final int quantity;
  final int basePrice;
  final int toppingTotal;
  final int lineTotal;
  final List<String>? removedIngredients;
  final List<Map<String, dynamic>>? addedToppings;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const OrderItemsTableData({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.basePrice,
    required this.toppingTotal,
    required this.lineTotal,
    this.removedIngredients,
    this.addedToppings,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_id'] = Variable<String>(orderId);
    map['product_id'] = Variable<String>(productId);
    map['product_name'] = Variable<String>(productName);
    map['quantity'] = Variable<int>(quantity);
    map['base_price'] = Variable<int>(basePrice);
    map['topping_total'] = Variable<int>(toppingTotal);
    map['line_total'] = Variable<int>(lineTotal);
    if (!nullToAbsent || removedIngredients != null) {
      map['removed_ingredients'] = Variable<String>(
        $OrderItemsTableTable.$converterremovedIngredientsn.toSql(
          removedIngredients,
        ),
      );
    }
    if (!nullToAbsent || addedToppings != null) {
      map['added_toppings'] = Variable<String>(
        $OrderItemsTableTable.$converteraddedToppingsn.toSql(addedToppings),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OrderItemsTableCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsTableCompanion(
      id: Value(id),
      orderId: Value(orderId),
      productId: Value(productId),
      productName: Value(productName),
      quantity: Value(quantity),
      basePrice: Value(basePrice),
      toppingTotal: Value(toppingTotal),
      lineTotal: Value(lineTotal),
      removedIngredients: removedIngredients == null && nullToAbsent
          ? const Value.absent()
          : Value(removedIngredients),
      addedToppings: addedToppings == null && nullToAbsent
          ? const Value.absent()
          : Value(addedToppings),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory OrderItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      productId: serializer.fromJson<String>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      quantity: serializer.fromJson<int>(json['quantity']),
      basePrice: serializer.fromJson<int>(json['basePrice']),
      toppingTotal: serializer.fromJson<int>(json['toppingTotal']),
      lineTotal: serializer.fromJson<int>(json['lineTotal']),
      removedIngredients: serializer.fromJson<List<String>?>(
        json['removedIngredients'],
      ),
      addedToppings: serializer.fromJson<List<Map<String, dynamic>>?>(
        json['addedToppings'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderId': serializer.toJson<String>(orderId),
      'productId': serializer.toJson<String>(productId),
      'productName': serializer.toJson<String>(productName),
      'quantity': serializer.toJson<int>(quantity),
      'basePrice': serializer.toJson<int>(basePrice),
      'toppingTotal': serializer.toJson<int>(toppingTotal),
      'lineTotal': serializer.toJson<int>(lineTotal),
      'removedIngredients': serializer.toJson<List<String>?>(
        removedIngredients,
      ),
      'addedToppings': serializer.toJson<List<Map<String, dynamic>>?>(
        addedToppings,
      ),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OrderItemsTableData copyWith({
    String? id,
    String? orderId,
    String? productId,
    String? productName,
    int? quantity,
    int? basePrice,
    int? toppingTotal,
    int? lineTotal,
    Value<List<String>?> removedIngredients = const Value.absent(),
    Value<List<Map<String, dynamic>>?> addedToppings = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => OrderItemsTableData(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    quantity: quantity ?? this.quantity,
    basePrice: basePrice ?? this.basePrice,
    toppingTotal: toppingTotal ?? this.toppingTotal,
    lineTotal: lineTotal ?? this.lineTotal,
    removedIngredients: removedIngredients.present
        ? removedIngredients.value
        : this.removedIngredients,
    addedToppings: addedToppings.present
        ? addedToppings.value
        : this.addedToppings,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  OrderItemsTableData copyWithCompanion(OrderItemsTableCompanion data) {
    return OrderItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      basePrice: data.basePrice.present ? data.basePrice.value : this.basePrice,
      toppingTotal: data.toppingTotal.present
          ? data.toppingTotal.value
          : this.toppingTotal,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
      removedIngredients: data.removedIngredients.present
          ? data.removedIngredients.value
          : this.removedIngredients,
      addedToppings: data.addedToppings.present
          ? data.addedToppings.value
          : this.addedToppings,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsTableData(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('basePrice: $basePrice, ')
          ..write('toppingTotal: $toppingTotal, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('removedIngredients: $removedIngredients, ')
          ..write('addedToppings: $addedToppings, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderId,
    productId,
    productName,
    quantity,
    basePrice,
    toppingTotal,
    lineTotal,
    removedIngredients,
    addedToppings,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItemsTableData &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.quantity == this.quantity &&
          other.basePrice == this.basePrice &&
          other.toppingTotal == this.toppingTotal &&
          other.lineTotal == this.lineTotal &&
          other.removedIngredients == this.removedIngredients &&
          other.addedToppings == this.addedToppings &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OrderItemsTableCompanion extends UpdateCompanion<OrderItemsTableData> {
  final Value<String> id;
  final Value<String> orderId;
  final Value<String> productId;
  final Value<String> productName;
  final Value<int> quantity;
  final Value<int> basePrice;
  final Value<int> toppingTotal;
  final Value<int> lineTotal;
  final Value<List<String>?> removedIngredients;
  final Value<List<Map<String, dynamic>>?> addedToppings;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const OrderItemsTableCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.basePrice = const Value.absent(),
    this.toppingTotal = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.removedIngredients = const Value.absent(),
    this.addedToppings = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderItemsTableCompanion.insert({
    required String id,
    required String orderId,
    required String productId,
    required String productName,
    required int quantity,
    required int basePrice,
    this.toppingTotal = const Value.absent(),
    required int lineTotal,
    this.removedIngredients = const Value.absent(),
    this.addedToppings = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orderId = Value(orderId),
       productId = Value(productId),
       productName = Value(productName),
       quantity = Value(quantity),
       basePrice = Value(basePrice),
       lineTotal = Value(lineTotal);
  static Insertable<OrderItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? orderId,
    Expression<String>? productId,
    Expression<String>? productName,
    Expression<int>? quantity,
    Expression<int>? basePrice,
    Expression<int>? toppingTotal,
    Expression<int>? lineTotal,
    Expression<String>? removedIngredients,
    Expression<String>? addedToppings,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (quantity != null) 'quantity': quantity,
      if (basePrice != null) 'base_price': basePrice,
      if (toppingTotal != null) 'topping_total': toppingTotal,
      if (lineTotal != null) 'line_total': lineTotal,
      if (removedIngredients != null) 'removed_ingredients': removedIngredients,
      if (addedToppings != null) 'added_toppings': addedToppings,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderItemsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? orderId,
    Value<String>? productId,
    Value<String>? productName,
    Value<int>? quantity,
    Value<int>? basePrice,
    Value<int>? toppingTotal,
    Value<int>? lineTotal,
    Value<List<String>?>? removedIngredients,
    Value<List<Map<String, dynamic>>?>? addedToppings,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return OrderItemsTableCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      basePrice: basePrice ?? this.basePrice,
      toppingTotal: toppingTotal ?? this.toppingTotal,
      lineTotal: lineTotal ?? this.lineTotal,
      removedIngredients: removedIngredients ?? this.removedIngredients,
      addedToppings: addedToppings ?? this.addedToppings,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (basePrice.present) {
      map['base_price'] = Variable<int>(basePrice.value);
    }
    if (toppingTotal.present) {
      map['topping_total'] = Variable<int>(toppingTotal.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<int>(lineTotal.value);
    }
    if (removedIngredients.present) {
      map['removed_ingredients'] = Variable<String>(
        $OrderItemsTableTable.$converterremovedIngredientsn.toSql(
          removedIngredients.value,
        ),
      );
    }
    if (addedToppings.present) {
      map['added_toppings'] = Variable<String>(
        $OrderItemsTableTable.$converteraddedToppingsn.toSql(
          addedToppings.value,
        ),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('basePrice: $basePrice, ')
          ..write('toppingTotal: $toppingTotal, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('removedIngredients: $removedIngredients, ')
          ..write('addedToppings: $addedToppings, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockHistoryTableTable extends StockHistoryTable
    with TableInfo<$StockHistoryTableTable, StockHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PRODUCT'),
  );
  static const VerificationMeta _previousQtyMeta = const VerificationMeta(
    'previousQty',
  );
  @override
  late final GeneratedColumn<int> previousQty = GeneratedColumn<int>(
    'previous_qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newQtyMeta = const VerificationMeta('newQty');
  @override
  late final GeneratedColumn<int> newQty = GeneratedColumn<int>(
    'new_qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changeTypeMeta = const VerificationMeta(
    'changeType',
  );
  @override
  late final GeneratedColumn<String> changeType = GeneratedColumn<String>(
    'change_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changeAmountMeta = const VerificationMeta(
    'changeAmount',
  );
  @override
  late final GeneratedColumn<int> changeAmount = GeneratedColumn<int>(
    'change_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    itemType,
    previousQty,
    newQty,
    changeType,
    changeAmount,
    notes,
    userId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('item_type')) {
      context.handle(
        _itemTypeMeta,
        itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta),
      );
    }
    if (data.containsKey('previous_qty')) {
      context.handle(
        _previousQtyMeta,
        previousQty.isAcceptableOrUnknown(
          data['previous_qty']!,
          _previousQtyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_previousQtyMeta);
    }
    if (data.containsKey('new_qty')) {
      context.handle(
        _newQtyMeta,
        newQty.isAcceptableOrUnknown(data['new_qty']!, _newQtyMeta),
      );
    } else if (isInserting) {
      context.missing(_newQtyMeta);
    }
    if (data.containsKey('change_type')) {
      context.handle(
        _changeTypeMeta,
        changeType.isAcceptableOrUnknown(data['change_type']!, _changeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_changeTypeMeta);
    }
    if (data.containsKey('change_amount')) {
      context.handle(
        _changeAmountMeta,
        changeAmount.isAcceptableOrUnknown(
          data['change_amount']!,
          _changeAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_changeAmountMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      itemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_type'],
      )!,
      previousQty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}previous_qty'],
      )!,
      newQty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}new_qty'],
      )!,
      changeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}change_type'],
      )!,
      changeAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}change_amount'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StockHistoryTableTable createAlias(String alias) {
    return $StockHistoryTableTable(attachedDatabase, alias);
  }
}

class StockHistoryData extends DataClass
    implements Insertable<StockHistoryData> {
  final String id;
  final String productId;
  final String itemType;
  final int previousQty;
  final int newQty;
  final String changeType;
  final int changeAmount;
  final String? notes;
  final String? userId;
  final DateTime createdAt;
  const StockHistoryData({
    required this.id,
    required this.productId,
    required this.itemType,
    required this.previousQty,
    required this.newQty,
    required this.changeType,
    required this.changeAmount,
    this.notes,
    this.userId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['item_type'] = Variable<String>(itemType);
    map['previous_qty'] = Variable<int>(previousQty);
    map['new_qty'] = Variable<int>(newQty);
    map['change_type'] = Variable<String>(changeType);
    map['change_amount'] = Variable<int>(changeAmount);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StockHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return StockHistoryTableCompanion(
      id: Value(id),
      productId: Value(productId),
      itemType: Value(itemType),
      previousQty: Value(previousQty),
      newQty: Value(newQty),
      changeType: Value(changeType),
      changeAmount: Value(changeAmount),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      createdAt: Value(createdAt),
    );
  }

  factory StockHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockHistoryData(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      itemType: serializer.fromJson<String>(json['itemType']),
      previousQty: serializer.fromJson<int>(json['previousQty']),
      newQty: serializer.fromJson<int>(json['newQty']),
      changeType: serializer.fromJson<String>(json['changeType']),
      changeAmount: serializer.fromJson<int>(json['changeAmount']),
      notes: serializer.fromJson<String?>(json['notes']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'itemType': serializer.toJson<String>(itemType),
      'previousQty': serializer.toJson<int>(previousQty),
      'newQty': serializer.toJson<int>(newQty),
      'changeType': serializer.toJson<String>(changeType),
      'changeAmount': serializer.toJson<int>(changeAmount),
      'notes': serializer.toJson<String?>(notes),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StockHistoryData copyWith({
    String? id,
    String? productId,
    String? itemType,
    int? previousQty,
    int? newQty,
    String? changeType,
    int? changeAmount,
    Value<String?> notes = const Value.absent(),
    Value<String?> userId = const Value.absent(),
    DateTime? createdAt,
  }) => StockHistoryData(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    itemType: itemType ?? this.itemType,
    previousQty: previousQty ?? this.previousQty,
    newQty: newQty ?? this.newQty,
    changeType: changeType ?? this.changeType,
    changeAmount: changeAmount ?? this.changeAmount,
    notes: notes.present ? notes.value : this.notes,
    userId: userId.present ? userId.value : this.userId,
    createdAt: createdAt ?? this.createdAt,
  );
  StockHistoryData copyWithCompanion(StockHistoryTableCompanion data) {
    return StockHistoryData(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      previousQty: data.previousQty.present
          ? data.previousQty.value
          : this.previousQty,
      newQty: data.newQty.present ? data.newQty.value : this.newQty,
      changeType: data.changeType.present
          ? data.changeType.value
          : this.changeType,
      changeAmount: data.changeAmount.present
          ? data.changeAmount.value
          : this.changeAmount,
      notes: data.notes.present ? data.notes.value : this.notes,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockHistoryData(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('itemType: $itemType, ')
          ..write('previousQty: $previousQty, ')
          ..write('newQty: $newQty, ')
          ..write('changeType: $changeType, ')
          ..write('changeAmount: $changeAmount, ')
          ..write('notes: $notes, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    itemType,
    previousQty,
    newQty,
    changeType,
    changeAmount,
    notes,
    userId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockHistoryData &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.itemType == this.itemType &&
          other.previousQty == this.previousQty &&
          other.newQty == this.newQty &&
          other.changeType == this.changeType &&
          other.changeAmount == this.changeAmount &&
          other.notes == this.notes &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt);
}

class StockHistoryTableCompanion extends UpdateCompanion<StockHistoryData> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> itemType;
  final Value<int> previousQty;
  final Value<int> newQty;
  final Value<String> changeType;
  final Value<int> changeAmount;
  final Value<String?> notes;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StockHistoryTableCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.itemType = const Value.absent(),
    this.previousQty = const Value.absent(),
    this.newQty = const Value.absent(),
    this.changeType = const Value.absent(),
    this.changeAmount = const Value.absent(),
    this.notes = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockHistoryTableCompanion.insert({
    required String id,
    required String productId,
    this.itemType = const Value.absent(),
    required int previousQty,
    required int newQty,
    required String changeType,
    required int changeAmount,
    this.notes = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       previousQty = Value(previousQty),
       newQty = Value(newQty),
       changeType = Value(changeType),
       changeAmount = Value(changeAmount);
  static Insertable<StockHistoryData> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? itemType,
    Expression<int>? previousQty,
    Expression<int>? newQty,
    Expression<String>? changeType,
    Expression<int>? changeAmount,
    Expression<String>? notes,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (itemType != null) 'item_type': itemType,
      if (previousQty != null) 'previous_qty': previousQty,
      if (newQty != null) 'new_qty': newQty,
      if (changeType != null) 'change_type': changeType,
      if (changeAmount != null) 'change_amount': changeAmount,
      if (notes != null) 'notes': notes,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockHistoryTableCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? itemType,
    Value<int>? previousQty,
    Value<int>? newQty,
    Value<String>? changeType,
    Value<int>? changeAmount,
    Value<String?>? notes,
    Value<String?>? userId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StockHistoryTableCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      itemType: itemType ?? this.itemType,
      previousQty: previousQty ?? this.previousQty,
      newQty: newQty ?? this.newQty,
      changeType: changeType ?? this.changeType,
      changeAmount: changeAmount ?? this.changeAmount,
      notes: notes ?? this.notes,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (previousQty.present) {
      map['previous_qty'] = Variable<int>(previousQty.value);
    }
    if (newQty.present) {
      map['new_qty'] = Variable<int>(newQty.value);
    }
    if (changeType.present) {
      map['change_type'] = Variable<String>(changeType.value);
    }
    if (changeAmount.present) {
      map['change_amount'] = Variable<int>(changeAmount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('itemType: $itemType, ')
          ..write('previousQty: $previousQty, ')
          ..write('newQty: $newQty, ')
          ..write('changeType: $changeType, ')
          ..write('changeAmount: $changeAmount, ')
          ..write('notes: $notes, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTableTable extends SyncQueueTable
    with TableInfo<$SyncQueueTableTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tableName_Meta = const VerificationMeta(
    'tableName_',
  );
  @override
  late final GeneratedColumn<String> tableName_ = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING'),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tableName_,
    recordId,
    operation,
    payload,
    createdAt,
    status,
    retryCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table_name')) {
      context.handle(
        _tableName_Meta,
        tableName_.isAcceptableOrUnknown(data['table_name']!, _tableName_Meta),
      );
    } else if (isInserting) {
      context.missing(_tableName_Meta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tableName_: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
    );
  }

  @override
  $SyncQueueTableTable createAlias(String alias) {
    return $SyncQueueTableTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String tableName_;
  final String recordId;
  final String operation;
  final String payload;
  final DateTime createdAt;
  final String status;
  final int retryCount;
  const SyncQueueData({
    required this.id,
    required this.tableName_,
    required this.recordId,
    required this.operation,
    required this.payload,
    required this.createdAt,
    required this.status,
    required this.retryCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['table_name'] = Variable<String>(tableName_);
    map['record_id'] = Variable<String>(recordId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    return map;
  }

  SyncQueueTableCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueTableCompanion(
      id: Value(id),
      tableName_: Value(tableName_),
      recordId: Value(recordId),
      operation: Value(operation),
      payload: Value(payload),
      createdAt: Value(createdAt),
      status: Value(status),
      retryCount: Value(retryCount),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      tableName_: serializer.fromJson<String>(json['tableName_']),
      recordId: serializer.fromJson<String>(json['recordId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tableName_': serializer.toJson<String>(tableName_),
      'recordId': serializer.toJson<String>(recordId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
    };
  }

  SyncQueueData copyWith({
    int? id,
    String? tableName_,
    String? recordId,
    String? operation,
    String? payload,
    DateTime? createdAt,
    String? status,
    int? retryCount,
  }) => SyncQueueData(
    id: id ?? this.id,
    tableName_: tableName_ ?? this.tableName_,
    recordId: recordId ?? this.recordId,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
  );
  SyncQueueData copyWithCompanion(SyncQueueTableCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      tableName_: data.tableName_.present
          ? data.tableName_.value
          : this.tableName_,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('tableName_: $tableName_, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tableName_,
    recordId,
    operation,
    payload,
    createdAt,
    status,
    retryCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.tableName_ == this.tableName_ &&
          other.recordId == this.recordId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.retryCount == this.retryCount);
}

class SyncQueueTableCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> tableName_;
  final Value<String> recordId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<int> retryCount;
  const SyncQueueTableCompanion({
    this.id = const Value.absent(),
    this.tableName_ = const Value.absent(),
    this.recordId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
  });
  SyncQueueTableCompanion.insert({
    this.id = const Value.absent(),
    required String tableName_,
    required String recordId,
    required String operation,
    required String payload,
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
  }) : tableName_ = Value(tableName_),
       recordId = Value(recordId),
       operation = Value(operation),
       payload = Value(payload);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? tableName_,
    Expression<String>? recordId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<int>? retryCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tableName_ != null) 'table_name': tableName_,
      if (recordId != null) 'record_id': recordId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
    });
  }

  SyncQueueTableCompanion copyWith({
    Value<int>? id,
    Value<String>? tableName_,
    Value<String>? recordId,
    Value<String>? operation,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<int>? retryCount,
  }) {
    return SyncQueueTableCompanion(
      id: id ?? this.id,
      tableName_: tableName_ ?? this.tableName_,
      recordId: recordId ?? this.recordId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tableName_.present) {
      map['table_name'] = Variable<String>(tableName_.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableCompanion(')
          ..write('id: $id, ')
          ..write('tableName_: $tableName_, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $ProductsTableTable productsTable = $ProductsTableTable(this);
  late final $DefaultIngredientsTableTable defaultIngredientsTable =
      $DefaultIngredientsTableTable(this);
  late final $AddonToppingsTableTable addonToppingsTable =
      $AddonToppingsTableTable(this);
  late final $OrdersTableTable ordersTable = $OrdersTableTable(this);
  late final $OrderItemsTableTable orderItemsTable = $OrderItemsTableTable(
    this,
  );
  late final $StockHistoryTableTable stockHistoryTable =
      $StockHistoryTableTable(this);
  late final $SyncQueueTableTable syncQueueTable = $SyncQueueTableTable(this);
  late final CatalogDao catalogDao = CatalogDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categoriesTable,
    productsTable,
    defaultIngredientsTable,
    addonToppingsTable,
    ordersTable,
    orderItemsTable,
    stockHistoryTable,
    syncQueueTable,
  ];
}

typedef $$CategoriesTableTableCreateCompanionBuilder =
    CategoriesTableCompanion Function({
      required String id,
      required String name,
      Value<String?> nameEn,
      Value<String?> icon,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$CategoriesTableTableUpdateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> nameEn,
      Value<String?> icon,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData,
          $$CategoriesTableTableFilterComposer,
          $$CategoriesTableTableOrderingComposer,
          $$CategoriesTableTableAnnotationComposer,
          $$CategoriesTableTableCreateCompanionBuilder,
          $$CategoriesTableTableUpdateCompanionBuilder,
          (
            CategoriesTableData,
            BaseReferences<
              _$AppDatabase,
              $CategoriesTableTable,
              CategoriesTableData
            >,
          ),
          CategoriesTableData,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableTableManager(
    _$AppDatabase db,
    $CategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion(
                id: id,
                name: name,
                nameEn: nameEn,
                icon: icon,
                sortOrder: sortOrder,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> nameEn = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion.insert(
                id: id,
                name: name,
                nameEn: nameEn,
                icon: icon,
                sortOrder: sortOrder,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTableTable,
      CategoriesTableData,
      $$CategoriesTableTableFilterComposer,
      $$CategoriesTableTableOrderingComposer,
      $$CategoriesTableTableAnnotationComposer,
      $$CategoriesTableTableCreateCompanionBuilder,
      $$CategoriesTableTableUpdateCompanionBuilder,
      (
        CategoriesTableData,
        BaseReferences<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData
        >,
      ),
      CategoriesTableData,
      PrefetchHooks Function()
    >;
typedef $$ProductsTableTableCreateCompanionBuilder =
    ProductsTableCompanion Function({
      required String id,
      required String name,
      Value<String?> nameEn,
      Value<String?> description,
      required int basePrice,
      Value<String?> categoryId,
      Value<String?> imageUrl,
      Value<bool> isAvailable,
      Value<int> stockQty,
      Value<int> lowStockThreshold,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ProductsTableTableUpdateCompanionBuilder =
    ProductsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> nameEn,
      Value<String?> description,
      Value<int> basePrice,
      Value<String?> categoryId,
      Value<String?> imageUrl,
      Value<bool> isAvailable,
      Value<int> stockQty,
      Value<int> lowStockThreshold,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ProductsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get basePrice => $composableBuilder(
    column: $table.basePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stockQty => $composableBuilder(
    column: $table.stockQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get basePrice => $composableBuilder(
    column: $table.basePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stockQty => $composableBuilder(
    column: $table.stockQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get basePrice =>
      $composableBuilder(column: $table.basePrice, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stockQty =>
      $composableBuilder(column: $table.stockQty, builder: (column) => column);

  GeneratedColumn<int> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProductsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTableTable,
          ProductsTableData,
          $$ProductsTableTableFilterComposer,
          $$ProductsTableTableOrderingComposer,
          $$ProductsTableTableAnnotationComposer,
          $$ProductsTableTableCreateCompanionBuilder,
          $$ProductsTableTableUpdateCompanionBuilder,
          (
            ProductsTableData,
            BaseReferences<
              _$AppDatabase,
              $ProductsTableTable,
              ProductsTableData
            >,
          ),
          ProductsTableData,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableTableManager(_$AppDatabase db, $ProductsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> basePrice = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<int> stockQty = const Value.absent(),
                Value<int> lowStockThreshold = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsTableCompanion(
                id: id,
                name: name,
                nameEn: nameEn,
                description: description,
                basePrice: basePrice,
                categoryId: categoryId,
                imageUrl: imageUrl,
                isAvailable: isAvailable,
                stockQty: stockQty,
                lowStockThreshold: lowStockThreshold,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> nameEn = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required int basePrice,
                Value<String?> categoryId = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<int> stockQty = const Value.absent(),
                Value<int> lowStockThreshold = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsTableCompanion.insert(
                id: id,
                name: name,
                nameEn: nameEn,
                description: description,
                basePrice: basePrice,
                categoryId: categoryId,
                imageUrl: imageUrl,
                isAvailable: isAvailable,
                stockQty: stockQty,
                lowStockThreshold: lowStockThreshold,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTableTable,
      ProductsTableData,
      $$ProductsTableTableFilterComposer,
      $$ProductsTableTableOrderingComposer,
      $$ProductsTableTableAnnotationComposer,
      $$ProductsTableTableCreateCompanionBuilder,
      $$ProductsTableTableUpdateCompanionBuilder,
      (
        ProductsTableData,
        BaseReferences<_$AppDatabase, $ProductsTableTable, ProductsTableData>,
      ),
      ProductsTableData,
      PrefetchHooks Function()
    >;
typedef $$DefaultIngredientsTableTableCreateCompanionBuilder =
    DefaultIngredientsTableCompanion Function({
      required String id,
      required String productId,
      required String name,
      Value<String?> nameEn,
      Value<bool> isRemovable,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$DefaultIngredientsTableTableUpdateCompanionBuilder =
    DefaultIngredientsTableCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> name,
      Value<String?> nameEn,
      Value<bool> isRemovable,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$DefaultIngredientsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DefaultIngredientsTableTable> {
  $$DefaultIngredientsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRemovable => $composableBuilder(
    column: $table.isRemovable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DefaultIngredientsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DefaultIngredientsTableTable> {
  $$DefaultIngredientsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRemovable => $composableBuilder(
    column: $table.isRemovable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DefaultIngredientsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DefaultIngredientsTableTable> {
  $$DefaultIngredientsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<bool> get isRemovable => $composableBuilder(
    column: $table.isRemovable,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$DefaultIngredientsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DefaultIngredientsTableTable,
          DefaultIngredientsTableData,
          $$DefaultIngredientsTableTableFilterComposer,
          $$DefaultIngredientsTableTableOrderingComposer,
          $$DefaultIngredientsTableTableAnnotationComposer,
          $$DefaultIngredientsTableTableCreateCompanionBuilder,
          $$DefaultIngredientsTableTableUpdateCompanionBuilder,
          (
            DefaultIngredientsTableData,
            BaseReferences<
              _$AppDatabase,
              $DefaultIngredientsTableTable,
              DefaultIngredientsTableData
            >,
          ),
          DefaultIngredientsTableData,
          PrefetchHooks Function()
        > {
  $$DefaultIngredientsTableTableTableManager(
    _$AppDatabase db,
    $DefaultIngredientsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DefaultIngredientsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DefaultIngredientsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DefaultIngredientsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<bool> isRemovable = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DefaultIngredientsTableCompanion(
                id: id,
                productId: productId,
                name: name,
                nameEn: nameEn,
                isRemovable: isRemovable,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required String name,
                Value<String?> nameEn = const Value.absent(),
                Value<bool> isRemovable = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DefaultIngredientsTableCompanion.insert(
                id: id,
                productId: productId,
                name: name,
                nameEn: nameEn,
                isRemovable: isRemovable,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DefaultIngredientsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DefaultIngredientsTableTable,
      DefaultIngredientsTableData,
      $$DefaultIngredientsTableTableFilterComposer,
      $$DefaultIngredientsTableTableOrderingComposer,
      $$DefaultIngredientsTableTableAnnotationComposer,
      $$DefaultIngredientsTableTableCreateCompanionBuilder,
      $$DefaultIngredientsTableTableUpdateCompanionBuilder,
      (
        DefaultIngredientsTableData,
        BaseReferences<
          _$AppDatabase,
          $DefaultIngredientsTableTable,
          DefaultIngredientsTableData
        >,
      ),
      DefaultIngredientsTableData,
      PrefetchHooks Function()
    >;
typedef $$AddonToppingsTableTableCreateCompanionBuilder =
    AddonToppingsTableCompanion Function({
      required String id,
      required String productId,
      required String name,
      Value<String?> nameEn,
      Value<int> price,
      Value<bool> isAvailable,
      Value<int> stockQty,
      Value<int> lowStockThreshold,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$AddonToppingsTableTableUpdateCompanionBuilder =
    AddonToppingsTableCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> name,
      Value<String?> nameEn,
      Value<int> price,
      Value<bool> isAvailable,
      Value<int> stockQty,
      Value<int> lowStockThreshold,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$AddonToppingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AddonToppingsTableTable> {
  $$AddonToppingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stockQty => $composableBuilder(
    column: $table.stockQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AddonToppingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AddonToppingsTableTable> {
  $$AddonToppingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stockQty => $composableBuilder(
    column: $table.stockQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AddonToppingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AddonToppingsTableTable> {
  $$AddonToppingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stockQty =>
      $composableBuilder(column: $table.stockQty, builder: (column) => column);

  GeneratedColumn<int> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$AddonToppingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AddonToppingsTableTable,
          AddonToppingsTableData,
          $$AddonToppingsTableTableFilterComposer,
          $$AddonToppingsTableTableOrderingComposer,
          $$AddonToppingsTableTableAnnotationComposer,
          $$AddonToppingsTableTableCreateCompanionBuilder,
          $$AddonToppingsTableTableUpdateCompanionBuilder,
          (
            AddonToppingsTableData,
            BaseReferences<
              _$AppDatabase,
              $AddonToppingsTableTable,
              AddonToppingsTableData
            >,
          ),
          AddonToppingsTableData,
          PrefetchHooks Function()
        > {
  $$AddonToppingsTableTableTableManager(
    _$AppDatabase db,
    $AddonToppingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AddonToppingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AddonToppingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AddonToppingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<int> stockQty = const Value.absent(),
                Value<int> lowStockThreshold = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AddonToppingsTableCompanion(
                id: id,
                productId: productId,
                name: name,
                nameEn: nameEn,
                price: price,
                isAvailable: isAvailable,
                stockQty: stockQty,
                lowStockThreshold: lowStockThreshold,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required String name,
                Value<String?> nameEn = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<int> stockQty = const Value.absent(),
                Value<int> lowStockThreshold = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AddonToppingsTableCompanion.insert(
                id: id,
                productId: productId,
                name: name,
                nameEn: nameEn,
                price: price,
                isAvailable: isAvailable,
                stockQty: stockQty,
                lowStockThreshold: lowStockThreshold,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AddonToppingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AddonToppingsTableTable,
      AddonToppingsTableData,
      $$AddonToppingsTableTableFilterComposer,
      $$AddonToppingsTableTableOrderingComposer,
      $$AddonToppingsTableTableAnnotationComposer,
      $$AddonToppingsTableTableCreateCompanionBuilder,
      $$AddonToppingsTableTableUpdateCompanionBuilder,
      (
        AddonToppingsTableData,
        BaseReferences<
          _$AppDatabase,
          $AddonToppingsTableTable,
          AddonToppingsTableData
        >,
      ),
      AddonToppingsTableData,
      PrefetchHooks Function()
    >;
typedef $$OrdersTableTableCreateCompanionBuilder =
    OrdersTableCompanion Function({
      required String id,
      required String orderNumber,
      required String orderType,
      Value<int?> tableNumber,
      required int subtotal,
      required int taxAmount,
      required int grandTotal,
      Value<String> paymentMethod,
      Value<String> paymentStatus,
      Value<int?> cashReceived,
      Value<int?> cashChange,
      Value<String> status,
      Value<String?> cashierId,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$OrdersTableTableUpdateCompanionBuilder =
    OrdersTableCompanion Function({
      Value<String> id,
      Value<String> orderNumber,
      Value<String> orderType,
      Value<int?> tableNumber,
      Value<int> subtotal,
      Value<int> taxAmount,
      Value<int> grandTotal,
      Value<String> paymentMethod,
      Value<String> paymentStatus,
      Value<int?> cashReceived,
      Value<int?> cashChange,
      Value<String> status,
      Value<String?> cashierId,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$OrdersTableTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderType => $composableBuilder(
    column: $table.orderType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tableNumber => $composableBuilder(
    column: $table.tableNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cashReceived => $composableBuilder(
    column: $table.cashReceived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cashChange => $composableBuilder(
    column: $table.cashChange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashierId => $composableBuilder(
    column: $table.cashierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrdersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderType => $composableBuilder(
    column: $table.orderType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tableNumber => $composableBuilder(
    column: $table.tableNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cashReceived => $composableBuilder(
    column: $table.cashReceived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cashChange => $composableBuilder(
    column: $table.cashChange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashierId => $composableBuilder(
    column: $table.cashierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrdersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get orderType =>
      $composableBuilder(column: $table.orderType, builder: (column) => column);

  GeneratedColumn<int> get tableNumber => $composableBuilder(
    column: $table.tableNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<int> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<int> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cashReceived => $composableBuilder(
    column: $table.cashReceived,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cashChange => $composableBuilder(
    column: $table.cashChange,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get cashierId =>
      $composableBuilder(column: $table.cashierId, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$OrdersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTableTable,
          OrdersTableData,
          $$OrdersTableTableFilterComposer,
          $$OrdersTableTableOrderingComposer,
          $$OrdersTableTableAnnotationComposer,
          $$OrdersTableTableCreateCompanionBuilder,
          $$OrdersTableTableUpdateCompanionBuilder,
          (
            OrdersTableData,
            BaseReferences<_$AppDatabase, $OrdersTableTable, OrdersTableData>,
          ),
          OrdersTableData,
          PrefetchHooks Function()
        > {
  $$OrdersTableTableTableManager(_$AppDatabase db, $OrdersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orderNumber = const Value.absent(),
                Value<String> orderType = const Value.absent(),
                Value<int?> tableNumber = const Value.absent(),
                Value<int> subtotal = const Value.absent(),
                Value<int> taxAmount = const Value.absent(),
                Value<int> grandTotal = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<int?> cashReceived = const Value.absent(),
                Value<int?> cashChange = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> cashierId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersTableCompanion(
                id: id,
                orderNumber: orderNumber,
                orderType: orderType,
                tableNumber: tableNumber,
                subtotal: subtotal,
                taxAmount: taxAmount,
                grandTotal: grandTotal,
                paymentMethod: paymentMethod,
                paymentStatus: paymentStatus,
                cashReceived: cashReceived,
                cashChange: cashChange,
                status: status,
                cashierId: cashierId,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orderNumber,
                required String orderType,
                Value<int?> tableNumber = const Value.absent(),
                required int subtotal,
                required int taxAmount,
                required int grandTotal,
                Value<String> paymentMethod = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<int?> cashReceived = const Value.absent(),
                Value<int?> cashChange = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> cashierId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersTableCompanion.insert(
                id: id,
                orderNumber: orderNumber,
                orderType: orderType,
                tableNumber: tableNumber,
                subtotal: subtotal,
                taxAmount: taxAmount,
                grandTotal: grandTotal,
                paymentMethod: paymentMethod,
                paymentStatus: paymentStatus,
                cashReceived: cashReceived,
                cashChange: cashChange,
                status: status,
                cashierId: cashierId,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrdersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTableTable,
      OrdersTableData,
      $$OrdersTableTableFilterComposer,
      $$OrdersTableTableOrderingComposer,
      $$OrdersTableTableAnnotationComposer,
      $$OrdersTableTableCreateCompanionBuilder,
      $$OrdersTableTableUpdateCompanionBuilder,
      (
        OrdersTableData,
        BaseReferences<_$AppDatabase, $OrdersTableTable, OrdersTableData>,
      ),
      OrdersTableData,
      PrefetchHooks Function()
    >;
typedef $$OrderItemsTableTableCreateCompanionBuilder =
    OrderItemsTableCompanion Function({
      required String id,
      required String orderId,
      required String productId,
      required String productName,
      required int quantity,
      required int basePrice,
      Value<int> toppingTotal,
      required int lineTotal,
      Value<List<String>?> removedIngredients,
      Value<List<Map<String, dynamic>>?> addedToppings,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$OrderItemsTableTableUpdateCompanionBuilder =
    OrderItemsTableCompanion Function({
      Value<String> id,
      Value<String> orderId,
      Value<String> productId,
      Value<String> productName,
      Value<int> quantity,
      Value<int> basePrice,
      Value<int> toppingTotal,
      Value<int> lineTotal,
      Value<List<String>?> removedIngredients,
      Value<List<Map<String, dynamic>>?> addedToppings,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$OrderItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get basePrice => $composableBuilder(
    column: $table.basePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toppingTotal => $composableBuilder(
    column: $table.toppingTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
  get removedIngredients => $composableBuilder(
    column: $table.removedIngredients,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<Map<String, dynamic>>?,
    List<Map<String, dynamic>>,
    String
  >
  get addedToppings => $composableBuilder(
    column: $table.addedToppings,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrderItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get basePrice => $composableBuilder(
    column: $table.basePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toppingTotal => $composableBuilder(
    column: $table.toppingTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get removedIngredients => $composableBuilder(
    column: $table.removedIngredients,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addedToppings => $composableBuilder(
    column: $table.addedToppings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrderItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get basePrice =>
      $composableBuilder(column: $table.basePrice, builder: (column) => column);

  GeneratedColumn<int> get toppingTotal => $composableBuilder(
    column: $table.toppingTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String>
  get removedIngredients => $composableBuilder(
    column: $table.removedIngredients,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<Map<String, dynamic>>?, String>
  get addedToppings => $composableBuilder(
    column: $table.addedToppings,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$OrderItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderItemsTableTable,
          OrderItemsTableData,
          $$OrderItemsTableTableFilterComposer,
          $$OrderItemsTableTableOrderingComposer,
          $$OrderItemsTableTableAnnotationComposer,
          $$OrderItemsTableTableCreateCompanionBuilder,
          $$OrderItemsTableTableUpdateCompanionBuilder,
          (
            OrderItemsTableData,
            BaseReferences<
              _$AppDatabase,
              $OrderItemsTableTable,
              OrderItemsTableData
            >,
          ),
          OrderItemsTableData,
          PrefetchHooks Function()
        > {
  $$OrderItemsTableTableTableManager(
    _$AppDatabase db,
    $OrderItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> basePrice = const Value.absent(),
                Value<int> toppingTotal = const Value.absent(),
                Value<int> lineTotal = const Value.absent(),
                Value<List<String>?> removedIngredients = const Value.absent(),
                Value<List<Map<String, dynamic>>?> addedToppings =
                    const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderItemsTableCompanion(
                id: id,
                orderId: orderId,
                productId: productId,
                productName: productName,
                quantity: quantity,
                basePrice: basePrice,
                toppingTotal: toppingTotal,
                lineTotal: lineTotal,
                removedIngredients: removedIngredients,
                addedToppings: addedToppings,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orderId,
                required String productId,
                required String productName,
                required int quantity,
                required int basePrice,
                Value<int> toppingTotal = const Value.absent(),
                required int lineTotal,
                Value<List<String>?> removedIngredients = const Value.absent(),
                Value<List<Map<String, dynamic>>?> addedToppings =
                    const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderItemsTableCompanion.insert(
                id: id,
                orderId: orderId,
                productId: productId,
                productName: productName,
                quantity: quantity,
                basePrice: basePrice,
                toppingTotal: toppingTotal,
                lineTotal: lineTotal,
                removedIngredients: removedIngredients,
                addedToppings: addedToppings,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrderItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderItemsTableTable,
      OrderItemsTableData,
      $$OrderItemsTableTableFilterComposer,
      $$OrderItemsTableTableOrderingComposer,
      $$OrderItemsTableTableAnnotationComposer,
      $$OrderItemsTableTableCreateCompanionBuilder,
      $$OrderItemsTableTableUpdateCompanionBuilder,
      (
        OrderItemsTableData,
        BaseReferences<
          _$AppDatabase,
          $OrderItemsTableTable,
          OrderItemsTableData
        >,
      ),
      OrderItemsTableData,
      PrefetchHooks Function()
    >;
typedef $$StockHistoryTableTableCreateCompanionBuilder =
    StockHistoryTableCompanion Function({
      required String id,
      required String productId,
      Value<String> itemType,
      required int previousQty,
      required int newQty,
      required String changeType,
      required int changeAmount,
      Value<String?> notes,
      Value<String?> userId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$StockHistoryTableTableUpdateCompanionBuilder =
    StockHistoryTableCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> itemType,
      Value<int> previousQty,
      Value<int> newQty,
      Value<String> changeType,
      Value<int> changeAmount,
      Value<String?> notes,
      Value<String?> userId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$StockHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $StockHistoryTableTable> {
  $$StockHistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get previousQty => $composableBuilder(
    column: $table.previousQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get newQty => $composableBuilder(
    column: $table.newQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changeType => $composableBuilder(
    column: $table.changeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get changeAmount => $composableBuilder(
    column: $table.changeAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StockHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StockHistoryTableTable> {
  $$StockHistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get previousQty => $composableBuilder(
    column: $table.previousQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get newQty => $composableBuilder(
    column: $table.newQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changeType => $composableBuilder(
    column: $table.changeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get changeAmount => $composableBuilder(
    column: $table.changeAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StockHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockHistoryTableTable> {
  $$StockHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<int> get previousQty => $composableBuilder(
    column: $table.previousQty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get newQty =>
      $composableBuilder(column: $table.newQty, builder: (column) => column);

  GeneratedColumn<String> get changeType => $composableBuilder(
    column: $table.changeType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get changeAmount => $composableBuilder(
    column: $table.changeAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$StockHistoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockHistoryTableTable,
          StockHistoryData,
          $$StockHistoryTableTableFilterComposer,
          $$StockHistoryTableTableOrderingComposer,
          $$StockHistoryTableTableAnnotationComposer,
          $$StockHistoryTableTableCreateCompanionBuilder,
          $$StockHistoryTableTableUpdateCompanionBuilder,
          (
            StockHistoryData,
            BaseReferences<
              _$AppDatabase,
              $StockHistoryTableTable,
              StockHistoryData
            >,
          ),
          StockHistoryData,
          PrefetchHooks Function()
        > {
  $$StockHistoryTableTableTableManager(
    _$AppDatabase db,
    $StockHistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockHistoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockHistoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockHistoryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> itemType = const Value.absent(),
                Value<int> previousQty = const Value.absent(),
                Value<int> newQty = const Value.absent(),
                Value<String> changeType = const Value.absent(),
                Value<int> changeAmount = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockHistoryTableCompanion(
                id: id,
                productId: productId,
                itemType: itemType,
                previousQty: previousQty,
                newQty: newQty,
                changeType: changeType,
                changeAmount: changeAmount,
                notes: notes,
                userId: userId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                Value<String> itemType = const Value.absent(),
                required int previousQty,
                required int newQty,
                required String changeType,
                required int changeAmount,
                Value<String?> notes = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockHistoryTableCompanion.insert(
                id: id,
                productId: productId,
                itemType: itemType,
                previousQty: previousQty,
                newQty: newQty,
                changeType: changeType,
                changeAmount: changeAmount,
                notes: notes,
                userId: userId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StockHistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockHistoryTableTable,
      StockHistoryData,
      $$StockHistoryTableTableFilterComposer,
      $$StockHistoryTableTableOrderingComposer,
      $$StockHistoryTableTableAnnotationComposer,
      $$StockHistoryTableTableCreateCompanionBuilder,
      $$StockHistoryTableTableUpdateCompanionBuilder,
      (
        StockHistoryData,
        BaseReferences<
          _$AppDatabase,
          $StockHistoryTableTable,
          StockHistoryData
        >,
      ),
      StockHistoryData,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableTableCreateCompanionBuilder =
    SyncQueueTableCompanion Function({
      Value<int> id,
      required String tableName_,
      required String recordId,
      required String operation,
      required String payload,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<int> retryCount,
    });
typedef $$SyncQueueTableTableUpdateCompanionBuilder =
    SyncQueueTableCompanion Function({
      Value<int> id,
      Value<String> tableName_,
      Value<String> recordId,
      Value<String> operation,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<int> retryCount,
    });

class $$SyncQueueTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tableName_ => $composableBuilder(
    column: $table.tableName_,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tableName_ => $composableBuilder(
    column: $table.tableName_,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tableName_ => $composableBuilder(
    column: $table.tableName_,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );
}

class $$SyncQueueTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTableTable,
          SyncQueueData,
          $$SyncQueueTableTableFilterComposer,
          $$SyncQueueTableTableOrderingComposer,
          $$SyncQueueTableTableAnnotationComposer,
          $$SyncQueueTableTableCreateCompanionBuilder,
          $$SyncQueueTableTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableTableManager(
    _$AppDatabase db,
    $SyncQueueTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tableName_ = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
              }) => SyncQueueTableCompanion(
                id: id,
                tableName_: tableName_,
                recordId: recordId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                status: status,
                retryCount: retryCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tableName_,
                required String recordId,
                required String operation,
                required String payload,
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
              }) => SyncQueueTableCompanion.insert(
                id: id,
                tableName_: tableName_,
                recordId: recordId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                status: status,
                retryCount: retryCount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTableTable,
      SyncQueueData,
      $$SyncQueueTableTableFilterComposer,
      $$SyncQueueTableTableOrderingComposer,
      $$SyncQueueTableTableAnnotationComposer,
      $$SyncQueueTableTableCreateCompanionBuilder,
      $$SyncQueueTableTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$ProductsTableTableTableManager get productsTable =>
      $$ProductsTableTableTableManager(_db, _db.productsTable);
  $$DefaultIngredientsTableTableTableManager get defaultIngredientsTable =>
      $$DefaultIngredientsTableTableTableManager(
        _db,
        _db.defaultIngredientsTable,
      );
  $$AddonToppingsTableTableTableManager get addonToppingsTable =>
      $$AddonToppingsTableTableTableManager(_db, _db.addonToppingsTable);
  $$OrdersTableTableTableManager get ordersTable =>
      $$OrdersTableTableTableManager(_db, _db.ordersTable);
  $$OrderItemsTableTableTableManager get orderItemsTable =>
      $$OrderItemsTableTableTableManager(_db, _db.orderItemsTable);
  $$StockHistoryTableTableTableManager get stockHistoryTable =>
      $$StockHistoryTableTableTableManager(_db, _db.stockHistoryTable);
  $$SyncQueueTableTableTableManager get syncQueueTable =>
      $$SyncQueueTableTableTableManager(_db, _db.syncQueueTable);
}
