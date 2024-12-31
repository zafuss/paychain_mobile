import 'package:get/get.dart';
import 'package:paychain_mobile/features/auth/services/auth_service.dart';

import '../../../models/base_response.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  final AuthService _authService = AuthService();
  Future<void> registerUser(String email, String password) async {
    isLoading.value = true;
    final result = await _authService.registerUser(email, password);
    switch (result) {
      case Success():
        isLoading.value = false;
        Get.snackbar('Thông báo', 'Đăng ký tài khoản thành công!');
        break;
      case Failure():
        isLoading.value = false;
        Get.snackbar('Lỗi đăng ký tài khoản', result.message);
        break;
      default:
        isLoading.value = false;
        Get.snackbar('Lỗi đăng ký tài khoản', 'Lỗi không xác định');
        break;
    }
  }

  Future<void> verifyEmail(String verificationCode, String email) async {
    isLoading.value = true;
    final result = await _authService.verifyEmail(verificationCode, email);
    switch (result) {
      case Success():
        isLoading.value = false;
        Get.snackbar('Thông báo', 'Xác thực email thành công!');
        break;
      case Failure():
        isLoading.value = false;
        Get.snackbar('Lỗi xác thực email', result.message);
        break;
      default:
        isLoading.value = false;
        Get.snackbar('Lỗi xác thực email', 'Lỗi không xác định');
        break;
    }
  }

  Future<void> loginUser(String email, String password) async {
    isLoading.value = true;
    final result = await _authService.loginUser(email, password);
    switch (result) {
      case Success():
        isLoading.value = false;
        Get.snackbar('Thông báo', 'Đăng nhập thành công!');
        break;
      case Failure():
        isLoading.value = false;
        Get.snackbar('Lỗi đăng nhập', result.message);
        break;
      default:
        isLoading.value = false;
        Get.snackbar('Lỗi đăng nhập', 'Lỗi không xác định');
        break;
    }
  }
}
