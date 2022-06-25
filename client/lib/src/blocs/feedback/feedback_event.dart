import 'package:equatable/equatable.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object?> get props => [];
}

class FeedbackSent extends FeedbackEvent {
  final String email;
  final String feedback;

  FeedbackSent({required this.email, required this.feedback});

  @override
  List<Object?> get props => [];
}
