import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:paychain_mobile/modules/auth/dtos/fast_login_request.dart';
import 'package:paychain_mobile/utils/configs/dio_config.dart';
import 'package:paychain_mobile/modules/auth/dtos/login_success_dto.dart';

import '../../models/base_response.dart';

class AuthService {
  String hashPassword(String password) {
    var bytes = utf8.encode(password); // Chuyển mật khẩu thành bytes
    var digest = sha256.convert(bytes); // Mã hóa mật khẩu bằng SHA-256
    return digest.toString(); // Trả về chuỗi hex của mã băm
  }

  Future<BaseResponse> registerUser(
      String name, String email, String password) async {
    try {
      var url = '/auth/register';
      var response = await defaultDio.post(
        url,
        data: {
          'name': name,
          'email': email,
          'password': hashPassword(password)
        },
      );
      print(response.data);
      return Success(response.data);
    } on DioException catch (e) {
      print(e.response!.data['message']);
      return Failure(
          message: e.response!.data['message'] ?? "Có lỗi xảy ra",
          statusCode: e.response!.statusCode ?? 500);
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

  Future<BaseResponse<LoginSuccessDto>> loginUser(
      String email, String password) async {
    try {
      var url = 'auth/login';
      var response = await defaultDio.post(
        url,
        data: {'email': email, 'password': hashPassword(password)},
      );
      // print(response.data!.wallets);
      return Success(LoginSuccessDto.fromJson(response.data));
    } on DioException catch (e) {
      return Failure(
          message: e.message ?? "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }

  Future<BaseResponse<LoginSuccessDto>> fastLogin(
      FastLoginRequest request) async {
    try {
      print(request.accessToken);
      print(request.refreshToken);
      var url = 'auth/fastLogin';
      var response = await defaultDio.post(
        url,
        data: {
          'email': request.email,
          'accessToken': request.accessToken,
          'refreshToken': request.refreshToken
        },
      );
      // print(response.data!.wallets);
      return Success(LoginSuccessDto.fromJson(response.data));
    } on DioException catch (e) {
      return Failure(
          message: e.message ?? "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }
}
