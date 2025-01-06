import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/modules/transactions_history/controllers/transactions_history_controller.dart';
import 'package:paychain_mobile/utils/constants/color_const.dart';
import 'package:paychain_mobile/utils/constants/demension_const.dart';
import 'package:paychain_mobile/utils/extensions/ext_box_decoration.dart';

import '../../../../../shared/widgets/custom_appbar.dart';

class TransactionsHistoryScreen extends StatelessWidget {
  const TransactionsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).brightness);
    // Đặt chế độ light status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    final _transactionsHistoryController =
        Get.put(TransactionsHistoryController());
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          context: context,
          title: 'Lịch sử giao dịch',
          onBackPressed: () {
            Get.back();
          },
        ),
        body: Stack(
          children: [
            Container(color: Colors.white),
            Obx(
              () => _transactionsHistoryController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () async {
                        await _transactionsHistoryController
                            .getTransactionList();
                      },
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        children: [
                          if (_transactionsHistoryController
                              .transactionList.isEmpty)
                            const Text(
                              'Bạn chưa có giao dịch nào',
                            )
                          else
                            ..._transactionsHistoryController.transactionList
                                .map((transaction) => InkWell(
                                      borderRadius: BorderRadius.circular(
                                          defaultBorderRadius),
                                      onTap: () {
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
                                                0.6, // Chiếm 50% chiều cao màn hình
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
                                                        'Thông tin giao dịch',
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
                                                                  transaction
                                                                      .accountSender,
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
                                                                  transaction
                                                                      .accountReceiver,
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
                                                                  transaction
                                                                      .nameReceiver,
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
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    textDirection:
                                                                        TextDirection
                                                                            .ltr,
                                                                    transaction
                                                                        .message!,
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
                                                                  'Thời gian',
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
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    textDirection:
                                                                        TextDirection
                                                                            .ltr,
                                                                    transaction
                                                                        .timestamp!,
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
                                                                  '${transaction.amount} 3RG',
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
                                                      Get.back();
                                                    },
                                                    child: const Text('Đóng'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: kDefaultPadding),
                                        decoration: Theme.of(context)
                                            .defaultBoxDecoration,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: kDefaultPadding,
                                              vertical: kMinPadding),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                  text: TextSpan(
                                                      text: transaction
                                                                  .typeTransaction ==
                                                              "SENDER"
                                                          ? 'Chuyển tiền đến '
                                                          : 'Nhận tiền từ ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge,
                                                      children: [
                                                    TextSpan(
                                                      text: transaction
                                                          .nameReceiver,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                              color: ColorPalette
                                                                  .primary1),
                                                    )
                                                  ])),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    transaction.timestamp ?? "",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium,
                                                  ),
                                                  Text(
                                                    transaction.typeTransaction ==
                                                            "SENDER"
                                                        ? '-${transaction.amount} 3RG'
                                                        : '+${transaction.amount} 3RG',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge!
                                                        .copyWith(
                                                            color: transaction
                                                                        .typeTransaction ==
                                                                    "SENDER"
                                                                ? Colors.red
                                                                : Colors.green),
                                                  ),
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
