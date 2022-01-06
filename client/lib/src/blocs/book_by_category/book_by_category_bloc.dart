import 'package:bloc/bloc.dart';

import '../../models/book.dart';
import '../../services/book_service/book_service.dart';
import './book_by_category_event.dart';
import './book_by_category_state.dart';

class BookByCategoryBloc
    extends Bloc<BookByCategoryEvent, BookByCategoryState> {
  final BookService service;

  BookByCategoryBloc({required this.service}) : super(BookByCategoryInitial()) {
    on<BookListByCategoryIdRequested>((event, emit) async {
      emit(BookByCategoryLoadInProgress());
      try {
        List<Book>? books =
            await service.fetchBookListByCategoryId(event.categoryId);
        if (books != null) {
          books.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        }
        emit(BookByCategoryLoadSuccess(books: books));
      } catch (e) {
        emit(BookByCategoryLoadFailure(errorMessage: e.toString()));
      }
    });
  }
}
