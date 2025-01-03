import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/config/color_const.dart';
import 'package:paychain_mobile/config/demension_const.dart';
import 'package:paychain_mobile/extensions/ext_box_decoration.dart';
import 'package:paychain_mobile/features/transfer/controllers/transfer_controller.dart';

import '../../features/auth/controllers/auth_controller.dart';
import '../../widgets/custom_appbar.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).brightness);
    // Đặt chế độ light status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    final authController = Get.find<AuthController>();
    // ignore: no_leading_underscores_for_local_identifiers
    final _transferController = Get.put(TransferController());
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          context: context,
          title: 'Chuyển tiền',
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
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 15),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorPalette.tfBorder,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(
                                        defaultBorderRadius),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorPalette.tfBorder,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(
                                        defaultBorderRadius),
                                  ),
                                  labelStyle: TextStyle(color: Colors.grey),
                                ),
                                value:
                                    _transferController.selectedCurrency.value,
                                items: [
                                  'BTC - 0123456789',
                                  'ETH - 0123456789',
                                  'USDT - 0123456789',
                                ].map((currency) {
                                  return DropdownMenuItem<String>(
                                    value: currency,
                                    child: Text(currency),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    _transferController.updateBalance(newValue);
                                  }
                                },
                                dropdownColor:
                                    Colors.white, // Màu nền của dropdown menu
                                style: TextStyle(
                                    color: Colors
                                        .black), // Màu chữ trong dropdown menu
                              ),
                              SizedBox(
                                height: kMinPadding / 3,
                              ),
                              Text(
                                'Số dư hiện tại: ${_transferController.balance.value}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: ColorPalette.primary1,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: kDefaultPadding),
                          Container(
                            decoration: Theme.of(context).defaultBoxDecoration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding,
                                  vertical: kDefaultPadding),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    controller: authController.otpController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'Số tài khoản',
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(height: kMinPadding),
                                  TextField(
                                    enabled: false,
                                    controller: authController.otpController,
                                    decoration: const InputDecoration(
                                      hintText: 'Tên người nhận',
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(height: kMinPadding),
                                  TextField(
                                    controller: authController.otpController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'Số tiền',
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(height: kMinPadding),
                                  TextField(
                                    maxLines: 3,
                                    controller: authController.otpController,
                                    decoration: const InputDecoration(
                                      hintText: 'Nội dung',
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(height: kMinPadding),
                                  GestureDetector(
                                    onTap: () {
                                      _transferController
                                              .isSaveContactChecked.value =
                                          !_transferController
                                              .isSaveContactChecked.value;
                                    },
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          _transferController
                                                  .isSaveContactChecked.value
                                              ? 'assets/images/checked_icon.png'
                                              : 'assets/images/uncheck_icon.png',
                                          height: 15,
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            'Lưu người nhận',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .copyWith(
                                                  color: _transferController
                                                          .isSaveContactChecked
                                                          .value
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .labelLarge!
                                                          .color,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: kMinPadding),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Xử lý sự kiện nút bấm
                                    },
                                    child: const Text('Tiếp tục'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
