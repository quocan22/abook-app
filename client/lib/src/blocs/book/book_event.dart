import 'package:equatable/equatable.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object?> get props => [];
}

class BookRequested extends BookEvent {
  @override
  List<Object?> get props => [];
}

class BookAddedFav extends BookEvent {
  final String bookId;

  BookAddedFav({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

class BookRemovedFav extends BookEvent {
  final String bookId;

  BookRemovedFav({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}
