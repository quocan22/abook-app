import 'package:equatable/equatable.dart';

import '../../models/discount.dart';

abstract class DiscountState extends Equatable {
  const DiscountState();

  @override
  List<Object?> get props => [];
}

class DiscountInitial extends DiscountState {}

class DiscountLoadInProgress extends DiscountState {}

class DiscountLoadFailure extends DiscountState {
  final String? errorMessage;

  const DiscountLoadFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class DiscountLoadSuccess extends DiscountState {
  final List<Discount>? discounts;

  const DiscountLoadSuccess({this.discounts});

  @override
  List<Object?> get props => [discounts];
}
