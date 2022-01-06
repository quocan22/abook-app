import 'package:client/src/config/app_constants.dart';
import 'package:dio/dio.dart' as dio;

import '../../models/book.dart';
import './book_service.dart';

class BookServiceImpl implements BookService {
  final dio.Dio dioClient;

  BookServiceImpl({required this.dioClient});

  @override
  Future<List<Book>> fetchBookList() async {
    final uri = Uri.http(AppConstants.HOST_NAME, AppConstants.BOOKS);

    try {
      dio.Response response = await dioClient.get(uri.toString());

      if (response.statusCode == 200) {
        Iterable responseData = response.data['data'];
        var books =
            List<Book>.from(responseData.map((model) => Book.fromJson(model)));

        return books;
      } else {
        throw Exception('Error when fetching data');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Book>>? fetchBookListByCategoryId(String categoryId) async {
    final uri = Uri.http(AppConstants.HOST_NAME, AppConstants.BOOKSBYCATE);

    try {
      dio.Response response = await dioClient
          .get(uri.toString(), queryParameters: {"c": categoryId});

      if (response.statusCode == 200) {
        Iterable responseData = response.data['data'];
        var books =
            List<Book>.from(responseData.map((model) => Book.fromJson(model)));

        return books;
      } else {
        throw Exception('Error when fetching data');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
