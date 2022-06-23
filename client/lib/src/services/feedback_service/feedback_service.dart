import 'package:dio/dio.dart' as dio;

abstract class FeedbackService {
  final dio.Dio dioClient;

  FeedbackService({required this.dioClient});

  Future<String> sendFeedback(String email, String feedback);
}
