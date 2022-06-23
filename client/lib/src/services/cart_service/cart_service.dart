import 'package:dio/dio.dart' as dio;

abstract class CartService {
  final dio.Dio dioClient;

  CartService({required this.dioClient});

  Future<String> createCart(String userId);
}
