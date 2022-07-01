import 'package:equatable/equatable.dart';

abstract class DiscountEvent extends Equatable {
  const DiscountEvent();

  @override
  List<Object?> get props => [];
}

class DiscountRequested extends DiscountEvent {
  @override
  List<Object?> get props => [];
}
