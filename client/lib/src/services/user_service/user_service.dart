import 'package:dio/dio.dart' as dio;

import '../../models/user.dart';

abstract class UserService {
  final dio.Dio dioClient;

  UserService({required this.dioClient});

  Future<UserClaim>? fetchUserInfoById(String userId);

  Future<String> register(String email, String password, String fullName);

  Future<String> login(String email, String password);

  Future<String> updateProfile(
      String userId, String fullName, String address, String phoneNumber);
}
