import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    on<BookAddedFav>((event, emit) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('id');
        await service.addBookToFav(event.bookId, userId!);
      } catch (e) {}
    });
    on<BookRemovedFav>((event, emit) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('id');
        await service.removeBookFromFav(event.bookId, userId!);
      } catch (e) {}
    });
  }
}
