import 'package:bloc/bloc.dart';

import '../../models/user.dart';
import '../../services/user_service/user_service.dart';
import './user_claim_event.dart';
import './user_claim_state.dart';

class UserClaimBloc extends Bloc<UserClaimEvent, UserClaimState> {
  final UserService userService;

  UserClaimBloc({required this.userService}) : super(UserClaimInitial()) {
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
  }
}
