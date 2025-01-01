import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:paychain_mobile/config/dio_config.dart';
import 'package:paychain_mobile/models/base_response.dart';
import 'package:paychain_mobile/models/user.dart';

class AuthService {
  String hashPassword(String password) {
    var bytes = utf8.encode(password); // Chuyển mật khẩu thành bytes
    var digest = sha256.convert(bytes); // Mã hóa mật khẩu bằng SHA-256
    return digest.toString(); // Trả về chuỗi hex của mã băm
  }

  Future<BaseResponse> registerUser(String email, String password) async {
    try {
      var user = User(email: email, password: hashPassword(password));
      var url = '/auth/register';
      var response = await defaultDio.post(
        url,
        data: user.toJson(),
      );
      print(response.data);
      return Success(response.data);
    } on DioException catch (e) {
      return Failure(
          message: e.message ?? "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }

  Future<BaseResponse> verifyEmail(
      String verificationCode, String email) async {
    try {
      var url = 'auth/verify';
      var response = await defaultDio.post(
        url,
        data: {'verificationCode': verificationCode, 'email': email},
      );
      return Success(response.data);
    } on DioException catch (e) {
      return Failure(
          message: e.message ?? "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }

  Future<BaseResponse> loginUser(String email, String password) async {
    try {
      var url = 'auth/login';
      var response = await defaultDio.post(
        url,
        data: {'email': email, 'password': hashPassword(password)},
      );
      return Success(response.data);
    } on DioException catch (e) {
      return Failure(
          message: e.message ?? "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }
}
