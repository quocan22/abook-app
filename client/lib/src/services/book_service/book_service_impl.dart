import 'package:dio/dio.dart' as dio;

import '../../config/app_constants.dart';
import '../../models/book.dart';
import './book_service.dart';

class BookServiceImpl implements BookService {
  final dio.Dio dioClient;

  BookServiceImpl({required this.dioClient});

  @override
  Future<List<Book>> fetchBookList() async {
    final uri = Uri.https(AppConstants.HOST_NAME, AppConstants.BOOKS);

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
    final uri = Uri.https(AppConstants.HOST_NAME, AppConstants.BOOKSBYCATE);

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

  @override
  Future<String> addBookToFav(String bookId, String userId) async {
    final uri = Uri.https(AppConstants.HOST_NAME, AppConstants.ADDFAV);

    try {
      dio.Response response = await dioClient
          .post(uri.toString(), data: {"bookId": bookId, "userId": userId});

      if (response.statusCode == 200) {
        String responseMsg = response.data['msg'];

        return responseMsg;
      } else {
        throw Exception('Error when add fav');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> removeBookFromFav(String bookId, String userId) async {
    final uri = Uri.https(AppConstants.HOST_NAME, AppConstants.REMOVEFAV);

    try {
      dio.Response response = await dioClient
          .post(uri.toString(), data: {"bookId": bookId, "userId": userId});

      if (response.statusCode == 200) {
        String responseMsg = response.data['msg'];

        return responseMsg;
      } else {
        throw Exception('Error when remove fav');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<Book> getBookDetailById(String bookId) async {
    final uri = Uri.https(AppConstants.HOST_NAME, '/api/books');

    try {
      dio.Response response = await dioClient.get(uri.toString() + '/$bookId');

      if (response.statusCode == 200) {
        var book = Book.fromJson(response.data['data']);

        return book;
      } else {
        throw Exception('Error when fetching book data');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> sendRateAndComment(
      String bookId, String userId, int rate, String review) async {
    final uri = Uri.https(AppConstants.HOST_NAME, '/api/books/comment');

    try {
      dio.Response response = await dioClient.patch(uri.toString(), data: {
        "bookId": bookId,
        "userId": userId,
        "rate": rate,
        "review": review
      });

      if (response.statusCode == 200) {
        String responseMsg = response.data['msg'];

        return responseMsg;
      } else {
        throw Exception('Error when send comment');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
