import 'package:equatable/equatable.dart';

import '../../models/book.dart';
import '../../models/category.dart';

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
  final int? type;
  final String? text;
  final List<Book>? listBook;
  final List<Category>? listCategory;

  const ChatbotLoadSuccess(
      {this.type, this.text, this.listBook, this.listCategory});

  @override
  List<Object?> get props => [type, text, listBook, listCategory];
}
