import 'package:dio/dio.dart' as dio;

abstract class CartService {
  final dio.Dio dioClient;

  CartService({required this.dioClient});

  Future<dynamic> getCartDetailByUserId(String userId);
  Future<String> addBookToCart(String userId, String bookId, int quantity);
  Future<String> removeBookFromCart(String userId, String bookId);
  Future<String> changeBookQuantity(
      String userId, String bookId, int newQuantity);
}
