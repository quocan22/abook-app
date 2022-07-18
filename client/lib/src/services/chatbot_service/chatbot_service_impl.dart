import 'package:dio/dio.dart' as dio;
import 'package:global_configuration/global_configuration.dart';
import 'package:easy_localization/easy_localization.dart';

import './chatbot_service.dart';

class ChatbotServiceImpl implements ChatbotService {
  final dio.Dio dioClient;

  ChatbotServiceImpl({required this.dioClient});

  @override
  Future<dynamic> sendMessage(String message) async {
    final uri = Uri.https(GlobalConfiguration().getValue('HOST_NAME'),
        GlobalConfiguration().getValue('CHATBOT_SEND_TEXT'));

    try {
      dio.Response response = await dioClient.post(uri.toString(),
          data: {'text': message, 'languageCode': 'languageCode'.tr()});

      if (response.statusCode == 200) {
        return response.data;
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
    final uri = Uri.https(GlobalConfiguration().getValue('HOST_NAME'),
        GlobalConfiguration().getValue('CHATBOT_SEND_EVENT'));

    try {
      dio.Response response = await dioClient.post(uri.toString(),
          data: {'event': eventName, 'languageCode': 'languageCode'.tr()});

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error when send event chatbot');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
