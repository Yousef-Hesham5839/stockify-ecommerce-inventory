import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_invoice_usecase.dart';
import '../../domain/usecases/get_my_invoices_usecase.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateInvoiceUseCase createInvoiceUseCase;
  final GetMyInvoicesUseCase getMyInvoicesUseCase;

  OrderBloc({
    required this.createInvoiceUseCase,
    required this.getMyInvoicesUseCase,
  }) : super(OrderInitial()) {
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<FetchMyInvoicesEvent>(_onFetchMyInvoices);
  }

  Future<void> _onPlaceOrder(PlaceOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    final result = await createInvoiceUseCase(
      items: event.items,
      shippingAddress: event.shippingAddress,
      paymentMethod: event.paymentMethod,
    );
    result.fold(
      (failure) => emit(OrderFailure(failure.message)),
      (invoice) => emit(OrderSuccess(invoice)),
    );
  }

  Future<void> _onFetchMyInvoices(FetchMyInvoicesEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    final result = await getMyInvoicesUseCase();
    result.fold(
      (failure) => emit(OrderFailure(failure.message)),
      (invoices) => emit(InvoicesLoaded(invoices)),
    );
  }
}