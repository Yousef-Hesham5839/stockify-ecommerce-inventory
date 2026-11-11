import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String sku;
  final String description;
  final double price;
  final int stockQuantity;
  final String category;
  final String imageUrl;
  final int lowStockThreshold;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.sku,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.category,
    required this.imageUrl,
    this.lowStockThreshold = 5,
  });

  bool get isOutOfStock => stockQuantity <= 0;
  bool get isLowStock => stockQuantity > 0 && stockQuantity <= lowStockThreshold;

  @override
  List<Object?> get props => [
        id,
        name,
        sku,
        description,
        price,
        stockQuantity,
        category,
        imageUrl,
        lowStockThreshold,
      ];
}