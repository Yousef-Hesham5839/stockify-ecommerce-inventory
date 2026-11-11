import 'package:equatable/equatable.dart';
import '../../domain/entities/invoice_entity.dart';

abstract class OrderState extends Equatable {
  const OrderState();
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final InvoiceEntity invoice;
  const OrderSuccess(this.invoice);
  @override
  List<Object?> get props => [invoice];
}

class InvoicesLoaded extends OrderState {
  final List<InvoiceEntity> invoices;
  const InvoicesLoaded(this.invoices);
  @override
  List<Object?> get props => [invoices];
}

class OrderFailure extends OrderState {
  final String message;
  const OrderFailure(this.message);
  @override
  List<Object?> get props => [message];
}