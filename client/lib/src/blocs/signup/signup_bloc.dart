import 'package:bloc/bloc.dart';
import 'package:client/src/services/user_service/user_service.dart';

import './signup_event.dart';
import './signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserService userService;

  SignupBloc({required this.userService}) : super(SignupInitial()) {
    on<SignupRequested>((event, emit) async {
      emit(SignupInProgress());
      final msg = await userService.register(
        event.email,
        event.password,
        event.fullName,
      );
      if (msg == "Register successfully!") {
        emit(SignupSuccess(email: event.email));
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
