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

  ProfileUpdated(
      {required this.fullName,
      required this.address,
      required this.phoneNumber,
      required this.userId});

  @override
  List<Object?> get props => [userId, fullName, phoneNumber, address];
}
