import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:paychain_mobile/modules/auth/dtos/fast_login_request.dart';
import 'package:paychain_mobile/routes/routes.dart';
import 'package:paychain_mobile/data/services/auth/auth_service.dart';
import 'package:paychain_mobile/utils/helpers/helpers.dart';

import '../../../data/models/base_response.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var currentEmail = ''.obs;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final otpController = TextEditingController();
  RxInt remainingTime = 0.obs;
  RxBool canCheckBiometrics = false.obs;
  final AuthService _authService = AuthService();
  final _sharedPreferencesService = SharedPreferencesService();
  LocalAuthentication localAuth = LocalAuthentication();
  // var supportedBiometric = ''.obs;

  void resetText() {
    currentPasswordController.clear();
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

  transferAuthenticate() async {
    try {
      return await localAuth.authenticate(
        localizedReason: 'Vui lòng xác thực để xác nhận giao dịch',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
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
        nameController.text, emailController.text, passwordController.text);
    switch (result) {
      case Success():
        isLoading.value = false;
        remainingTime.value = 60;
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

  Future<void> sendForgotPasswordOTP() async {
    isLoading.value = true;
    final result =
        await _authService.sendForgotPasswordOTP(emailController.text);
    switch (result) {
      case Success():
        isLoading.value = false;
        remainingTime.value = 120;
        startCountdown();
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

  Future<void> sendNewForgotPassword() async {
    isLoading.value = true;
    final result = await _authService.sendNewForgotPassword(
        emailController.text, otpController.text, passwordController.text);
    switch (result) {
      case Success():
        isLoading.value = false;
        stopCountdown();
        resetText();
        Get.offAndToNamed(Routes.loginScreen);
        Get.snackbar(
            'Đổi mật khẩu thành công', 'Vui lòng đăng nhập lại vào ứng dụng');
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

  Future<void> changePassword() async {
    isLoading.value = true;
    final result = await _authService.changePassword(
        currentPasswordController.text,
        passwordController.text,
        currentEmail.value);
    switch (result) {
      case Success():
        isLoading.value = false;
        Get.back();
        resetText();
        Get.snackbar('Đổi mật khẩu thành công', result.data);
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
        nameController.text, emailController.text, passwordController.text);
    switch (result) {
      case Success():
        isLoading.value = false;
        otpController.clear();
        resetCountdown(60);
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
        _sharedPreferencesService.saveAllUserData(
            result.data!.email,
            result.data!.name ?? "",
            result.data!.phoneNumber,
            result.data!.accessToken,
            result.data!.refreshToken);
        _sharedPreferencesService.saveBool(
            SharedPreferencesService.IS_LOGGED_IN, true);
        Get.toNamed(Routes.mainWrapper);
        Get.snackbar('Thông báo', "Đăng ký thành công! ");
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
        print(result.data);
        Get.offAndToNamed(Routes.mainWrapper);
        _sharedPreferencesService.saveAllUserData(
            result.data!.email,
            result.data!.name ?? "",
            result.data!.phoneNumber,
            result.data!.accessToken,
            result.data!.refreshToken);
        _sharedPreferencesService.saveBool(
            SharedPreferencesService.IS_LOGGED_IN, true);
        resetText();
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

  Future<void> loginUserByBiometric() async {
    isLoading.value = true;
    final accessToken = await _sharedPreferencesService
        .getString(SharedPreferencesService.ACCESS_TOKEN);
    final refreshToken = await _sharedPreferencesService
        .getString(SharedPreferencesService.REFRESH_TOKEN);
    final email = await _sharedPreferencesService
        .getString(SharedPreferencesService.EMAIL);
    if (refreshToken == null || accessToken == null || email == null) {
      isLoading.value = false;
      Get.snackbar(
          'Lỗi đăng nhập', 'Vui lòng đăng nhập bằng cách nhập mật khẩu');
      return;
    }
    final loginRequest = FastLoginRequest(
        email: email, accessToken: accessToken, refreshToken: refreshToken);
    final result = await _authService.fastLogin(loginRequest);
    switch (result) {
      case Success():
        print(result.data);
        isLoading.value = false;
        _sharedPreferencesService.saveAllUserData(
            result.data!.email,
            result.data!.name ?? "",
            result.data!.phoneNumber,
            result.data!.accessToken,
            result.data!.refreshToken);
        _sharedPreferencesService.saveBool(
            SharedPreferencesService.IS_LOGGED_IN, true);
        Get.offAndToNamed(Routes.mainWrapper);
        break;
      case Failure():
        isLoading.value = false;
        if (result.statusCode == 401) {
          Get.snackbar('Lỗi đăng nhập', 'Phiên đăng nhập đã hết hạn');
          await _sharedPreferencesService.clearAllUserData();
          Get.offAndToNamed(Routes.loginScreen);
        } else {
          Get.snackbar('Lỗi đăng nhập', result.message);
        }
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
    remainingTime.value = 0;
    _timer?.cancel();
  }

  // Hàm reset đếm ngược về 60 giây
  void resetCountdown(int second) {
    remainingTime.value = second;
  }
}
