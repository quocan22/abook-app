import 'package:equatable/equatable.dart';

abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object?> get props => [];
}

class ChatbotMessageSent extends ChatbotEvent {
  final String msg;

  ChatbotMessageSent({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class ChatbotEventSent extends ChatbotEvent {
  final String eventName;

  ChatbotEventSent({required this.eventName});

  @override
  List<Object?> get props => [eventName];
}

class ChatbotStateReset extends ChatbotEvent {}
