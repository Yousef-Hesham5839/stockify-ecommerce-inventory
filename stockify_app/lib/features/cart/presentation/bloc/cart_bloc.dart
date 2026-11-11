import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cart_item_entity.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    if (existingIndex >= 0) {
      final existingItem = state.items[existingIndex];
      final newQuantity = existingItem.quantity + event.quantity;

      if (newQuantity > event.product.stockQuantity) {
        emit(state.copyWith(
          errorMessage: 'Cannot add more. Only ${event.product.stockQuantity} items in stock.',
        ));
        return;
      }

      final updatedItems = List<CartItemEntity>.from(state.items);
      updatedItems[existingIndex] = existingItem.copyWith(quantity: newQuantity);
      emit(state.copyWith(items: updatedItems, errorMessage: null));
    } else {
      if (event.quantity > event.product.stockQuantity) {
        emit(state.copyWith(
          errorMessage: 'Only ${event.product.stockQuantity} items in stock.',
        ));
        return;
      }

      final newItem = CartItemEntity(product: event.product, quantity: event.quantity);
      emit(state.copyWith(items: [...state.items, newItem], errorMessage: null));
    }
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    final updatedItems = state.items.where((item) => item.product.id != event.productId).toList();
    emit(state.copyWith(items: updatedItems, errorMessage: null));
  }

  void _onUpdateQuantity(UpdateQuantityEvent event, Emitter<CartState> emit) {
    if (event.quantity <= 0) {
      add(RemoveFromCartEvent(event.productId));
      return;
    }

    final index = state.items.indexWhere((item) => item.product.id == event.productId);
    if (index >= 0) {
      final item = state.items[index];

      if (event.quantity > item.product.stockQuantity) {
        emit(state.copyWith(
          errorMessage: 'Max available stock is ${item.product.stockQuantity}',
        ));
        return;
      }

      final updatedItems = List<CartItemEntity>.from(state.items);
      updatedItems[index] = item.copyWith(quantity: event.quantity);
      emit(state.copyWith(items: updatedItems, errorMessage: null));
    }
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}