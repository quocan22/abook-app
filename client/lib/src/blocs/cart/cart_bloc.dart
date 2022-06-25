import 'package:bloc/bloc.dart';

import '../../services/cart_service/cart_service.dart';
import './cart_event.dart';
import './cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService service;

  CartBloc({required this.service}) : super(CartInitial()) {
    on<CartDetailRequested>((event, emit) async {
      emit(CartLoadInProgress());
      try {
        List<dynamic>? jsonDetail =
            await service.getCartDetailByUserId(event.userId);

        emit(CartLoadSuccess(cartDetailList: jsonDetail));
      } catch (e) {
        emit(CartLoadFailure(errorMessage: e.toString()));
      }
    });
    on<CartBookAdded>((event, emit) async {
      emit(CartLoadInProgress());
      try {
        String? msg = await service.addBookToCart(
            event.userId, event.bookId, event.quantity);

        if (msg == 'Add boook to cart successfully') {
          emit(CartLoadSuccess(
              cartDetailList:
                  await service.getCartDetailByUserId(event.userId)));
        } else {
          emit(CartLoadFailure(errorMessage: 'Add book to cart failed'));
        }
      } catch (e) {
        emit(CartLoadFailure(errorMessage: e.toString()));
      }
    });
    on<CartBookQuantityChanged>((event, emit) async {
      emit(CartLoadInProgress());
      try {
        String? msg = await service.changeBookQuantity(
            event.userId, event.bookId, event.newQuantity);

        if (msg == 'Change quantity successfully') {
          emit(CartLoadSuccess(
              cartDetailList:
                  await service.getCartDetailByUserId(event.userId)));
        } else {
          emit(CartLoadFailure(errorMessage: 'Add book to cart failed'));
        }
      } catch (e) {
        emit(CartLoadFailure(errorMessage: e.toString()));
      }
    });
  }
}
