import 'package:equatable/equatable.dart';

abstract class BookByCategoryEvent extends Equatable {
  const BookByCategoryEvent();

  @override
  List<Object?> get props => [];
}

class BookListByCategoryIdRequested extends BookByCategoryEvent {
  final String categoryId;

  BookListByCategoryIdRequested({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}
