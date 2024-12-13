import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/entities/user.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  Future<void> registerUser(String email, String password) async {
    isLoading.value = true;
    // Khởi tạo Dio
    var user = User(email: email, password: password);

    var dio = Dio();

    // URL API
    var url = 'http://localhost:8080/auth/register';

    try {
      // Gửi yêu cầu POST với dữ liệu người dùng
      var response = await dio.post(
        url,
        data: user.toJson(), // Dữ liệu người dùng
      );

      // Kiểm tra kết quả trả về
      if (response.statusCode == 200) {
        print('User registered successfully: ${response.data}');
        print('Enter your email verify: ');
      } else {
        print('Failed to register user: ${response.data}');
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;

      print('Error occurred: $e');
    }
  }

  Future<void> verifyEmail(String verificationCode, String email) async {
    var dio = Dio();
    // URL API với query parameters
    var url =
        'http://localhost:8080/auth/verify?verificationCode=$verificationCode&email=$email';

    try {
      var response = await dio.post(url);

      if (response.statusCode == 200) {
        print('Email verification successful!');
      } else {
        print('Email verification failed: ${response.data}');
      }
    } catch (e) {
      print('Error occurred during email verification: $e');
    }
  }

  Future<void> loginUser(String email, String password) async {
    var dio = Dio();
    var url =
        'http://localhost:8080/auth/login?email=$email&password=$password';

    try {
      var response = await dio.post(url);

      if (response.statusCode == 200) {
        print('Login successful');
      } else {
        print('Login failed: ${response.data}');
      }
    } catch (e) {
      print('Error occurred during login: $e');
    }
  }
}
