import 'package:equatable/equatable.dart';

abstract class UserClaimEvent extends Equatable {
  const UserClaimEvent();

  @override
  List<Object?> get props => [];
}

class UserClaimRequested extends UserClaimEvent {
  final String userId;

  UserClaimRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}
