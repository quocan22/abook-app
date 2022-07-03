import 'package:equatable/equatable.dart';

import '../../models/address_book.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class OrderRequested extends OrderEvent {
  final String userId;

  const OrderRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class OrderCreated extends OrderEvent {
  final String userId;
  final int discountPrice;
  final AddressBook addressBook;

  OrderCreated(
      {required this.userId,
      required this.discountPrice,
      required this.addressBook});

  @override
  List<Object?> get props => [userId, discountPrice, addressBook];
}
