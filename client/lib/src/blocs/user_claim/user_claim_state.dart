import 'package:equatable/equatable.dart';

import '../../models/user.dart';

abstract class UserClaimState extends Equatable {
  const UserClaimState();

  @override
  List<Object?> get props => [];
}

class UserClaimInitial extends UserClaimState {}

class UserClaimLoadInProgress extends UserClaimState {}

class UserClaimLoadFailure extends UserClaimState {
  final String? errorMessage;

  const UserClaimLoadFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class UserClaimLoadSuccess extends UserClaimState {
  final UserClaim? userClaim;

  const UserClaimLoadSuccess({this.userClaim});

  @override
  List<Object?> get props => [userClaim];
}
