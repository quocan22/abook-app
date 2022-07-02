import 'package:equatable/equatable.dart';

import '../../models/order.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoadInProgress extends OrderState {}

class OrderLoadFailure extends OrderState {
  final String? errorMessage;

  const OrderLoadFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class OrderLoadSuccess extends OrderState {
  final List<Order>? orderList;

  const OrderLoadSuccess({this.orderList});

  @override
  List<Object?> get props => [orderList];
}
