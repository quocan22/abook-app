import 'package:dio/dio.dart' as dio;
import 'package:global_configuration/global_configuration.dart';

import './feedback_service.dart';

class FeedbackServiceImpl implements FeedbackService {
  final dio.Dio dioClient;

  FeedbackServiceImpl({required this.dioClient});

  @override
  Future<String> sendFeedback(String email, String feedback) async {
    final uri = Uri.https(GlobalConfiguration().getValue('HOST_NAME'),
        GlobalConfiguration().getValue('FEEDBACK'));

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
