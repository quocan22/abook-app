import 'package:dio/dio.dart' as dio;

import '../../models/user.dart';

abstract class UserService {
  final dio.Dio dioClient;

  UserService({required this.dioClient});

  Future<UserClaim>? fetchUserInfoById(String userId);
}
