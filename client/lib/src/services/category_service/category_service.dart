import 'package:dio/dio.dart' as dio;

import '../../models/category.dart';

abstract class CategoryService {
  final dio.Dio dioClient;

  CategoryService({required this.dioClient});

  Future<List<Category>>? fetchCategoryList();
}
