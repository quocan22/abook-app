import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_constants.dart';
import '../../models/address_book.dart';
import '../../models/user.dart';
import './user_service.dart';

class UserServiceImpl implements UserService {
  final dio.Dio dioClient;

  UserServiceImpl({required this.dioClient});

  @override
  Future<UserClaim> fetchUserInfoById(String userId) async {
    final uri =
        Uri.https(AppConstants.HOST_NAME, '${AppConstants.USERS}/$userId');

    try {
      dio.Response response = await dioClient.get(uri.toString());

      if (response.statusCode == 200) {
        var responseData = response.data['data'];
        UserClaim userClaim = UserClaim.fromJson(responseData);

        return userClaim;
      } else {
        throw Exception('Error when fetching data');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<dynamic> login(String email, String password) async {
    final uri = Uri.https(AppConstants.HOST_NAME, AppConstants.LOGIN);

    try {
      dio.Response response = await dioClient
          .post(uri.toString(), data: {'email': email, 'password': password});

      if (response.statusCode == 200) {
        var responseData = response.data['data'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', responseData['accessToken']);
        await prefs.setString('id', responseData['id']);

        return response.data;
      } else {
        throw Exception('Error when login');
      }
    } catch (e) {
      print(e.toString());
      dio.DioError dioError = e as dio.DioError;
      if (dioError.response?.statusCode == 404) {
        return dioError.response!.data;
      } else if (dioError.response?.statusCode == 403) {
        return dioError.response!.data;
      } else if (dioError.response?.statusCode == 400) {
        return dioError.response!.data;
      } else
        throw Exception(e.toString());
    }
  }

  @override
  Future<dynamic> register(
      String email, String password, String fullName) async {
    final uri = Uri.https(AppConstants.HOST_NAME, AppConstants.REGISTERUSER);

    try {
      dio.Response response = await dioClient.post(uri.toString(), data: {
        'email': email,
        'password': password,
        'userClaim': {'displayName': fullName}
      });

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 402) {
        return response.data;
      }
      {
        throw Exception('Error when register new user');
      }
    } catch (e) {
      dio.DioError dioError = e as dio.DioError;
      if (dioError.message == 'Http status error [402]') {
        return dioError.response!.data;
      } else if (dioError.message == 'This email already existed') {
        return dioError.response!.data;
      } else
        throw Exception(e.toString());
    }
  }

  @override
  Future<String> verifyOTP(String userId, String otp) async {
    final uri = Uri.https(AppConstants.HOST_NAME, '/api/activate/verify_otp');

    try {
      dio.Response response = await dioClient
          .post(uri.toString(), data: {"userId": userId, "otp": otp});

      if (response.statusCode == 200) {
        return response.data['msg'];
      } else {
        throw Exception('Error when register new user');
      }
    } catch (e) {
      dio.DioError dioError = e as dio.DioError;
      if (dioError.message == 'Http status error [404]') {
        return dioError.message;
      } else
        throw Exception(e.toString());
    }
  }

  @override
  Future<dynamic> resendOTP(String email) async {
    final uri =
        Uri.https(AppConstants.HOST_NAME, '/api/activate/resend_verify_code');

    try {
      dio.Response response =
          await dioClient.post(uri.toString(), data: {"email": email});

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error when register new user');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> updateProfile(String userId, String fullName, String address,
      String phoneNumber, File? image) async {
    final uri =
        Uri.https(AppConstants.HOST_NAME, '${AppConstants.USERS}/$userId');
    dio.FormData formData;
    try {
      if (image != null) {
        String fileName = image.path.split('/').last;
        formData = dio.FormData.fromMap({
          "image":
              await dio.MultipartFile.fromFile(image.path, filename: fileName)
        });
        dio.Response response =
            await dioClient.put(uri.toString(), data: formData);

        if (response.statusCode == 200) {
          String responseAvaUrl =
              response.data['data']['userClaim']['avatarUrl'];
          dio.Response responseProfileDetail = await dioClient
              .put(uri.toString(), data: {
            "displayName": fullName,
            "address": address,
            "phoneNumber": phoneNumber
          });

          if (responseProfileDetail.statusCode == 200) {
            return responseAvaUrl;
          } else {
            throw Exception('Error when update info');
          }
        } else {
          throw Exception('Error when update info');
        }
      } else {
        dio.Response responseProfileDetail = await dioClient.put(uri.toString(),
            data: {
              "displayName": fullName,
              "address": address,
              "phoneNumber": phoneNumber
            });

        if (responseProfileDetail.statusCode == 200) {
          return responseProfileDetail.data['msg'];
        } else {
          throw Exception('Error when update info');
        }
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> changePassword(
      String userId, String oldPassword, String newPassword) async {
    final uri = Uri.https(AppConstants.HOST_NAME, '/api/users/change_password');

    try {
      dio.Response response = await dioClient.post(uri.toString(), data: {
        "userId": userId,
        "oldPassword": oldPassword,
        "newPassword": newPassword
      });

      if (response.statusCode == 200) {
        String responseMsg = response.data['msg'];

        return responseMsg;
      } else {
        return 'Error when update password';
      }
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<String> removeProfileImage(String userId) async {
    final uri = Uri.https(AppConstants.HOST_NAME, '/api/asset/avatar/$userId');

    try {
      dio.Response response = await dioClient.delete(uri.toString());

      if (response.statusCode == 200) {
        return response.data['data']['userClaim']['avatarUrl'];
      } else {
        throw Exception('Error when remove avatar');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<AddressBook>> getAddressBookByUserId(String userId) async {
    final uri =
        Uri.https(AppConstants.HOST_NAME, '/api/users/address_book/$userId');

    try {
      dio.Response response = await dioClient.get(uri.toString());

      if (response.statusCode == 200) {
        Iterable responseData = response.data['data'];
        var addressBookList = List<AddressBook>.from(
            responseData.map((model) => AddressBook.fromJson(model)));

        return addressBookList;
      } else {
        throw Exception('Error when get addressBook data');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> addAddressBook(String userId, String fullName, String address,
      String phoneNumber) async {
    final uri =
        Uri.https(AppConstants.HOST_NAME, '/api/users/add_address_book');

    try {
      dio.Response response = await dioClient.post(uri.toString(), data: {
        "userId": userId,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "address": address
      });

      if (response.statusCode == 200) {
        String responseMsg = response.data['msg'];

        return responseMsg;
      } else {
        throw Exception('Error when add new addressBook');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> updateAddressBookForUser(
      String userId, List<AddressBook>? addressBookList) async {
    final uri =
        Uri.https(AppConstants.HOST_NAME, '/api/users/update_address_book');

    try {
      dio.Response response = await dioClient.post(uri.toString(), data: {
        "userId": userId,
        "address": addressBookList!.map((e) => e.toJson()).toList()
      });

      if (response.statusCode == 200) {
        String responseMsg = response.data['msg'];

        return responseMsg;
      } else {
        throw Exception('Error when update addressBook list');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
