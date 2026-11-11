import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/invoice_model.dart';

abstract class OrderRemoteDataSource {
  Future<InvoiceModel> createInvoice(Map<String, dynamic> orderData);
  Future<List<InvoiceModel>> getMyInvoices();
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient client;
  OrderRemoteDataSourceImpl({required this.client});

  @override
  Future<InvoiceModel> createInvoice(Map<String, dynamic> orderData) async {
    final response = await client.post(
      ApiEndpoints.invoices,
      data: orderData,
    );
    return InvoiceModel.fromJson(response.data['data']['invoice']);
  }

  @override
  Future<List<InvoiceModel>> getMyInvoices() async {
    final response = await client.get(ApiEndpoints.invoices);
    final List invoicesData = response.data['data']['invoices'];
    return invoicesData.map((e) => InvoiceModel.fromJson(e)).toList();
  }
}