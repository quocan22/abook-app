import 'package:equatable/equatable.dart';

abstract class UserClaimEvent extends Equatable {
  const UserClaimEvent();

  @override
  List<Object?> get props => [];
}

class UserClaimRequested extends UserClaimEvent {
  final String userId;

  UserClaimRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class BookAddedFav extends UserClaimEvent {
  final String bookId;

  BookAddedFav({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

class BookRemovedFav extends UserClaimEvent {
  final String bookId;

  BookRemovedFav({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}
