import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileUpdateInProgress extends ProfileState {}

class ProfileUpdateFailure extends ProfileState {
  final String? errorMessage;

  const ProfileUpdateFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class ProfileUpdateSuccess extends ProfileState {
  final String? avatarUrl;
  final String? msg;

  const ProfileUpdateSuccess({this.avatarUrl, this.msg});

  @override
  List<Object?> get props => [avatarUrl, msg];
}
