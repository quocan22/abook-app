import 'package:bloc/bloc.dart';

import '../../models/book.dart';
import '../../models/user.dart';
import '../../services/book_service/book_service.dart';
import '../../services/user_service/user_service.dart';
import './book_detail_event.dart';
import './book_detail_state.dart';

class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState> {
  final BookService service;
  final UserService userService;

  BookDetailBloc({required this.service, required this.userService})
      : super(BookDetailInitial()) {
    on<BookDetailRequestedById>((event, emit) async {
      emit(BookDetailLoadInProgress());
      try {
        Book? book = await service.getBookDetailById(event.bookId);
        if (book!.comments.isNotEmpty) {
          for (var item in book.comments) {
            UserClaim? userClaim =
                await userService.fetchUserInfoById(item['userId']);
            item['displayName'] = userClaim!.displayName;
            item['avatarUrl'] = userClaim.avatarUrl;
          }
        }
        emit(BookDetailLoadSuccess(book: book));
      } catch (e) {
        emit(BookDetailLoadFailure(errorMessage: e.toString()));
      }
    });

    on<BookSentComment>((event, emit) async {
      emit(BookDetailLoadInProgress());
      try {
        await service.sendRateAndComment(
            event.bookId, event.userId, event.rate, event.review);
        Book? book = await service.getBookDetailById(event.bookId);
        emit(BookDetailLoadSuccess(book: book));
      } catch (e) {
        emit(BookDetailLoadFailure(errorMessage: e.toString()));
      }
    });
  }
}
