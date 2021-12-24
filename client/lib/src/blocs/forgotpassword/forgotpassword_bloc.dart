import 'package:bloc/bloc.dart';

import './forgotpassword_event.dart';
import './forgotpassword_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotRequested>((event, emit) async {});
  }
}
