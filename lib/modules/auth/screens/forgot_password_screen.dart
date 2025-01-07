import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/utils/constants/color_const.dart';
import 'package:paychain_mobile/utils/constants/demension_const.dart';
import 'package:paychain_mobile/utils/extensions/ext_box_decoration.dart';
import 'package:paychain_mobile/shared/widgets/widgets.dart';
import 'package:paychain_mobile/utils/helpers/validators.dart';

import '../controllers/auth_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: 'Quên mật khẩu',
        onBackPressed: () {
          Get.back();
          authController.resetText();
          authController.remainingTime.value = 0;
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Container(
          decoration: Theme.of(context).defaultBoxDecoration,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kDefaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nhập email',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: kMinPadding),
                  Row(
                    children: [
                      Obx(
                        () => Expanded(
                          flex: 3,
                          child: TextFormField(
                            validator: (value) =>
                                Validators.validateEmail(value),
                            enabled: authController.remainingTime.value != 0
                                ? false
                                : true,
                            controller: authController.emailController,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: kMinPadding),
                      Obx(
                        () => Expanded(
                          flex: 2,
                          child: authController.remainingTime.value == 0
                              ? ElevatedButton(
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      var result = Validators.validateEmail(
                                          authController.emailController.text);
                                      if (result == null) {
                                        await authController
                                            .sendForgotPasswordOTP();
                                      }
                                    } else {
                                      await authController
                                          .sendForgotPasswordOTP();
                                    }
                                  },
                                  child: authController.isLoading.value
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text('Gửi OTP'),
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorPalette.tfBorder),
                                  onPressed: () async {
                                    // await authController.verifyEmail();
                                  },
                                  child: authController.isLoading.value
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text('Đã gửi'),
                                ),
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => authController.remainingTime.value != 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: kMinPadding),
                              Text(
                                'Nhập mã OTP',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: kMinPadding),
                              TextFormField(
                                validator: (value) =>
                                    Validators.validateOtp(value),
                                enabled: authController.remainingTime.value != 0
                                    ? true
                                    : false,
                                controller: authController.otpController,
                                decoration: const InputDecoration(
                                  hintText: 'Mã OTP',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: kMinPadding),
                              Text(
                                'Nhập mật khẩu mới',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: kMinPadding),
                              TextFormField(
                                validator: (value) =>
                                    Validators.validatePassword(value),
                                obscureText: true,
                                enabled: authController.remainingTime.value != 0
                                    ? true
                                    : false,
                                controller: authController.passwordController,
                                decoration: const InputDecoration(
                                  hintText: 'Mật khẩu',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: kMinPadding),
                              Text(
                                'Xác nhận mật khẩu mới',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: kMinPadding),
                              TextFormField(
                                validator: (value) =>
                                    Validators.validateConfirmPassword(value,
                                        authController.passwordController.text),
                                obscureText: true,
                                enabled: authController.remainingTime.value != 0
                                    ? true
                                    : false,
                                controller:
                                    authController.confirmPasswordController,
                                decoration: const InputDecoration(
                                  hintText: 'Xác nhận mật khẩu',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : SizedBox(),
                  ),
                  const SizedBox(height: kMinPadding),
                  Obx(
                    () => authController.remainingTime.value != 0
                        ? RichText(
                            text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium, // Đặt style mặc định cho toàn bộ text
                              children: [
                                const TextSpan(
                                  text: 'Chúng tôi đã gửi mã xác minh đến ',
                                ),
                                TextSpan(
                                  text: authController.emailController.text,
                                  style: const TextStyle(
                                      color: ColorPalette
                                          .primary1), // Màu cho email
                                ),
                                const TextSpan(
                                  text:
                                      '. Vui lòng kiểm tra email và nhập mã xác minh vào ô trên. Gửi lại mã sau ',
                                ),
                                TextSpan(
                                  text:
                                      '${authController.remainingTime.value} giây',
                                  style: const TextStyle(
                                      color: ColorPalette
                                          .primary1), // Màu cho thời gian
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Obx(() => authController.remainingTime.value != 0
                      ? Column(
                          children: [
                            const SizedBox(height: kMinPadding),
                            ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await authController
                                        .sendNewForgotPassword();
                                  }
                                },
                                child: Text('Đổi mật khẩu')),
                          ],
                        )
                      : const SizedBox())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
