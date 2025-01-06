import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/routes/routes.dart';
import 'package:paychain_mobile/utils/constants/color_const.dart';
import 'package:paychain_mobile/utils/constants/demension_const.dart';
import 'package:paychain_mobile/modules/transfer/controllers/transfer_controller.dart';

import '../../../shared/widgets/custom_appbar.dart';

class SuccessTransferScreen extends StatelessWidget {
  const SuccessTransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).brightness);
    // Đặt chế độ light status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    // ignore: no_leading_underscores_for_local_identifiers
    final _transferController = Get.put(TransferController());

    // _walletController.connect(authController.currentEmail.value);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          context: context,
          title: 'Chuyển tiền thành công',
          onBackPressed: () {
            Get.back();
          },
        ),
        body: Stack(
          children: [
            Container(color: Colors.white),
            Obx(
              () => _transferController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/success_transfer.png"),
                            const SizedBox(height: kDefaultPadding),
                            Text(
                              'Chuyển tiền thành công!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: ColorPalette.primary1,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: kDefaultPadding),
                            ElevatedButton(
                                onPressed: () {
                                  Get.offAndToNamed(Routes.mainWrapper);
                                },
                                child: const Text('Quay lại màn hình chính')),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
