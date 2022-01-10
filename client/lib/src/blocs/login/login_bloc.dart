import 'package:bloc/bloc.dart';
import 'package:client/src/services/user_service/user_service.dart';

import './login_event.dart';
import './login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserService userService;

  LoginBloc({required this.userService}) : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(LoginInProgress());
      final msg = await userService.login(event.email, event.password);
      if (msg == 'Login successfully') {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(errorMessage: msg));
      }
    });
  }
}
