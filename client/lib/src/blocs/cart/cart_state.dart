import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoadInProgress extends CartState {}

class CartLoadFailure extends CartState {
  final String? errorMessage;

  const CartLoadFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class CartLoadSuccess extends CartState {
  final List<dynamic>? cartDetailList;

  const CartLoadSuccess({this.cartDetailList});

  @override
  List<Object?> get props => [cartDetailList];
}
