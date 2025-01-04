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
    final _authController = Get.find<AuthController>();
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
                                      onChanged: (value) async {
                                        Future.delayed(Durations.extralong4,
                                            () async {
                                          await _transferController
                                              .getUserByAccount(
                                                  _transferController
                                                      .receiveAccountController
                                                      .text,
                                                  _walletController
                                                      .selectedWallet
                                                      .value!
                                                      .account);
                                        });
                                      },
                                      onTapOutside: (event) async {
                                        await _transferController
                                            .getUserByAccount(
                                                _transferController
                                                    .receiveAccountController
                                                    .text,
                                                _walletController.selectedWallet
                                                    .value!.account);
                                      },
                                      onEditingComplete: () async {
                                        await _transferController
                                            .getUserByAccount(
                                                _transferController
                                                    .receiveAccountController
                                                    .text,
                                                _walletController.selectedWallet
                                                    .value!.account);
                                      },
                                      controller: _transferController
                                          .receiveAccountController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide(
                                              color: _transferController
                                                      .errorString
                                                      .value
                                                      .isNotEmpty
                                                  ? Colors.red
                                                  : ColorPalette.primary1,
                                              width: 1),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: _transferController
                                                      .errorString
                                                      .value
                                                      .isNotEmpty
                                                  ? Colors.red
                                                  : ColorPalette.tfBorder,
                                              width: 1.0),
                                          borderRadius: BorderRadius.circular(
                                              defaultBorderRadius),
                                        ),
                                        suffixIcon: _transferController
                                                .isGettingUser.value
                                            ? const SizedBox(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                    color:
                                                        ColorPalette.primary1,
                                                  ),
                                                ),
                                              )
                                            : null,
                                        hintText: 'Số tài khoản',
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    _transferController
                                            .errorString.value.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: kMinPadding / 2),
                                            child: Text(
                                              _transferController
                                                  .errorString.value,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium!
                                                  .copyWith(
                                                    color: Colors.red,
                                                  ),
                                            ),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(height: kMinPadding),
                                    TextField(
                                      enabled: false,
                                      controller: _transferController
                                          .receiveNameController,
                                      decoration: const InputDecoration(
                                        hintText: 'Tên người nhận',
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: kMinPadding),
                                    TextField(
                                      controller:
                                          _transferController.amountController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: 'Số tiền',
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: kMinPadding),
                                    TextField(
                                      maxLines: 3,
                                      controller: _transferController
                                          .transferNoteController,
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
                                        showModalBottomSheet(
                                          backgroundColor: Colors.white,
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20.0)),
                                          ),
                                          isScrollControlled:
                                              true, // Cho phép kiểm soát chiều cao
                                          builder: (context) =>
                                              FractionallySizedBox(
                                            heightFactor:
                                                0.5, // Chiếm 50% chiều cao màn hình
                                            widthFactor: 1,
                                            child: Container(
                                              padding: const EdgeInsets.all(
                                                  kDefaultPadding),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Xác nhận chuyển tiền',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                        child: const Icon(
                                                          Icons.close,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: kMinPadding,
                                                  ),
                                                  Container(
                                                    decoration: Theme.of(
                                                            context)
                                                        .defaultBoxDecoration,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              kDefaultPadding),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'Tài khoản chuyển',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .labelLarge!,
                                                                ),
                                                                Text(
                                                                  _walletController
                                                                      .selectedWallet
                                                                      .value!
                                                                      .account,
                                                                  style: const TextStyle(
                                                                      color: ColorPalette
                                                                          .primary1,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height:
                                                                  kMinPadding,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'Tài khoản nhận',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .labelLarge!,
                                                                ),
                                                                Text(
                                                                  _transferController
                                                                      .receiveAccountController
                                                                      .text,
                                                                  style: const TextStyle(
                                                                      color: ColorPalette
                                                                          .primary1,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height:
                                                                  kMinPadding,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'Tên người nhận',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .labelLarge!,
                                                                ),
                                                                Text(
                                                                  _transferController
                                                                      .receiveNameController
                                                                      .text,
                                                                  style: const TextStyle(
                                                                      color: ColorPalette
                                                                          .primary1,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height:
                                                                  kMinPadding,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'Nội dung',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .labelLarge!,
                                                                ),
                                                                const SizedBox(
                                                                  width:
                                                                      kMinPadding,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    textDirection:
                                                                        TextDirection
                                                                            .rtl,
                                                                    _transferController
                                                                        .transferNoteController
                                                                        .text,
                                                                    style: const TextStyle(
                                                                        color: ColorPalette
                                                                            .primary1,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      kMinPadding),
                                                              child: Container(
                                                                height: 1,
                                                                color:
                                                                    ColorPalette
                                                                        .tfBorder,
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Text(
                                                                  'Số tiền',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                                Text(
                                                                  '${_transferController.amountController.text} ${_walletController.selectedWallet.value!.nameNode}',
                                                                  style: const TextStyle(
                                                                      color: ColorPalette
                                                                          .primary1,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      height: kMinPadding),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      if (_authController
                                                          .canCheckBiometrics
                                                          .value) {
                                                        bool _authResult =
                                                            await _authController
                                                                .transferAuthenticate();
                                                        if (_authResult) {
                                                          Get.back();
                                                          await _transferController
                                                              .sendTransaction(
                                                                  _walletController
                                                                      .selectedWallet
                                                                      .value!
                                                                      .account);
                                                        } else {
                                                          Get.snackbar(
                                                              'Xác thực thất bại',
                                                              'Vui lòng thử lại');
                                                          Get.back();
                                                        }
                                                      }
                                                    },
                                                    child:
                                                        const Text('Xác nhận'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
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
