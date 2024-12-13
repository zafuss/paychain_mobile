import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/config/color_const.dart';
import 'package:paychain_mobile/config/demension_const.dart';
import 'package:paychain_mobile/config/routes.dart';
import 'package:paychain_mobile/features/auth/controllers/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: ColorPalette.primary1, // Màu nền của status bar
    //   statusBarIconBrightness: Brightness.light,
    // ));
    final authController = Get.put(AuthController());
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    return Scaffold(
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
                padding:
                    EdgeInsets.only(left: kDefaultPadding, bottom: kMinPadding),
                child: SafeArea(
                  bottom: false,
                  child: Text(
                    'Đăng ký tài khoản',
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
                          Text('Vui lòng đăng ký tài khoản để tiếp tục',
                              style: AppTextStyles.caption2),
                          Padding(
                            padding: const EdgeInsets.all(kDefaultPadding),
                            child: Image.asset(
                              'assets/images/register.png',
                              height: 200,
                            ),
                          ),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Mật khẩu',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Xác nhận mật khẩu',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 24),
                          Obx(
                            () => ElevatedButton(
                              onPressed: () {
                                // Xử lý sự kiện nút bấm
                                authController.registerUser(
                                    _emailController.text,
                                    _passwordController.text);
                              },
                              child: authController.isLoading.value
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Text('Đăng ký'),
                            ),
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
                    padding: EdgeInsets.only(bottom: kMinPadding),
                    child: TextButton(
                      onPressed: () {
                        Get.offAndToNamed(Routes.loginScreen);
                      },
                      child: RichText(
                          text: TextSpan(
                              style: AppTextStyles.body1
                                  .copyWith(color: Colors.black),
                              text: 'Bạn đã có tài khoản? ',
                              children: [
                            const TextSpan(
                                text: 'Đăng nhập',
                                style: TextStyle(color: ColorPalette.primary1))
                          ])),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
