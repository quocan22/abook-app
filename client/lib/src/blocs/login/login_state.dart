import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginFailure extends LoginState {
  final String errorMessage;
  final String? userId;
  final String? email;
  LoginFailure({required this.errorMessage, this.userId, this.email});

  @override
  List<Object?> get props => [errorMessage, userId, email];
}

class LoginInProgress extends LoginState {}

class LoginSuccess extends LoginState {}
