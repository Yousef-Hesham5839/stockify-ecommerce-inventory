import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

class FetchProductsEvent extends ProductEvent {
  final String? search;
  final String? category;
  const FetchProductsEvent({this.search, this.category});
  @override
  List<Object?> get props => [search, category];
}

class RefreshProductsEvent extends ProductEvent {}