import 'package:dio/dio.dart' as dio;

import '../../models/address_book.dart';
import '../../models/order.dart';

abstract class OrderService {
  final dio.Dio dioClient;

  OrderService({required this.dioClient});

  Future<List<Order>>? getOrderListByUserId(String userId);
  Future<String> createNewOrder(
      String userId, int discountPrice, AddressBook address);
}
