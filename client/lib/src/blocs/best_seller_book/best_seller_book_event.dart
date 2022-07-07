import 'package:equatable/equatable.dart';

abstract class BestSellerBookEvent extends Equatable {
  const BestSellerBookEvent();

  @override
  List<Object?> get props => [];
}

class BestSellerBookRequested extends BestSellerBookEvent {}
