import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/config/color_const.dart';
import 'package:paychain_mobile/config/demension_const.dart';
import 'package:paychain_mobile/features/auth/controllers/auth_controller.dart';

import '../../config/routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: ColorPalette.primary1, // Màu nền của status bar
    //   statusBarIconBrightness: Brightness.light,
    // ));
    final authController = Get.put(AuthController(), permanent: true);
    final canCheckBiometrics = authController.canCheckBiometrics;
    return Obx(
      () => AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: Stack(
            children: [
              // Nền màu xanh
              Container(
                color: ColorPalette.primary1,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text nằm trên Container
                  const Padding(
                    padding: EdgeInsets.only(
                        left: kDefaultPadding, bottom: kMinPadding),
                    child: SafeArea(
                      bottom: false,
                      child: Text(
                        'Đăng nhập',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Container màu trắng lấp toàn bộ phía dưới
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('Chào mừng bạn!',
                                  style: AppTextStyles.title1!
                                      .copyWith(color: ColorPalette.primary1)),
                              Text('Vui lòng đăng nhập để tiếp tục',
                                  style: AppTextStyles.caption2),
                              Padding(
                                padding: const EdgeInsets.all(kDefaultPadding),
                                child: Image.asset(
                                  'assets/images/login.png',
                                  height: 200,
                                ),
                              ),
                              authController.isLoggedIn.value
                                  ? Center(
                                      child: RichText(
                                          text: TextSpan(
                                        style: AppTextStyles.body2
                                            .copyWith(color: Colors.black),
                                        text: 'Đăng nhập bằng ',
                                        children: [
                                          TextSpan(
                                              text: authController
                                                  .currentEmail.value,
                                              style: const TextStyle(
                                                  color: ColorPalette.primary1,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      )),
                                    )
                                  : TextField(
                                      controller:
                                          authController.emailController,
                                      decoration: const InputDecoration(
                                        labelText: 'Email',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: authController.passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Mật khẩu',
                                  border: OutlineInputBorder(),
                                ),
                                obscureText: true,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: kMinPadding / 2),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(
                                        defaultBorderRadius),
                                    onTap: () {
                                      Get.toNamed(Routes.forgotPasswordScreen);
                                    },
                                    child: Text(
                                      'Quên mật khẩu?',
                                      style: AppTextStyles.caption2.copyWith(
                                          color: ColorPalette.tfBorder),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Obx(
                                    () => Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await authController.loginUser();
                                        },
                                        child: authController.isLoading.value
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Text('Đăng nhập'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: kMinPadding / 2),
                                  Obx(
                                    () => canCheckBiometrics.value
                                        ? SizedBox(
                                            width: 53,
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(5),
                                              ),
                                              onPressed: () async {
                                                if (authController
                                                    .isLoggedIn.value) {
                                                  await authController
                                                      .authenticate();
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                            title: const Text(
                                                                'Thông báo'),
                                                            content: const Text(
                                                                'Vui lòng đăng nhập trước khi sử dụng tính năng này'),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Get.back();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Đóng'))
                                                            ],
                                                          ));
                                                }
                                              },
                                              child: authController
                                                      .isLoading.value
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Image.asset(
                                                      'assets/images/face_id.png',
                                                      height: 40),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Footer content luôn nằm dưới cùng
                  Container(
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: kMinPadding),
                        child: TextButton(
                          onPressed: () {
                            Get.offAndToNamed(Routes.registerScreen);
                            authController.resetText();
                          },
                          child: RichText(
                              text: TextSpan(
                                  style: AppTextStyles.body1
                                      .copyWith(color: Colors.black),
                                  text: 'Bạn chưa có tài khoản? ',
                                  children: const [
                                TextSpan(
                                    text: 'Đăng ký',
                                    style:
                                        TextStyle(color: ColorPalette.primary1))
                              ])),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
