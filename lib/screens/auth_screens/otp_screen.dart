import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/config/color_const.dart';
import 'package:paychain_mobile/config/demension_const.dart';
import 'package:paychain_mobile/extensions/ext_box_decoration.dart';
import 'package:paychain_mobile/widgets/widgets.dart';

import '../../features/auth/controllers/auth_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    authController.startCountdown();
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Xác minh email',
        onBackPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Thoát'),
                content: const Text(
                    'Bạn có chắc chắn muốn thoát không? Tài khoản của bạn sẽ không được tạo.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Không'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      authController.resetText();
                      authController.resetCountdown();
                    },
                    child: const Text('Có'),
                  ),
                ],
              );
            },
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Container(
          decoration: Theme.of(context).defaultBoxDecoration,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kDefaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nhập mã xác minh',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: kMinPadding),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: authController.otpController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Mã',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: kMinPadding),
                    Obx(
                      () => Expanded(
                        flex: 2,
                        child: authController.remainingTime.value == 0
                            ? ElevatedButton(
                                onPressed: () async {
                                  await authController.resendOtp();
                                },
                                child: authController.isLoading.value
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Gửi lại'),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  await authController.verifyEmail();
                                },
                                child: authController.isLoading.value
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Kiểm tra'),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kDefaultPadding),
                Obx(
                  () => RichText(
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
                              color: ColorPalette.primary1), // Màu cho email
                        ),
                        const TextSpan(
                          text:
                              '. Vui lòng kiểm tra email và nhập mã xác minh vào ô trên. Gửi lại mã sau ',
                        ),
                        TextSpan(
                          text: '${authController.remainingTime.value} giây',
                          style: const TextStyle(
                              color:
                                  ColorPalette.primary1), // Màu cho thời gian
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
