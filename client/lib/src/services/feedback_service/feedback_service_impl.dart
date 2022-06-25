import 'package:dio/dio.dart' as dio;

import '../../config/app_constants.dart';
import './feedback_service.dart';

class FeedbackServiceImpl implements FeedbackService {
  final dio.Dio dioClient;

  FeedbackServiceImpl({required this.dioClient});

  @override
  Future<String> sendFeedback(String email, String feedback) async {
    final uri = Uri.http(AppConstants.HOST_NAME, '/api/feedbacks');

    try {
      dio.Response response = await dioClient
          .post(uri.toString(), data: {'email': email, 'content': feedback});

      if (response.statusCode == 202) {
        String responseMsg = response.data['msg'];

        return responseMsg;
      } else {
        throw Exception('Error when send feedback');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
