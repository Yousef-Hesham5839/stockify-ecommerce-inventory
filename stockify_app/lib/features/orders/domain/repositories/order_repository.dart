import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, InvoiceEntity>> createInvoice({
    required List<Map<String, dynamic>> items,
    required String shippingAddress,
    required String paymentMethod,
  });

  Future<Either<Failure, List<InvoiceEntity>>> getMyInvoices();
}