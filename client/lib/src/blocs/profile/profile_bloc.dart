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
        if (event.isProfileImageRemoved) {
          String defaultAvaUrl =
              await userService.removeProfileImage(event.userId);
          await userService.updateProfile(event.userId, event.fullName,
              event.address, event.phoneNumber, null);
          emit(ProfileUpdateSuccess(avatarUrl: defaultAvaUrl));
        } else {
          if (event.profileImage == null) {
            await userService.updateProfile(event.userId, event.fullName,
                event.address, event.phoneNumber, null);
            emit(ProfileUpdateSuccess());
          } else {
            String? avaUrl = await userService.updateProfile(
                event.userId,
                event.fullName,
                event.address,
                event.phoneNumber,
                event.profileImage);
            emit(ProfileUpdateSuccess(avatarUrl: avaUrl));
          }
        }
      } catch (e) {
        emit(ProfileUpdateFailure(errorMessage: e.toString()));
      }
    });
    on<ProfilePasswordChanged>((event, emit) async {
      emit(ProfileUpdateInProgress());
      try {
        String msg = await userService.changePassword(
            event.userId, event.oldPassword, event.newPassword);
        if (msg == 'Change password successfully') {
          emit(ProfileUpdateSuccess());
        } else {
          emit(ProfileUpdateSuccess(msg: msg));
        }
      } catch (e) {
        emit(ProfileUpdateFailure(errorMessage: e.toString()));
      }
    });
  }
}
