import 'package:equatable/equatable.dart';

import '../../models/category.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoadInProgress extends CategoryState {}

class CategoryLoadFailure extends CategoryState {
  final String? errorMessage;

  const CategoryLoadFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class CategoryLoadSuccess extends CategoryState {
  final List<Category>? categories;

  const CategoryLoadSuccess({this.categories});

  @override
  List<Object?> get props => [categories];
}
