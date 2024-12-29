import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/entities/user.dart';
import 'package:crypto/crypto.dart';


String hashPassword(String password) {
  var bytes = utf8.encode(password);  // Chuyển mật khẩu thành bytes
  var digest = sha256.convert(bytes);  // Mã hóa mật khẩu bằng SHA-256
  return digest.toString();  // Trả về chuỗi hex của mã băm
}

class AuthController extends GetxController {
  var isLoading = false.obs;

  Future<void> registerUser(String email, String password) async {
    isLoading.value = true;
    password = await hashPassword(password);
    // Khởi tạo đối tượng User
    var user = User(email: email, password: password);

    // Khởi tạo Dio
    var dio = Dio();

    // URL API
    var url = 'http://10.0.2.2:8080/auth/register';

    try {
      // Gửi yêu cầu POST với dữ liệu người dùng
      var response = await dio.post(
        url,
        data: user.toJson(), // Chuyển đối tượng User thành JSON
      );

      // Kiểm tra kết quả trả về
      if (response.statusCode == 200) {
        print('User registered successfully: ${response.data}');
        print('Enter your email verify: ');
      } else {
        print('Failed to register user: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error occurred: ${e.message}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyEmail(String verificationCode, String email) async {
    var dio = Dio();

    // URL API
    var url = 'http://10.0.2.2:8080/auth/verify';

    try {
      // Gửi yêu cầu POST với dữ liệu JSON
      var response = await dio.post(
        url,
        data: {
          'verificationCode': verificationCode, // Chuyển key thành chuỗi
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        print('Email verification successful!');
      } else {
        print('Email verification failed: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Lỗi từ phía server
        print('Server error: ${e.response?.data}');
      } else {
        // Lỗi khi gửi request
        print('Request error: ${e.message}');
      }
    } catch (e) {
      // Lỗi không xác định
      print('Unexpected error: $e');
    }
  }

  Future<void> loginUser(String email, String password) async {
    var dio = Dio();
    password = await hashPassword(password);
    print(password);
    var user = User(email: email, password: password);

    var url = 'http://10.0.2.2:8080/auth/login';

    try {
      var response = await dio.post(
        url,
        data: {
          'email': email,
          'password': password,
        }, // Dữ liệu người dùng
      );

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
