import 'package:bloc/bloc.dart';

import './signup_event.dart';
import './signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupRequested>((event, emit) async {});

    on<SignupStateReseted>((event, emit) {
      emit(SignupInitial());
    });
  }
}
