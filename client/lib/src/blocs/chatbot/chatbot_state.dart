import 'package:equatable/equatable.dart';

import '../../models/message.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object?> get props => [];
}

class ChatbotInitial extends ChatbotState {}

class ChatbotLoadInProgress extends ChatbotState {}

class ChatbotLoadFailure extends ChatbotState {
  final String? errorMessage;

  const ChatbotLoadFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class ChatbotLoadSuccess extends ChatbotState {
  final List<Message>? msgList;
  final bool isChanged;

  const ChatbotLoadSuccess({this.msgList, required this.isChanged});

  @override
  List<Object?> get props => [msgList, isChanged];
}
