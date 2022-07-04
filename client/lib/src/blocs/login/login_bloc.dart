import 'package:bloc/bloc.dart';

import '../../services/user_service/user_service.dart';
import './login_event.dart';
import './login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserService userService;

  LoginBloc({required this.userService}) : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(LoginInProgress());
      final res = await userService.login(event.email, event.password);
      String msg = res['msg'];
      if (msg == 'Login successfully') {
        emit(LoginSuccess());
      } else if (msg == 'This user has not been activated') {
        emit(LoginFailure(
            errorMessage: msg,
            userId: res['data']['userId'],
            email: res['data']['email']));
      } else {
        emit(LoginFailure(errorMessage: msg));
      }
    });
    on<LoginStateReseted>((event, emit) async {
      emit(LoginInitial());
    });
  }
}
