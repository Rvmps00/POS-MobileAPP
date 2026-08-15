import 'package:flutter/foundation.dart';

class ProductModel {
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
  final List<String> variations;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductModel({
    required this.id,
    required this.name,
    this.nameEn,
    this.description,
    required this.basePrice,
    this.categoryId,
    this.imageUrl,
    this.isAvailable = true,
    this.stockQty = 0,
    this.lowStockThreshold = 10,
    this.variations = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEn: json['name_en'] as String?,
      description: json['description'] as String?,
      basePrice: (json['base_price'] as num).toInt(),
      categoryId: json['category_id'] as String?,
      imageUrl: json['image_url'] as String?,
      isAvailable: json['is_available'] as bool? ?? true,
      stockQty: (json['stock_qty'] as num?)?.toInt() ?? 0,
      lowStockThreshold: (json['low_stock_threshold'] as num?)?.toInt() ?? 10,
      variations: (json['variations'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'description': description,
      'base_price': basePrice,
      'category_id': categoryId,
      'image_url': imageUrl,
      'is_available': isAvailable,
      'stock_qty': stockQty,
      'low_stock_threshold': lowStockThreshold,
      'variations': variations,
    };
  }

  /// Returns the localized name based on language code.
  String localizedName(String languageCode) {
    if (languageCode == 'en' && nameEn != null && nameEn!.isNotEmpty) {
      return nameEn!;
    }
    return name;
  }

  /// Formats the base price as Indonesian Rupiah.
  String get formattedPrice {
    final formatted = basePrice.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }

  bool get isOutOfStock => !isAvailable || stockQty <= 0;

  bool get isLowStock => stockQty > 0 && stockQty <= lowStockThreshold;

  ProductModel copyWith({
    String? id,
    String? name,
    String? nameEn,
    String? description,
    int? basePrice,
    String? categoryId,
    String? imageUrl,
    bool? isAvailable,
    int? stockQty,
    int? lowStockThreshold,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
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
      variations: variations ?? this.variations,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProductModel &&
      other.id == id &&
      other.name == name &&
      other.nameEn == nameEn &&
      other.description == description &&
      other.basePrice == basePrice &&
      other.categoryId == categoryId &&
      other.imageUrl == imageUrl &&
      other.isAvailable == isAvailable &&
      other.stockQty == stockQty &&
      other.lowStockThreshold == lowStockThreshold &&
      listEquals(other.variations, variations) &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      nameEn.hashCode ^
      description.hashCode ^
      basePrice.hashCode ^
      categoryId.hashCode ^
      imageUrl.hashCode ^
      isAvailable.hashCode ^
      stockQty.hashCode ^
      lowStockThreshold.hashCode ^
      variations.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
