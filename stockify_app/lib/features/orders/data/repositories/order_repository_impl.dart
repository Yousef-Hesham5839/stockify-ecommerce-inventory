import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, InvoiceEntity>> createInvoice({
    required List<Map<String, dynamic>> items,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    try {
      final invoice = await remoteDataSource.createInvoice({
        'items': items,
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
      });
      return Right(invoice);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InvoiceEntity>>> getMyInvoices() async {
    try {
      final invoices = await remoteDataSource.getMyInvoices();
      return Right(invoices);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}