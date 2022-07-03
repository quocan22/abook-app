import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartDetailRequested extends CartEvent {
  final String userId;

  const CartDetailRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class CartBookAdded extends CartEvent {
  final String userId;
  final String bookId;
  final int quantity;

  CartBookAdded(
      {required this.userId, required this.bookId, required this.quantity});

  @override
  List<Object?> get props => [userId, bookId, quantity];
}

class CartBookRemoved extends CartEvent {
  final String userId;
  final String bookId;

  CartBookRemoved({required this.userId, required this.bookId});

  @override
  List<Object?> get props => [userId, bookId];
}

class CartBookQuantityChanged extends CartEvent {
  final String userId;
  final String bookId;
  final int newQuantity;

  CartBookQuantityChanged(
      {required this.userId, required this.bookId, required this.newQuantity});

  @override
  List<Object?> get props => [userId, bookId, newQuantity];
}
