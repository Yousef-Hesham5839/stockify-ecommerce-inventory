import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.sku,
    required super.description,
    required super.price,
    required super.stockQuantity,
    required super.category,
    required super.imageUrl,
    super.lowStockThreshold,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      sku: json['sku'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: (json['stockQuantity'] as num?)?.toInt() ?? 0,
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? 'https://placehold.co/600x400/png?text=Product',
      lowStockThreshold: (json['lowStockThreshold'] as num?)?.toInt() ?? 5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'description': description,
      'price': price,
      'stockQuantity': stockQuantity,
      'category': category,
      'imageUrl': imageUrl,
      'lowStockThreshold': lowStockThreshold,
    };
  }
}