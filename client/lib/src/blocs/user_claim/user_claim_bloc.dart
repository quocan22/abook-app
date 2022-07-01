import 'package:bloc/bloc.dart';
import 'package:client/src/services/book_service/book_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import '../../services/user_service/user_service.dart';
import './user_claim_event.dart';
import './user_claim_state.dart';

class UserClaimBloc extends Bloc<UserClaimEvent, UserClaimState> {
  final UserService userService;
  final BookService bookService;

  UserClaimBloc({required this.userService, required this.bookService})
      : super(UserClaimInitial()) {
    on<UserClaimRequested>((event, emit) async {
      emit(UserClaimLoadInProgress());
      try {
        UserClaim? userClaims =
            await userService.fetchUserInfoById(event.userId);
        emit(UserClaimLoadSuccess(userClaim: userClaims));
      } catch (e) {
        emit(UserClaimLoadFailure(errorMessage: e.toString()));
      }
    });
    on<BookAddedFav>((event, emit) async {
      emit(UserClaimLoadInProgress());
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('id');
        await bookService.addBookToFav(event.bookId, userId!);
        UserClaim? userClaims = await userService.fetchUserInfoById(userId);
        emit(UserClaimLoadSuccess(userClaim: userClaims));
      } catch (e) {
        emit(UserClaimLoadFailure(errorMessage: e.toString()));
      }
    });
    on<BookRemovedFav>((event, emit) async {
      emit(UserClaimLoadInProgress());
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('id');
        await bookService.removeBookFromFav(event.bookId, userId!);
        UserClaim? userClaims = await userService.fetchUserInfoById(userId);
        emit(UserClaimLoadSuccess(userClaim: userClaims));
      } catch (e) {
        emit(UserClaimLoadFailure(errorMessage: e.toString()));
      }
    });
  }
}
