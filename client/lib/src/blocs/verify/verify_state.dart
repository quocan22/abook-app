import 'package:equatable/equatable.dart';

abstract class VerifyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyInitial extends VerifyState {
  final String? userId;
  final String? email;

  VerifyInitial({this.email, this.userId});

  @override
  List<Object?> get props => [email, userId];
}

class VerifyInProgress extends VerifyState {}

class VerifySuccess extends VerifyState {
  final String email;

  VerifySuccess({required this.email});

  @override
  List<Object?> get props => [email];
}

class VerifyFailure extends VerifyState {
  final String? errorMessage;

  VerifyFailure({
    this.errorMessage,
  });

  @override
  List<Object?> get props => [errorMessage];
}
