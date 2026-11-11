import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

class PlaceOrderEvent extends OrderEvent {
  final List<Map<String, dynamic>> items;
  final String shippingAddress;
  final String paymentMethod;

  const PlaceOrderEvent({
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [items, shippingAddress, paymentMethod];
}

class FetchMyInvoicesEvent extends OrderEvent {}