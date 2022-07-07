import 'package:dio/dio.dart' as dio;
import 'package:global_configuration/global_configuration.dart';

import '../../models/discount.dart';
import './discount_service.dart';

class DiscountServiceImpl implements DiscountService {
  final dio.Dio dioClient;

  DiscountServiceImpl({required this.dioClient});

  @override
  Future<List<Discount>>? getAllDiscount() async {
    final uri = Uri.https(GlobalConfiguration().getValue('HOST_NAME'),
        GlobalConfiguration().getValue('DISCOUNTS'));

    try {
      dio.Response response = await dioClient.get(uri.toString());

      if (response.statusCode == 200) {
        Iterable responseData = response.data['data'];
        var discounts = List<Discount>.from(
            responseData.map((model) => Discount.fromJson(model)));

        return discounts;
      } else {
        throw Exception('Error when fetching data');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
