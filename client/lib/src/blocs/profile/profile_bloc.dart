import 'package:bloc/bloc.dart';

import '../../services/user_service/user_service.dart';
import './profile_event.dart';
import './profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserService userService;

  ProfileBloc({required this.userService}) : super(ProfileInitial()) {
    on<ProfileUpdated>((event, emit) async {
      emit(ProfileUpdateInProgress());
      try {
        await userService.updateProfile(
            event.userId, event.fullName, event.address, event.phoneNumber);
        emit(ProfileUpdateSuccess());
      } catch (e) {
        emit(ProfileUpdateFailure(errorMessage: e.toString()));
      }
    });
  }
}
