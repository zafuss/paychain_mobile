import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/data/models/wallet.dart';
import 'package:paychain_mobile/modules/wallet/controllers/wallet_controller.dart';
import 'package:paychain_mobile/utils/constants/color_const.dart';
import 'package:paychain_mobile/utils/constants/demension_const.dart';
import 'package:paychain_mobile/utils/extensions/ext_box_decoration.dart';
import 'package:paychain_mobile/modules/transfer/controllers/transfer_controller.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../../shared/widgets/custom_appbar.dart';

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
    final _walletController = Get.put(WalletController());
    // _walletController.connect(authController.currentEmail.value);
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
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DropdownButtonFormField<Wallet>(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 15),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: ColorPalette.tfBorder,
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(
                                          defaultBorderRadius),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: ColorPalette.tfBorder,
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(
                                          defaultBorderRadius),
                                    ),
                                    labelStyle:
                                        const TextStyle(color: Colors.grey),
                                  ),
                                  value: _walletController.selectedWallet.value,
                                  items:
                                      _walletController.wallets.map((wallet) {
                                    return DropdownMenuItem<Wallet>(
                                      value: wallet,
                                      child: Text(
                                          '${wallet.nameNode} - ${wallet.account}'),
                                    );
                                  }).toList(),
                                  onChanged: (Wallet? wallet) {
                                    if (wallet != null) {
                                      _walletController.selectWallet(wallet);
                                    }
                                  },
                                  dropdownColor:
                                      Colors.white, // Màu nền của dropdown menu
                                  style: const TextStyle(
                                      color: Colors
                                          .black), // Màu chữ trong dropdown menu
                                ),
                                const SizedBox(
                                  height: kMinPadding / 3,
                                ),
                                Text(
                                  'Số dư hiện tại: ${_walletController.selectedWallet.value!.balance}',
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
                              decoration:
                                  Theme.of(context).defaultBoxDecoration,
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
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text(
                                                      'Xác nhận chuyển tiền'),
                                                  content: Column(
                                                    children: [
                                                      const Text(
                                                          'Thông tin giao dịch: '),
                                                      Text(
                                                          'Số tài khoản: ${authController.otpController.text}'),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: const Text('Hủy'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                        // Xử lý chuyển tiền
                                                      },
                                                      child: const Text(
                                                          'Chuyển tiền'),
                                                    ),
                                                  ],
                                                ));
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
            ),
          ],
        ),
      ),
    );
  }
}
