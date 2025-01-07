import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/utils/constants/color_const.dart';
import 'package:paychain_mobile/utils/constants/demension_const.dart';
import 'package:paychain_mobile/routes/routes.dart';
import 'package:paychain_mobile/modules/auth/controllers/auth_controller.dart';
import 'package:paychain_mobile/utils/helpers/validators.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final _formKey = GlobalKey<FormState>(); // Khởi tạo GlobalKey cho Form

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
                      child: Form(
                        key: _formKey, // Gắn key vào Form
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
                            TextFormField(
                              controller: authController.nameController,
                              decoration: const InputDecoration(
                                labelText: 'Tên của bạn',
                                border: OutlineInputBorder(),
                              ),
                              validator: Validators.validateName,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: authController.emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              validator: Validators.validateEmail,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: authController.passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Mật khẩu',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                              validator: Validators.validatePassword,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller:
                                  authController.confirmPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'Xác nhận mật khẩu',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                              validator: (value) =>
                                  Validators.validateConfirmPassword(
                                value,
                                authController.passwordController.text,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Obx(
                              () => ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    authController
                                        .registerUser(); // Xử lý đăng ký nếu form hợp lệ
                                  }
                                },
                                child: authController.isLoading.value
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
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
              ),
              Container(
                color: Colors.white,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: kMinPadding),
                    child: TextButton(
                      onPressed: () {
                        Get.offAndToNamed(Routes.loginScreen);
                        authController.resetText();
                      },
                      child: RichText(
                          text: TextSpan(
                              style: AppTextStyles.body1
                                  .copyWith(color: Colors.black),
                              text: 'Bạn đã có tài khoản? ',
                              children: const [
                            TextSpan(
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
