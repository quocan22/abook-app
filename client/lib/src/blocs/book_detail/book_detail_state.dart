import 'package:equatable/equatable.dart';

import '../../models/book.dart';

abstract class BookDetailState extends Equatable {
  const BookDetailState();

  @override
  List<Object?> get props => [];
}

class BookDetailInitial extends BookDetailState {}

class BookDetailLoadInProgress extends BookDetailState {}

class BookDetailLoadFailure extends BookDetailState {
  final String? errorMessage;

  const BookDetailLoadFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class BookDetailLoadSuccess extends BookDetailState {
  final Book? book;

  const BookDetailLoadSuccess({this.book});

  @override
  List<Object?> get props => [book];
}
