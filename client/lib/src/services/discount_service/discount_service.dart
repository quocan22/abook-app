import 'package:dio/dio.dart' as dio;

import '../../models/discount.dart';

abstract class DiscountService {
  final dio.Dio dioClient;

  DiscountService({required this.dioClient});

  Future<List<Discount>>? getAllDiscount();
}
