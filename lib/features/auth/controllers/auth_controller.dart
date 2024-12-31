import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/config/routes.dart';
import 'package:paychain_mobile/features/auth/services/auth_service.dart';
import 'package:paychain_mobile/helpers/helpers.dart';

import '../../../models/base_response.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();
  RxInt remainingTime = 60.obs;
  final AuthService _authService = AuthService();
  final _sharedPreferencesService = SharedPreferencesService();

  void resetText() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    otpController.clear();
  }

  Future<void> registerUser() async {
    isLoading.value = true;
    final result = await _authService.registerUser(
        emailController.text, passwordController.text);
    switch (result) {
      case Success():
        isLoading.value = false;
        Get.toNamed(Routes.otpScreen);
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

  Future<void> resendOtp() async {
    isLoading.value = true;
    final result = await _authService.registerUser(
        emailController.text, passwordController.text);
    switch (result) {
      case Success():
        isLoading.value = false;
        otpController.clear();
        resetCountdown();
        startCountdown();
        // Get.snackbar('Thông báo', result.data.toString());
        break;
      case Failure():
        isLoading.value = false;
        Get.snackbar('Lỗi gửi lại OTP', result.message);
        break;
      default:
        isLoading.value = false;
        Get.snackbar('Lỗi gửi lại OTP', 'Lỗi không xác định');
        break;
    }
  }

  Future<void> verifyEmail() async {
    isLoading.value = true;
    final result = await _authService.verifyEmail(
        otpController.text, emailController.text);
    switch (result) {
      case Success():
        isLoading.value = false;
        stopCountdown();
        await _sharedPreferencesService.saveString(
            SharedPreferencesService.EMAIL, emailController.text);
        Get.toNamed(Routes.infoScreen);
        Get.snackbar('Thông báo', result.data.toString());
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

  Future<void> loginUser() async {
    isLoading.value = true;
    final result = await _authService.loginUser(
        emailController.text, passwordController.text);
    switch (result) {
      case Success():
        isLoading.value = false;
        Get.offAndToNamed(Routes.infoScreen);
        await _sharedPreferencesService.saveString(
            SharedPreferencesService.EMAIL, emailController.text);
        Get.delete<AuthController>(force: true);
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

  // Timer để thực hiện đếm ngược
  Timer? _timer;

  // Hàm bắt đầu đếm ngược
  void startCountdown() {
    // Đảm bảo rằng nếu đã có timer trước đó thì sẽ hủy bỏ trước khi tạo lại
    _timer?.cancel();

    // Mỗi giây sẽ giảm 1 giá trị của remainingTime
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        // Nếu đếm ngược xong, dừng timer
        _timer?.cancel();
      }
    });
  }

  // Hàm dừng đếm ngược
  void stopCountdown() {
    _timer?.cancel();
  }

  // Hàm reset đếm ngược về 60 giây
  void resetCountdown() {
    remainingTime.value = 60;
  }
}
