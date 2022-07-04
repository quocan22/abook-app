import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileUpdated extends ProfileEvent {
  final String userId;
  final String fullName;
  final String address;
  final String phoneNumber;
  final bool isProfileImageRemoved;
  final File? profileImage;

  ProfileUpdated(
      {required this.fullName,
      required this.address,
      required this.phoneNumber,
      required this.userId,
      required this.isProfileImageRemoved,
      this.profileImage});

  @override
  List<Object?> get props => [
        userId,
        fullName,
        phoneNumber,
        address,
        isProfileImageRemoved,
        profileImage
      ];
}

class ProfilePasswordChanged extends ProfileEvent {
  final String userId;
  final String oldPassword;
  final String newPassword;

  ProfilePasswordChanged(
      {required this.oldPassword,
      required this.newPassword,
      required this.userId});

  @override
  List<Object?> get props => [userId, oldPassword, newPassword];
}
