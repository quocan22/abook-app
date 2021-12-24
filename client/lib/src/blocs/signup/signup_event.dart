import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignupRequested extends SignupEvent {
  final String email;
  final String password;
  final String fullName;

  SignupRequested(this.email, this.password, this.fullName);
  @override
  List<Object> get props => [email, password, fullName];
}

class SignupStateReseted extends SignupEvent {}
