import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;
  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
  }) {
    return repository.getProducts(
      page: page,
      limit: limit,
      search: search,
      category: category,
    );
  }
}