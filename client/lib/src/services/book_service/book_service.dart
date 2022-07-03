import 'package:dio/dio.dart' as dio;

import '../../models/book.dart';

abstract class BookService {
  final dio.Dio dioClient;

  BookService({required this.dioClient});

  Future<List<Book>>? fetchBookList();
  Future<List<Book>>? fetchBookListByCategoryId(String categoryId);
  Future<String> addBookToFav(String bookId, String userId);
  Future<String> removeBookFromFav(String bookId, String userId);
  Future<Book>? getBookDetailById(String bookId);
  Future<String> sendRateAndComment(
      String bookId, String userId, int rate, String review);
}
