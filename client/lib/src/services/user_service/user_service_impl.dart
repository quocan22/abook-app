import 'dart:convert';

import 'package:dio/dio.dart' as dio;

import '../../models/user.dart';
import './user_service.dart';

class UserServiceImpl implements UserService {
  final dio.Dio dioClient;

  UserServiceImpl({required this.dioClient});

  @override
  Future<UserClaim> fetchUserInfoById(String userId) async {
    final uri = Uri.http('10.0.2.2:5000', '/api/users/$userId');

    try {
      dio.Response response = await dioClient.get(uri.toString());

      if (response.statusCode == 200) {
        var responseData = json.decode(response.data);
        //var responseData = jsonRes['data'];
        UserClaim userClaim = UserClaim.fromJson(responseData);

        return userClaim;
      } else {
        throw Exception('Error when fetching data');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
