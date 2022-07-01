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

class BookRequestedById extends BookEvent {
  final String bookId;

  BookRequestedById({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

// class BookAddedFav extends BookEvent {
//   final String bookId;

//   BookAddedFav({required this.bookId});

//   @override
//   List<Object?> get props => [bookId];
// }

// class BookRemovedFav extends BookEvent {
//   final String bookId;

//   BookRemovedFav({required this.bookId});

//   @override
//   List<Object?> get props => [bookId];
// }

class BookSentComment extends BookEvent {
  final String bookId;
  final String userId;
  final int rate;
  final String review;

  BookSentComment(
      {required this.bookId,
      required this.userId,
      required this.rate,
      required this.review});

  @override
  List<Object?> get props => [bookId, userId, rate, review];
}
