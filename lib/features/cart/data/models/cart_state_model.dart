import 'cart_item_model.dart';

enum OrderType { dineIn, takeaway }

class CartState {
  final List<CartItemModel> items;
  final OrderType orderType;
  final int? tableNumber;
  final double taxRate;

  const CartState({
    this.items = const [],
    this.orderType = OrderType.takeaway,
    this.tableNumber,
    this.taxRate = 0.10, // 10% PB1 tax
  });

  int get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);
  int get taxAmount => (subtotal * taxRate).round();
  int get grandTotal => subtotal + taxAmount;

  CartState copyWith({
    List<CartItemModel>? items,
    OrderType? orderType,
    int? tableNumber,
    double? taxRate,
  }) {
    return CartState(
      items: items ?? this.items,
      orderType: orderType ?? this.orderType,
      tableNumber: tableNumber ?? this.tableNumber,
      taxRate: taxRate ?? this.taxRate,
    );
  }
}
