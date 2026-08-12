class AddonToppingModel {
  final String id;
  final String productId;
  final String name;
  final String? nameEn;
  final int price;
  final bool isAvailable;
  final int sortOrder;

  const AddonToppingModel({
    required this.id,
    required this.productId,
    required this.name,
    this.nameEn,
    this.price = 0,
    this.isAvailable = true,
    this.sortOrder = 0,
  });

  factory AddonToppingModel.fromJson(Map<String, dynamic> json) {
    return AddonToppingModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      name: json['name'] as String,
      nameEn: json['name_en'] as String?,
      price: (json['price'] as num?)?.toInt() ?? 0,
      isAvailable: json['is_available'] as bool? ?? true,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'name_en': nameEn,
      'price': price,
      'is_available': isAvailable,
      'sort_order': sortOrder,
    };
  }

  bool get isFree => price == 0;

  /// Formats the price as Indonesian Rupiah, or "GRATIS" if free.
  String get formattedPrice {
    if (isFree) return 'GRATIS';
    final formatted = price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '+Rp $formatted';
  }

  /// Returns the localized name based on language code.
  String localizedName(String languageCode) {
    if (languageCode == 'en' && nameEn != null && nameEn!.isNotEmpty) {
      return nameEn!;
    }
    return name;
  }

  AddonToppingModel copyWith({
    String? id,
    String? productId,
    String? name,
    String? nameEn,
    int? price,
    bool? isAvailable,
    int? sortOrder,
  }) {
    return AddonToppingModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
