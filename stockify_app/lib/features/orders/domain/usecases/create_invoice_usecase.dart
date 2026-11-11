import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';
import '../repositories/order_repository.dart';

class CreateInvoiceUseCase {
  final OrderRepository repository;
  CreateInvoiceUseCase(this.repository);

  Future<Either<Failure, InvoiceEntity>> call({
    required List<Map<String, dynamic>> items,
    required String shippingAddress,
    required String paymentMethod,
  }) {
    return repository.createInvoice(
      items: items,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );
  }
}