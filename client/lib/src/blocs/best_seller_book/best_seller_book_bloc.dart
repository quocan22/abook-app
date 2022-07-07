import 'package:bloc/bloc.dart';

import '../../models/book.dart';
import '../../services/book_service/book_service.dart';
import './best_seller_book_event.dart';
import './best_seller_book_state.dart';

class BestSellerBookBloc
    extends Bloc<BestSellerBookEvent, BestSellerBookState> {
  final BookService service;

  BestSellerBookBloc({required this.service}) : super(BestSellerBookInitial()) {
    on<BestSellerBookRequested>((event, emit) async {
      emit(BestSellerBookLoadInProgress());
      try {
        List<Book>? books = await service.getBestSellerBookList();

        emit(BestSellerBookLoadSuccess(bookList: books));
      } catch (e) {
        emit(BestSellerBookLoadFailure(errorMessage: e.toString()));
      }
    });
  }
}
