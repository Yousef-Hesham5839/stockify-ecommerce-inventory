import 'package:equatable/equatable.dart';

class InvoiceItemEntity extends Equatable {
  final String productId;
  final String name;
  final String sku;
  final double unitPrice;
  final int quantity;
  final double total;

  const InvoiceItemEntity({
    required this.productId,
    required this.name,
    required this.sku,
    required this.unitPrice,
    required this.quantity,
    required this.total,
  });

  @override
  List<Object?> get props => [productId, name, sku, unitPrice, quantity, total];
}

class InvoiceEntity extends Equatable {
  final String id;
  final String invoiceNumber;
  final List<InvoiceItemEntity> items;
  final double subtotal;
  final double taxAmount;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final String shippingAddress;
  final DateTime createdAt;

  const InvoiceEntity({
    required this.id,
    required this.invoiceNumber,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        invoiceNumber,
        items,
        subtotal,
        taxAmount,
        totalAmount,
        status,
        paymentMethod,
        shippingAddress,
        createdAt,
      ];
}