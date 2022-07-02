import 'package:dio/dio.dart' as dio;

import '../../models/address_book.dart';
import '../../config/app_constants.dart';
import '../../models/order.dart';
import './order_service.dart';

class OrderServiceImpl implements OrderService {
  final dio.Dio dioClient;

  OrderServiceImpl({required this.dioClient});

  @override
  Future<List<Order>> getOrderListByUserId(String userId) async {
    final uri = Uri.https(AppConstants.HOST_NAME, '/api/orders/get_by_user_id');

    try {
      dio.Response response =
          await dioClient.post(uri.toString(), data: {'userId': userId});

      if (response.statusCode == 200) {
        Iterable responseData = response.data['data'];
        var orders = List<Order>.from(
            responseData.map((model) => Order.fromJson(model)));

        return orders;
      } else {
        throw Exception('Error when get orders list');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> createNewOrder(
      String userId, int discountPrice, AddressBook address) async {
    final uri = Uri.https(AppConstants.HOST_NAME, '/api/orders');

    try {
      dio.Response response = await dioClient.post(uri.toString(), data: {
        "userId": userId,
        "discountPrice": discountPrice,
        "address": address.toJson()
      });

      if (response.statusCode == 200) {
        return response.data['msg'];
      } else {
        throw Exception('Error when create new order');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
