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
