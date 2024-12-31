import 'package:dio/dio.dart';
import 'package:paychain_mobile/config/dio_config.dart';
import 'package:paychain_mobile/models/base_response.dart';
import 'package:paychain_mobile/models/user.dart';

class AuthService {
  Future<BaseResponse> registerUser(String email, String password) async {
    try {
      var user = User(email: email, password: password);
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
          statusCode: e.response!.statusCode ?? 500);
    }
  }

  Future<BaseResponse> verifyEmail(
      String verificationCode, String email) async {
    try {
      var url = 'auth/verify?verificationCode=$verificationCode&email=$email';
      var response = await defaultDio.post(
        url,
      );
      return Success(response.data);
    } on DioException catch (e) {
      return Failure(
          message: e.message ?? "Có lỗi xảy ra",
          statusCode: e.response!.statusCode ?? 500);
    }
  }

  Future<BaseResponse> loginUser(String email, String password) async {
    try {
      var url = 'auth/login?email=$email&password=$password';
      var response = await defaultDio.post(
        url,
      );
      return Success(response.data);
    } on DioException catch (e) {
      return Failure(
          message: e.message ?? "Có lỗi xảy ra",
          statusCode: e.response!.statusCode ?? 500);
    }
  }
}
