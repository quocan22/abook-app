import 'package:dio/dio.dart' as dio;
import 'package:global_configuration/global_configuration.dart';

import './cart_service.dart';

class CartServiceImpl implements CartService {
  final dio.Dio dioClient;

  CartServiceImpl({required this.dioClient});

  @override
  Future<dynamic> getCartDetailByUserId(String userId) async {
    final uri = Uri.https(GlobalConfiguration().getValue('HOST_NAME'),
        GlobalConfiguration().getValue('CART_DETAIL'));

    try {
      dio.Response response = await dioClient
          .get(uri.toString(), queryParameters: {'userId': userId});

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Error when get cart detail');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> addBookToCart(
      String userId, String bookId, int quantity) async {
    final uri = Uri.https(GlobalConfiguration().getValue('HOST_NAME'),
        GlobalConfiguration().getValue('ADD_BOOK_TO_CART'));

    try {
      dio.Response response = await dioClient.patch(uri.toString(),
          queryParameters: {'userId': userId},
          data: {'bookId': bookId, 'quantity': quantity});

      if (response.statusCode == 200) {
        return response.data['msg'];
      } else {
        throw Exception('Error when add book to cart');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> removeBookFromCart(String userId, String bookId) async {
    final uri = Uri.https(GlobalConfiguration().getValue('HOST_NAME'),
        GlobalConfiguration().getValue('REMOVE_BOOK_FROM_CART'));

    try {
      dio.Response response = await dioClient.post(uri.toString(),
          queryParameters: {'userId': userId}, data: {'bookId': bookId});

      if (response.statusCode == 200) {
        return response.data['msg'];
      } else {
        throw Exception('Error when remove book from cart');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> changeBookQuantity(
      String userId, String bookId, int newQuantity) async {
    final uri = Uri.https(GlobalConfiguration().getValue('HOST_NAME'),
        GlobalConfiguration().getValue('CART_CHANGE_BOOK_QUANTITY'));

    try {
      dio.Response response = await dioClient.patch(uri.toString(),
          queryParameters: {'userId': userId},
          data: {'bookId': bookId, 'newQuantity': newQuantity});

      if (response.statusCode == 200) {
        return response.data['msg'];
      } else {
        throw Exception('Error when add book to cart');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
