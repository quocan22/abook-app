import 'package:bloc/bloc.dart';

import '../../models/book.dart';
import '../../services/book_service/book_service.dart';
import './book_event.dart';
import './book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookService service;

  BookBloc({required this.service}) : super(BookInitial()) {
    on<BookRequested>((event, emit) async {
      emit(BookLoadInProgress());
      try {
        List<Book>? books = await service.fetchBookList();
        if (books != null) {
          books.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        }
        emit(BookLoadSuccess(books: books));
      } catch (e) {
        emit(BookLoadFailure(errorMessage: e.toString()));
      }
    });
  }
}
