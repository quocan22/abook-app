import 'package:dio/dio.dart' as dio;

import '../../config/app_constants.dart';
import './chatbot_service.dart';

class ChatbotServiceImpl implements ChatbotService {
  final dio.Dio dioClient;

  ChatbotServiceImpl({required this.dioClient});

  @override
  Future<dynamic> sendMessage(String message) async {
    final uri = Uri.https(AppConstants.HOST_NAME, '/api/chatbot/text_query');

    try {
      dio.Response response =
          await dioClient.post(uri.toString(), data: {'text': message});

      if (response.statusCode == 200) {
        return response.data;
        // print(responseMsg);
        // return responseMsg;
      } else {
        throw Exception('Error when send message chatbot');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<dynamic> sendEvent(String eventName) async {
    final uri = Uri.https(AppConstants.HOST_NAME, '/api/chatbot/event_query');

    try {
      dio.Response response =
          await dioClient.post(uri.toString(), data: {'event': eventName});

      if (response.statusCode == 200) {
        return response.data;
        // print(responseMsg);
        // return responseMsg;
      } else {
        throw Exception('Error when send event chatbot');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
