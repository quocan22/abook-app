import 'package:client/src/config/app_constants.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import './user_service.dart';

class UserServiceImpl implements UserService {
  final dio.Dio dioClient;

  UserServiceImpl({required this.dioClient});

  @override
  Future<UserClaim> fetchUserInfoById(String userId) async {
    final uri =
        Uri.http(AppConstants.HOST_NAME, '${AppConstants.USERS}/$userId');

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
  Future<String> login(String email, String password) async {
    final uri = Uri.http(AppConstants.HOST_NAME, AppConstants.LOGIN);

    try {
      dio.Response response = await dioClient
          .post(uri.toString(), data: {'email': email, 'password': password});

      if (response.statusCode == 200) {
        String responseMsg = response.data['msg'];

        var responseData = response.data['data'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', responseData['accessToken']);
        await prefs.setString('id', responseData['id']);

        return responseMsg;
      } else {
        throw Exception('Error when login');
      }
    } catch (e) {
      print(e.toString());
      dio.DioError dioError = e as dio.DioError;
      if (dioError.response?.statusCode == 404) {
        String responseMsg = dioError.response!.data['msg'];

        return responseMsg;
      } else if (dioError.response?.statusCode == 400) {
        String responseMsg = dioError.response!.data['msg'];

        return responseMsg;
      } else
        throw Exception(e.toString());
    }
  }

  @override
  Future<String> register(
      String email, String password, String fullName) async {
    final uri = Uri.http(AppConstants.HOST_NAME, AppConstants.REGISTERUSER);

    try {
      dio.Response response = await dioClient.post(uri.toString(), data: {
        'email': email,
        'password': password,
        'userClaim': {'displayName': fullName}
      });

      if (response.statusCode == 200) {
        String responseMsg = response.data['msg'];

        return responseMsg;
      } else {
        throw Exception('Error when register new user');
      }
    } catch (e) {
      print(e.toString());
      dio.DioError dioError = e as dio.DioError;
      if (dioError.message == 'Http status error [403]') {
        String responseMsg = dioError.response!.data['msg'];

        return responseMsg;
      } else
        throw Exception(e.toString());
    }
  }

  @override
  Future<String> updateProfile(String userId, String fullName, String address,
      String phoneNumber) async {
    final uri =
        Uri.http(AppConstants.HOST_NAME, '${AppConstants.USERS}/$userId');

    try {
      dio.Response response = await dioClient.put(uri.toString(), data: {
        "displayName": fullName,
        "address": address,
        "phoneNumber": phoneNumber
      });

      if (response.statusCode == 200) {
        String responseMsg = response.data['msg'];

        return responseMsg;
      } else {
        throw Exception('Error when update info');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
