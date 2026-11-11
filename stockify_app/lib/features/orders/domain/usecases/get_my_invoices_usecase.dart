import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';
import '../repositories/order_repository.dart';

class GetMyInvoicesUseCase {
  final OrderRepository repository;
  GetMyInvoicesUseCase(this.repository);

  Future<Either<Failure, List<InvoiceEntity>>> call() {
    return repository.getMyInvoices();
  }
}