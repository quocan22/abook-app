import 'package:dio/dio.dart' as dio;

abstract class ChatbotService {
  final dio.Dio dioClient;

  ChatbotService({required this.dioClient});

  Future<dynamic> sendMessage(String message);
}
