import 'package:bloc/bloc.dart';

import '../../services/user_service/user_service.dart';
import './verify_event.dart';
import './verify_state.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  final UserService userService;

  VerifyBloc({required this.userService}) : super(VerifyInitial()) {
    on<VerifyRequested>((event, emit) async {
      emit(VerifyInProgress());
      final msg = await userService.verifyOTP(event.userId, event.otp);
      if (msg == 'Your account has been activate successfully') {
        emit(VerifySuccess(email: event.email));
      } else {
        emit(VerifyFailure(errorMessage: msg));
      }
    });

    on<VerifyResendOTPRequested>((event, emit) async {
      emit(VerifyInProgress());
      final res = await userService.resendOTP(event.email);
      String msg = res['msg'];
      if (msg == 'Verification otp email sent') {
        emit(VerifyInitial(email: event.email, userId: res['data']['userId']));
      } else {
        emit(VerifyFailure(errorMessage: msg));
      }
    });

    on<VerifyStateReseted>((event, emit) {
      emit(VerifyInitial());
    });
  }
}
