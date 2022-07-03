import 'package:equatable/equatable.dart';

abstract class BookDetailEvent extends Equatable {
  const BookDetailEvent();

  @override
  List<Object?> get props => [];
}

class BookDetailRequestedById extends BookDetailEvent {
  final String bookId;

  BookDetailRequestedById({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

class BookSentComment extends BookDetailEvent {
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
