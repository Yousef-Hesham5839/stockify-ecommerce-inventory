import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartState extends Equatable {
  final List<CartItemEntity> items;
  final String? errorMessage;

  const CartState({
    this.items = const [],
    this.errorMessage,
  });

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get taxAmount => subtotal * 0.14;
  double get totalAmount => subtotal + taxAmount;

  CartState copyWith({
    List<CartItemEntity>? items,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [items, errorMessage];
}