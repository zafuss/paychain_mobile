import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/utils/constants/demension_const.dart';
import 'package:paychain_mobile/utils/extensions/ext_box_decoration.dart';
import 'package:paychain_mobile/shared/widgets/widgets.dart';

import '../controllers/auth_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: 'Đổi mật khẩu',
        onBackPressed: () {
          Get.back();
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nhập mật khẩu hiện tại',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: kMinPadding),
                    TextField(
                      obscureText: true,
                      controller: authController.currentPasswordController,
                      decoration: const InputDecoration(
                        hintText: 'Mật khẩu hiện tại',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: kMinPadding),
                    Text(
                      'Nhập mật khẩu mới',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: kMinPadding),
                    TextField(
                      obscureText: true,
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
                    TextField(
                      obscureText: true,
                      controller: authController.confirmPasswordController,
                      decoration: const InputDecoration(
                        hintText: 'Xác nhận mật khẩu',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(
                  height: kMinPadding,
                ),
                Obx(() => ElevatedButton(
                    onPressed: () async {
                      await authController.changePassword();
                    },
                    child: authController.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Đổi mật khẩu')))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
