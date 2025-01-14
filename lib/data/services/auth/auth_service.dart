import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:paychain_mobile/modules/auth/dtos/fast_login_request.dart';
import 'package:paychain_mobile/utils/configs/dio_config.dart';
import 'package:paychain_mobile/modules/auth/dtos/login_success_dto.dart';
import 'package:paychain_mobile/utils/helpers/database_helper.dart';

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
          message: e.response != null
              ? e.response!.data!['message']
              : "Có lỗi xảy ra",
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
      return Success(LoginSuccessDto.fromJson(response.data));
    } on DioException catch (e) {
      return Failure(
          message: e.message ?? "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }

  Future<BaseResponse> changePassword(
      String currentPassword, String newPassword, String email) async {
    try {
      var url = 'auth/change-password';
      var response = await defaultDio.post(
        url,
        data: {
          'password': hashPassword(currentPassword),
          'newPassword': hashPassword(newPassword),
          'email': email
        },
      );
      return Success(response.data['message']);
    } on DioException catch (e) {
      return Failure(
          message: e.response != null
              ? e.response!.data!['message']
              : "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }

  Future<BaseResponse> sendForgotPasswordOTP(String email) async {
    try {
      var url = 'auth/generateOTP';
      var response = await defaultDio.post(
        url,
        data: {'email': email},
      );
      return Success(response.data);
    } on DioException catch (e) {
      return Failure(
          message: e.response != null
              ? e.response!.data!['message']
              : "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }

  Future<BaseResponse> sendNewForgotPassword(
      String email, String verificationCode, String password) async {
    try {
      var url = 'auth/forgot-password';
      var response = await defaultDio.post(
        url,
        data: {
          'email': email,
          'verificationCode': verificationCode,
          'password': hashPassword(password)
        },
      );
      return Success(response.data);
    } on DioException catch (e) {
      return Failure(
          message: e.response != null
              ? e.response!.data!['message']
              : "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }

  Future<BaseResponse<LoginSuccessDto>> loginUser(
      String email, String password) async {
    try {
      // var url = 'auth/login';
      // var response = await defaultDio.post(
      //   url,
      //   data: {'email': email, 'password': hashPassword(password)},
      // );
      // // print(response.data!.wallets);
      // return Success(LoginSuccessDto.fromJson(response.data));

      final dbHelper = DatabaseHelper.instance;
      final userData = await dbHelper.getUserByEmail(email);

      if (userData == null) {
        return Failure(message: 'Email không tồn tại', statusCode: 404);
      }

      // Kiểm tra mật khẩu
      final hashedInputPassword = hashPassword(password);
      print(userData);

      if (userData['password'] != hashedInputPassword) {
        return Failure(message: 'Sai mật khẩu', statusCode: 401);
      }

      final user = LoginSuccessDto.fromJson(userData);
      return Success(user);
    } on DioException catch (e) {
      return Failure(
          message: e.response != null
              ? e.response!.data!['message']
              : "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }

  Future<BaseResponse<LoginSuccessDto>> fastLogin(
      FastLoginRequest request) async {
    try {
      // print(request.accessToken);
      // print(request.refreshToken);
      // var url = 'auth/fastLogin';
      // var response = await defaultDio.post(
      //   url,
      //   data: {
      //     'email': request.email,
      //     'accessToken': request.accessToken,
      //     'refreshToken': request.refreshToken
      //   },
      // );
      // // print(response.data!.wallets);
      // return Success(LoginSuccessDto.fromJson(response.data));
      final dbHelper = DatabaseHelper.instance;
      final userData = await dbHelper.getUserByEmail(request.email);

      if (userData == null) {
        return Failure(message: 'Email không tồn tại', statusCode: 404);
      }
      return Success(LoginSuccessDto.fromJson(userData));
    } on DioException catch (e) {
      return Failure(
          message: e.response != null
              ? e.response!.data!['message']
              : "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }
}
