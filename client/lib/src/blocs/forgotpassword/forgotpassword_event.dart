import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgotRequested extends ForgotPasswordEvent {
  final String emailForgot;

  ForgotRequested(this.emailForgot);

  @override
  List<Object> get props => [emailForgot];
}
