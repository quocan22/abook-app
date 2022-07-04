import 'package:bloc/bloc.dart';

import '../../services/user_service/user_service.dart';
import './signup_event.dart';
import './signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserService userService;

  SignupBloc({required this.userService}) : super(SignupInitial()) {
    on<SignupRequested>((event, emit) async {
      emit(SignupInProgress());
      final res = await userService.register(
        event.email,
        event.password,
        event.fullName,
      );
      String msg = res['msg'];
      if (msg == 'Verification otp email sent') {
        emit(SignupSuccess(email: event.email, userId: res['data']['userId']));
      } else if (msg == "This email already existed") {
        emit(SignupFailure(errorMessage: msg, email: event.email));
      } else {
        emit(SignupFailure(errorMessage: msg));
      }
    });

    on<SignupStateReseted>((event, emit) {
      emit(SignupInitial());
    });
  }
}
