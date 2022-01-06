import 'package:equatable/equatable.dart';

import '../../models/book.dart';

abstract class BookByCategoryState extends Equatable {
  const BookByCategoryState();

  @override
  List<Object?> get props => [];
}

class BookByCategoryInitial extends BookByCategoryState {}

class BookByCategoryLoadInProgress extends BookByCategoryState {}

class BookByCategoryLoadFailure extends BookByCategoryState {
  final String? errorMessage;

  const BookByCategoryLoadFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class BookByCategoryLoadSuccess extends BookByCategoryState {
  final List<Book>? books;

  const BookByCategoryLoadSuccess({this.books});

  @override
  List<Object?> get props => [books];
}
