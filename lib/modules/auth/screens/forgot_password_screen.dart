import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/utils/constants/demension_const.dart';
import 'package:paychain_mobile/utils/extensions/ext_box_decoration.dart';
import 'package:paychain_mobile/shared/widgets/widgets.dart';

import '../controllers/auth_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).brightness);
    // Đặt chế độ light status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    final authController = Get.find<AuthController>();
    authController.startCountdown();
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          context: context,
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
                    'Nhập email của bạn',
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
                            hintText: 'Email',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: kMinPadding),
                      Obx(
                        () => Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () async {},
                            child: authController.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Gửi mã'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
