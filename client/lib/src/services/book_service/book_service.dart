import 'package:dio/dio.dart' as dio;

import '../../models/book.dart';

abstract class BookService {
  final dio.Dio dioClient;

  BookService({required this.dioClient});

  Future<List<Book>>? fetchBookList();
  Future<List<Book>>? fetchBookListByCategoryId(String categoryId);
}
