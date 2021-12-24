import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ResetPasswordSuccess extends ForgotPasswordState {}

class ResetPasswordFailure extends ForgotPasswordState {
  final String? errorMessage;

  ResetPasswordFailure({
    this.errorMessage,
  });

  @override
  List<Object?> get props => [errorMessage];
}
