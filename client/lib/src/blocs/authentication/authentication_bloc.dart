import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './authentication_event.dart';
import './authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationLoaded>(_onLoaded);
    on<AuthenticationLoggedOut>(_onLoggedOut);
  }

  _onLoaded(AuthenticationLoaded event, Emitter emit) async {
    final isSignIn = await _checkToken();

    if (isSignIn) {
      emit(AuthenticationSuccess());
    } else {
      emit(AuthenticationFailure());
    }
  }

  _onLoggedOut(AuthenticationLoggedOut event, Emitter emit) async {
    await _signOut();
    emit(AuthenticationFailure());
  }

  Future<bool> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    if (token == null) {
      return;
    } else {
      prefs.remove('accessToken');
      prefs.remove('id');
      return true;
    }
  }
}
