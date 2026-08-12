import '../../../catalog/data/models/product_model.dart';
import '../../../catalog/data/models/default_ingredient_model.dart';
import '../../../catalog/data/models/addon_topping_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;
  final List<DefaultIngredientModel> removedIngredients;
  final List<AddonToppingModel> addedToppings;
  final String? notes;

  CartItemModel({
    required this.product,
    this.quantity = 1,
    this.removedIngredients = const [],
    this.addedToppings = const [],
    this.notes,
  });

  /// The price of a single item including all added toppings.
  /// Removed ingredients do not affect the price.
  int get unitPrice {
    int toppingPrice = addedToppings.fold(0, (sum, t) => sum + t.price);
    return product.basePrice + toppingPrice;
  }

  /// Total price for this cart item (unit price * quantity)
  int get lineTotal => unitPrice * quantity;

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
    List<DefaultIngredientModel>? removedIngredients,
    List<AddonToppingModel>? addedToppings,
    String? notes,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      removedIngredients: removedIngredients ?? this.removedIngredients,
      addedToppings: addedToppings ?? this.addedToppings,
      notes: notes ?? this.notes,
    );
  }
}
