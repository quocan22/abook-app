import 'package:bloc/bloc.dart';

import '../../models/book.dart';
import '../../models/category.dart';
import '../../services/chatbot_service/chatbot_service.dart';
import './chatbot_event.dart';
import './chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ChatbotService service;

  ChatbotBloc({required this.service}) : super(ChatbotInitial()) {
    on<ChatbotMessageSent>((event, emit) async {
      emit(ChatbotLoadInProgress());
      try {
        Map<String, dynamic>? jsonRes = await service.sendMessage(event.msg);
        Map<String, dynamic> responseJson = jsonRes!;
        int? type = responseJson['type'];
        if (type == 1) {
          emit(ChatbotLoadSuccess(type: 1, text: responseJson['text']));
        } else if (type == 2) {
          emit(ChatbotLoadSuccess(
              type: 2,
              text: responseJson['text'],
              listBook: List<Book>.from(
                  responseJson['data'].map((model) => Book.fromJson(model)))));
        } else {
          emit(ChatbotLoadSuccess(
              type: 3,
              text: responseJson['text'],
              listCategory: List<Category>.from(responseJson['data']
                  .map((model) => Category.fromJson(model)))));
        }
      } catch (e) {
        emit(ChatbotLoadFailure(errorMessage: e.toString()));
      }
    });
    on<ChatbotEventSent>((event, emit) async {
      emit(ChatbotLoadInProgress());
      try {
        Map<String, dynamic>? jsonRes =
            await service.sendEvent(event.eventName);
        Map<String, dynamic> responseJson = jsonRes!;
        emit(ChatbotLoadSuccess(type: 1, text: responseJson['text']));
      } catch (e) {
        emit(ChatbotLoadFailure(errorMessage: e.toString()));
      }
    });
  }
}
