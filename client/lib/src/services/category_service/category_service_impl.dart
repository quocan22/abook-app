import 'package:dio/dio.dart' as dio;
import 'package:global_configuration/global_configuration.dart';

import '../../models/category.dart';
import './category_service.dart';

class CategoryServiceImpl implements CategoryService {
  final dio.Dio dioClient;

  CategoryServiceImpl({required this.dioClient});

  @override
  Future<List<Category>>? fetchCategoryList() async {
    final uri = Uri.https(GlobalConfiguration().getValue('HOST_NAME'),
        GlobalConfiguration().getValue('CATEGORIES'));

    try {
      dio.Response response = await dioClient.get(uri.toString());

      if (response.statusCode == 200) {
        Iterable responseData = response.data['data'];
        var categories = List<Category>.from(
            responseData.map((model) => Category.fromJson(model)));

        return categories;
      } else {
        throw Exception('Error when fetching data');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
