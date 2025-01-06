import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/utils/constants/color_const.dart';
import 'package:paychain_mobile/utils/constants/demension_const.dart';
import 'package:paychain_mobile/utils/extensions/ext_box_decoration.dart';
import 'package:paychain_mobile/modules/transfer/controllers/transfer_controller.dart';

import '../../../../shared/widgets/custom_appbar.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).brightness);
    // Đặt chế độ light status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    final _transferController = Get.put(TransferController());
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          context: context,
          title: 'Danh bạ',
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
                  : RefreshIndicator(
                      onRefresh: () async {
                        await _transferController.getContactList();
                      },
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        children: [
                          if (_transferController.contactList.isEmpty)
                            const Text(
                              'Danh bạ trống, để lưu một tài khoản vào danh bạ, vui lòng chọn "Lưu người nhận" khi thực hiện giao dịch.',
                            )
                          else
                            ..._transferController.contactList.map((contact) =>
                                Container(
                                  margin: const EdgeInsets.only(
                                      bottom: kMinPadding),
                                  decoration:
                                      Theme.of(context).defaultBoxDecoration,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding,
                                        vertical: kMinPadding),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                                text: TextSpan(
                                                    text: 'Số tài khoản: ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                    children: [
                                                  TextSpan(
                                                      text: contact.account,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                              color: ColorPalette
                                                                  .primary1))
                                                ])),
                                            RichText(
                                                text: TextSpan(
                                                    text: 'Tên tài khoản: ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                    children: [
                                                  TextSpan(
                                                      text: contact.name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                              color: ColorPalette
                                                                  .primary1))
                                                ])),
                                          ],
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              var textToCopy =
                                                  "${contact.account} - ${contact.name}";
                                              Clipboard.setData(ClipboardData(
                                                      text: textToCopy))
                                                  .then((_) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Đã sao chép vào clipboard: $textToCopy'),
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.copy,
                                              color: ColorPalette.primary1,
                                            ))
                                      ],
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
