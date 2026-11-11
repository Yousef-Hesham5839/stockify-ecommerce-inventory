import '../../domain/entities/invoice_entity.dart';

class InvoiceItemModel extends InvoiceItemEntity {
  const InvoiceItemModel({
    required super.productId,
    required super.name,
    required super.sku,
    required super.unitPrice,
    required super.quantity,
    required super.total,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceItemModel(
      productId: json['product'] is Map ? json['product']['_id'] : json['product'] ?? '',
      name: json['name'] ?? '',
      sku: json['sku'] ?? '',
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class InvoiceModel extends InvoiceEntity {
  const InvoiceModel({
    required super.id,
    required super.invoiceNumber,
    required super.items,
    required super.subtotal,
    required super.taxAmount,
    required super.totalAmount,
    required super.status,
    required super.paymentMethod,
    required super.shippingAddress,
    required super.createdAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List? ?? [];
    final items = rawItems.map((e) => InvoiceItemModel.fromJson(e)).toList();

    return InvoiceModel(
      id: json['_id'] ?? json['id'] ?? '',
      invoiceNumber: json['invoiceNumber'] ?? '',
      items: items,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'PENDING',
      paymentMethod: json['paymentMethod'] ?? 'CASH_ON_DELIVERY',
      shippingAddress: json['shippingAddress'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}