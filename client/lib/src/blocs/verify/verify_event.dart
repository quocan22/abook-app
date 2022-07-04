import 'package:equatable/equatable.dart';

abstract class VerifyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class VerifyRequested extends VerifyEvent {
  final String userId;
  final String email;
  final String otp;

  VerifyRequested(
      {required this.userId, required this.otp, required this.email});
  @override
  List<Object> get props => [userId, otp];
}

class VerifyResendOTPRequested extends VerifyEvent {
  final String email;

  VerifyResendOTPRequested({required this.email});
  @override
  List<Object> get props => [email];
}

class VerifyStateReseted extends VerifyEvent {}
