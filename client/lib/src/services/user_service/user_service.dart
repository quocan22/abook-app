import 'dart:io';

import 'package:dio/dio.dart' as dio;

import '../../models/address_book.dart';
import '../../models/user.dart';

abstract class UserService {
  final dio.Dio dioClient;

  UserService({required this.dioClient});

  Future<UserClaim>? fetchUserInfoById(String userId);

  Future<dynamic> register(String email, String password, String fullName);

  Future<dynamic> login(String email, String password);

  Future<String> changePassword(
      String userId, String oldPassword, String newPassword);

  Future<String> updateProfile(String userId, String fullName, String address,
      String phoneNumber, File? image);

  Future<String> removeProfileImage(String userId);

  Future<List<AddressBook>>? getAddressBookByUserId(String userId);

  Future<String> addAddressBook(
      String userId, String fullName, String address, String phoneNumber);

  Future<String> updateAddressBookForUser(
      String userId, List<AddressBook>? addressBookList);

  Future<String> verifyOTP(String userId, String otp);

  Future<dynamic> resendOTP(String email);
}
