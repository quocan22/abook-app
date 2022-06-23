import 'package:equatable/equatable.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object?> get props => [];
}

class FeedbackInitial extends FeedbackState {}

class FeedbackSendInProgress extends FeedbackState {}

class FeedbackSendFailure extends FeedbackState {
  final String? errorMessage;

  const FeedbackSendFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class FeedbackSendSuccess extends FeedbackState {}
