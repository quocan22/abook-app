import 'package:bloc/bloc.dart';

import '../../models/category.dart';
import '../../services/category_service/category_service.dart';
import './category_event.dart';
import './category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryService service;

  CategoryBloc({required this.service}) : super(CategoryInitial()) {
    on<CategoryRequested>((event, emit) async {
      emit(CategoryLoadInProgress());
      try {
        List<Category>? categories = await service.fetchCategoryList();
        // if (Categorys != null) {
        //   Categorys.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        // }
        emit(CategoryLoadSuccess(categories: categories));
      } catch (e) {
        emit(CategoryLoadFailure(errorMessage: e.toString()));
      }
    });
  }
}
