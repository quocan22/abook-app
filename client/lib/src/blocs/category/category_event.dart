import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class CategoryRequested extends CategoryEvent {
  @override
  List<Object?> get props => [];
}
