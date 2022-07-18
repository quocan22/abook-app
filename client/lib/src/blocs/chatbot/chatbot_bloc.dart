import 'package:bloc/bloc.dart';

import '../../models/book.dart';
import '../../models/category.dart';
import '../../models/message.dart';
import '../../services/chatbot_service/chatbot_service.dart';
import './chatbot_event.dart';
import './chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ChatbotService service;
  late List<Message> listMgs = [];
  bool isChanged = true;

  ChatbotBloc({required this.service}) : super(ChatbotInitial()) {
    on<ChatbotMessageSent>((event, emit) async {
      isChanged = !isChanged;
      listMgs.add(Message(type: 1, text: event.msg, isYourMsg: true));
      try {
        Map<String, dynamic>? jsonRes = await service.sendMessage(event.msg);
        Map<String, dynamic> responseJson = jsonRes!;
        int? type = responseJson['type'];
        if (type == 1) {
          listMgs.add(Message(type: 1, text: responseJson['text']));
        } else if (type == 2) {
          listMgs.add(Message(
              type: 2,
              text: responseJson['text'],
              listBook: List<Book>.from(
                  responseJson['data'].map((model) => Book.fromJson(model)))));
        } else {
          listMgs.add(Message(
              type: 3,
              text: responseJson['text'],
              listCategory: List<Category>.from(responseJson['data']
                  .map((model) => Category.fromJson(model)))));
        }

        emit(ChatbotLoadSuccess(msgList: listMgs, isChanged: isChanged));
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
        listMgs.add(Message(type: 1, text: responseJson['text']));
        emit(ChatbotLoadSuccess(msgList: listMgs, isChanged: true));
      } catch (e) {
        emit(ChatbotLoadFailure(errorMessage: e.toString()));
      }
    });
    on<ChatbotStateReset>((event, emit) async {
      listMgs.clear();
      emit(ChatbotLoadSuccess(msgList: listMgs, isChanged: true));
    });
  }
}
