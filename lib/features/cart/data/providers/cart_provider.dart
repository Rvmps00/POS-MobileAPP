import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item_model.dart';
import '../models/cart_state_model.dart';
import '../../../../core/settings/tax_notifier.dart';

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() {
    ref.listen<bool>(taxEnabledProvider, (prev, next) {
      state = state.copyWith(taxRate: next ? 0.10 : 0.0);
    });
    final taxEnabled = ref.read(taxEnabledProvider);
    return CartState(taxRate: taxEnabled ? 0.10 : 0.0);
  }

  void addItem(CartItemModel item) {
    // Check if identical item (same product, same toppings, same removed ingredients) exists
    final existingIndex = state.items.indexWhere((i) {
      if (i.product.id != item.product.id) return false;
      if (i.selectedVariation != item.selectedVariation) return false;
      if (i.notes != item.notes) return false;
      // Compare removed ingredients
      if (i.removedIngredients.length != item.removedIngredients.length) {
        return false;
      }
      for (var ing in i.removedIngredients) {
        if (!item.removedIngredients.any((e) => e.id == ing.id)) return false;
      }
      // Compare added toppings
      if (i.addedToppings.length != item.addedToppings.length) return false;
      for (var top in i.addedToppings) {
        if (!item.addedToppings.any((e) => e.id == top.id)) return false;
      }
      return true;
    });

    if (existingIndex >= 0) {
      // Update quantity
      final existingItem = state.items[existingIndex];
      final newItems = List<CartItemModel>.from(state.items);
      newItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
      state = state.copyWith(items: newItems);
    } else {
      // Add new item
      state = state.copyWith(items: [...state.items, item]);
    }
  }

  void updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(index);
      return;
    }
    final newItems = List<CartItemModel>.from(state.items);
    newItems[index] = newItems[index].copyWith(quantity: newQuantity);
    state = state.copyWith(items: newItems);
  }

  void removeItem(int index) {
    final newItems = List<CartItemModel>.from(state.items);
    newItems.removeAt(index);
    state = state.copyWith(items: newItems);
  }

  void clearCart() {
    final taxEnabled = ref.read(taxEnabledProvider);
    state = CartState(taxRate: taxEnabled ? 0.10 : 0.0);
  }

  void setOrderType(OrderType type) {
    state = state.copyWith(orderType: type);
  }

  void setTableNumber(int? table) {
    state = state.copyWith(tableNumber: table);
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);
