class DefaultIngredientModel {
  final String id;
  final String productId;
  final String name;
  final String? nameEn;
  final bool isRemovable;
  final int sortOrder;

  const DefaultIngredientModel({
    required this.id,
    required this.productId,
    required this.name,
    this.nameEn,
    this.isRemovable = true,
    this.sortOrder = 0,
  });

  factory DefaultIngredientModel.fromJson(Map<String, dynamic> json) {
    return DefaultIngredientModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      name: json['name'] as String,
      nameEn: json['name_en'] as String?,
      isRemovable: json['is_removable'] as bool? ?? true,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'name_en': nameEn,
      'is_removable': isRemovable,
      'sort_order': sortOrder,
    };
  }

  /// Returns the localized name based on language code.
  String localizedName(String languageCode) {
    if (languageCode == 'en' && nameEn != null && nameEn!.isNotEmpty) {
      return nameEn!;
    }
    return name;
  }

  DefaultIngredientModel copyWith({
    String? id,
    String? productId,
    String? name,
    String? nameEn,
    bool? isRemovable,
    int? sortOrder,
  }) {
    return DefaultIngredientModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      isRemovable: isRemovable ?? this.isRemovable,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
