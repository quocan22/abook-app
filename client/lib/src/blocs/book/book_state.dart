import 'package:equatable/equatable.dart';

import '../../models/book.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoadInProgress extends BookState {}

class BookLoadFailure extends BookState {
  final String? errorMessage;

  const BookLoadFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class BookLoadSuccess extends BookState {
  final List<Book>? books;

  const BookLoadSuccess({this.books});

  @override
  List<Object?> get props => [books];
}

class BookLoadByIdInProgress extends BookState {}

class BookLoadByIdFailure extends BookState {
  final String? errorMessage;

  const BookLoadByIdFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class BookLoadByIdSuccess extends BookState {
  final Book? book;

  const BookLoadByIdSuccess({this.book});

  @override
  List<Object?> get props => [book];
}

class BookAddFavSuccess extends BookState {}

class BookAddFavFailure extends BookState {}

class BookRemoveFavSuccess extends BookState {}

class BookRemoveFavFailure extends BookState {}
