import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:paychain_mobile/routes/routes.dart';
import 'package:paychain_mobile/modules/auth/dtos/login_success_dto.dart';
import 'package:paychain_mobile/modules/auth/services/auth_service.dart';
import 'package:paychain_mobile/utils/helpers/helpers.dart';

import '../../../data/models/base_response.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var currentEmail = ''.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();
  RxInt remainingTime = 60.obs;
  RxBool canCheckBiometrics = false.obs;
  final AuthService _authService = AuthService();
  final _sharedPreferencesService = SharedPreferencesService();
  LocalAuthentication localAuth = LocalAuthentication();
  // var supportedBiometric = ''.obs;

  void resetText() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    otpController.clear();
  }

  @override
  onInit() async {
    super.onInit();
    checkBiometrics();
    isLoggedIn.value = await _sharedPreferencesService
            .getBool(SharedPreferencesService.IS_LOGGED_IN) ??
        false;
    currentEmail.value = await _sharedPreferencesService
            .getString(SharedPreferencesService.EMAIL) ??
        '';
    if (isLoggedIn.value) {
      await authenticate();
    }
    // detectBiometricType();
  }

  // Future<void> detectBiometricType() async {
  //   try {
  //     // Lấy danh sách các phương thức sinh trắc học mà thiết bị hỗ trợ
  //     List<BiometricType> availableBiometrics =
  //         await localAuth.getAvailableBiometrics();

  //     // Xác định loại sinh trắc học
  //     if (availableBiometrics.contains(BiometricType.face)) {
  //       supportedBiometric.value = "Face ID";
  //     } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
  //       supportedBiometric.value = "Fingerprint";
  //     } else {
  //       supportedBiometric.value = "None";
  //     }
  //   } catch (e) {
  //     supportedBiometric.value = "Error: ${e.toString()}";
  //   }
  // }

  Future<void> authenticate() async {
    try {
      bool isAuthenticated = await localAuth.authenticate(
        localizedReason: 'Vui lòng xác thực để đăng nhập',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        await loginUserByBiometric();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkBiometrics() async {
    // Kiểm tra nếu thiết bị hỗ trợ sinh trắc học
    bool isSupported = await localAuth.isDeviceSupported();
    canCheckBiometrics.value = isSupported;
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
        isLoggedIn.value ? currentEmail.value : emailController.text,
        passwordController.text);
    switch (result) {
      case Success():
        isLoading.value = false;
        Get.offAndToNamed(Routes.mainWrapper);
        await _saveAllUserData(result);
        // Get.delete<AuthController>(force: true);
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

  Future<void> _saveAllUserData(Success<LoginSuccessDto> result) async {
    await _sharedPreferencesService.saveString(
        SharedPreferencesService.EMAIL, result.data!.email);
    await _sharedPreferencesService.saveString(
        SharedPreferencesService.ID, result.data!.id);
    await _sharedPreferencesService.saveString(
        SharedPreferencesService.PHONE_NUMBER, result.data!.phoneNumber);
    await _sharedPreferencesService.saveString(
        SharedPreferencesService.ACCESS_TOKEN, result.data!.accessToken);
    await _sharedPreferencesService.saveString(
        SharedPreferencesService.REFRESH_TOKEN, result.data!.refreshToken);
    await _sharedPreferencesService.saveBool(
        SharedPreferencesService.IS_LOGGED_IN, true);
  }

  Future<void> loginUserByBiometric() async {
    isLoading.value = true;
    final result =
        await _authService.loginUser('zafus2103@gmail.com', 'Phu12382@');
    switch (result) {
      case Success():
        isLoading.value = false;
        await _saveAllUserData(result);
        Get.offAndToNamed(Routes.mainWrapper);
        // Get.delete<AuthController>(force: true);
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
