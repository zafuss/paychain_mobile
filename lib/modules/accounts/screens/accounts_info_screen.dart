import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/modules/wallet/controllers/wallet_controller.dart';
import 'package:paychain_mobile/utils/constants/color_const.dart';
import 'package:paychain_mobile/utils/constants/demension_const.dart';
import 'package:paychain_mobile/utils/extensions/ext_box_decoration.dart';

import '../../../../../../shared/widgets/custom_appbar.dart';

class AccountSInfoScreen extends StatelessWidget {
  const AccountSInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).brightness);
    // Đặt chế độ light status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    final _walletController = Get.find<WalletController>();
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          context: context,
          title: 'Ví',
          onBackPressed: () {
            Get.back();
          },
        ),
        body: Stack(
          children: [
            Container(color: Colors.white),
            Obx(
              () => _walletController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () async {},
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        children: [
                          if (_walletController.wallets.isEmpty)
                            const Text(
                              'Bạn chưa có ví nào',
                            )
                          else
                            ..._walletController.wallets.map((wallet) =>
                                InkWell(
                                  borderRadius: BorderRadius.circular(
                                      defaultBorderRadius),
                                  onTap: () {},
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: kDefaultPadding),
                                    decoration:
                                        Theme.of(context).defaultBoxDecoration,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding,
                                          vertical: kMinPadding),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Số ví",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              Text(
                                                wallet.account,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge!
                                                    .copyWith(
                                                        color: ColorPalette
                                                            .primary1),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: kMinPadding / 2,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Loại tiền",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              Text(
                                                wallet.nameNode,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge!
                                                    .copyWith(
                                                        color: ColorPalette
                                                            .primary1),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: kMinPadding / 2,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Số dư",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              Text(
                                                wallet.balance.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge!
                                                    .copyWith(
                                                        color: ColorPalette
                                                            .primary1),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: kMinPadding / 2,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Số lần giao dịch",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              Text(
                                                wallet.transactions != null
                                                    ? wallet
                                                        .transactions!.length
                                                        .toString()
                                                    : "Chưa có",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge!
                                                    .copyWith(
                                                        color: ColorPalette
                                                            .primary1),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: kMinPadding / 2,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "NodeID",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              Text(
                                                wallet.nodeId ?? "Không có",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge!
                                                    .copyWith(
                                                        color: ColorPalette
                                                            .primary1),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: kMinPadding,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                    onPressed: () {
                                                      var textToCopy =
                                                          wallet.account;
                                                      Clipboard.setData(
                                                              ClipboardData(
                                                                  text:
                                                                      textToCopy))
                                                          .then((_) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'Đã sao chép vào clipboard: $textToCopy'),
                                                            duration:
                                                                const Duration(
                                                                    seconds: 2),
                                                          ),
                                                        );
                                                      });
                                                    },
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.copy,
                                                          color: ColorPalette
                                                              .primary1,
                                                        ),
                                                        Text(' Số ví'),
                                                      ],
                                                    )),
                                              ),
                                              SizedBox(
                                                width: wallet.nodeId != null
                                                    ? kMinPadding / 2
                                                    : 0,
                                              ),
                                              wallet.nodeId != null
                                                  ? Expanded(
                                                      child: OutlinedButton(
                                                          onPressed: () {
                                                            var textToCopy =
                                                                wallet.nodeId!;
                                                            Clipboard.setData(
                                                                    ClipboardData(
                                                                        text:
                                                                            textToCopy))
                                                                .then((_) {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                      'Đã sao chép vào clipboard: $textToCopy'),
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              2),
                                                                ),
                                                              );
                                                            });
                                                          },
                                                          child: const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons.copy,
                                                                color:
                                                                    ColorPalette
                                                                        .primary1,
                                                              ),
                                                              Text(' NodeID'),
                                                            ],
                                                          )),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
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
