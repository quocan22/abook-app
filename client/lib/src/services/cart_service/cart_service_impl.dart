import 'package:dio/dio.dart' as dio;

import '../../config/app_constants.dart';
import './cart_service.dart';

class CartServiceImpl implements CartService {
  final dio.Dio dioClient;

  CartServiceImpl({required this.dioClient});

  @override
  Future<String> createCart(String userId) async {
    final uri = Uri.http(AppConstants.HOST_NAME, '/api/carts');

    try {
      dio.Response response =
          await dioClient.post(uri.toString(), data: {'userId': userId});

      if (response.statusCode == 200) {
        return response.data;
        // print(responseMsg);
        // return responseMsg;
      } else {
        throw Exception('Error when createCart');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
