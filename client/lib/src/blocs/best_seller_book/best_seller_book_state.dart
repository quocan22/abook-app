import 'package:equatable/equatable.dart';

import '../../models/book.dart';

abstract class BestSellerBookState extends Equatable {
  const BestSellerBookState();

  @override
  List<Object?> get props => [];
}

class BestSellerBookInitial extends BestSellerBookState {}

class BestSellerBookLoadInProgress extends BestSellerBookState {}

class BestSellerBookLoadFailure extends BestSellerBookState {
  final String? errorMessage;

  const BestSellerBookLoadFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class BestSellerBookLoadSuccess extends BestSellerBookState {
  final List<Book>? bookList;

  const BestSellerBookLoadSuccess({this.bookList});

  @override
  List<Object?> get props => [bookList];
}
