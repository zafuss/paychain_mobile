import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:paychain_mobile/data/models/wallet.dart';
import 'package:paychain_mobile/modules/auth/controllers/auth_controller.dart';
import 'package:paychain_mobile/modules/localdata/local_data_controller.dart';
import 'package:paychain_mobile/modules/wallet/controllers/wallet_controller.dart';
import 'package:paychain_mobile/utils/constants/color_const.dart';
import 'package:paychain_mobile/utils/constants/demension_const.dart';
import 'package:paychain_mobile/routes/routes.dart';
import 'package:paychain_mobile/modules/home/controllers/home_controller.dart';

import '../../../utils/helpers/shared_preferences_service.dart'; // Import SharedPreferencesService

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Hàm lấy dữ liệu từ SharedPreferences
  Future<Map<String, String?>> _loadUserData() async {
    final prefsService = SharedPreferencesService();

    // Lấy dữ liệu từ SharedPreferences
    String? email =
        await prefsService.getString(SharedPreferencesService.EMAIL);
    String? phoneNumber =
        await prefsService.getString(SharedPreferencesService.PHONE_NUMBER);
    String? name = await prefsService.getString(SharedPreferencesService.NAME);

    // Trả về dữ liệu dưới dạng Map
    return {
      'email': email,
      'phone': phoneNumber,
      'name': name,
    };
  }

  @override
  Widget build(BuildContext context) {
    final _homeController = Get.put(HomeController());
    final _walletController = Get.put(WalletController());
    final _localDataController = Get.put(LocalDataController());
    return Scaffold(
      body: Stack(
        children: [
          // Nền màu xanh
          Container(
            color: ColorPalette.primary1,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text nằm trên Container
              Padding(
                padding: const EdgeInsets.only(
                    left: kDefaultPadding, bottom: kMinPadding),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          'Xin chào ${_localDataController.currentName.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text('Thoát'),
                                        content: const Text(
                                            'Bạn có chắc chắn muốn thoát không?'),
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
                                              final prefsService =
                                                  SharedPreferencesService();
                                              prefsService.saveBool(
                                                  SharedPreferencesService
                                                      .IS_LOGGED_IN,
                                                  false);
                                              Get.delete<AuthController>(
                                                  force: true);
                                              Get.offAndToNamed(
                                                  Routes.loginScreen);
                                            },
                                            child: const Text('Có'),
                                          ),
                                        ],
                                      ));
                            },
                            icon: const Icon(
                              Icons.logout_outlined,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ),
              ),
              // Container màu trắng lấp toàn bộ phía dưới
              Obx(
                () => _homeController.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.98),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(kMinPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    padding: const EdgeInsets.all(kMinPadding),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Số dư hiện tại',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium,
                                                  ),
                                                  const SizedBox(
                                                      width: kMinPadding / 4),
                                                  InkWell(
                                                    onTap: () {
                                                      _homeController
                                                              .isHiddenBalance
                                                              .value =
                                                          !_homeController
                                                              .isHiddenBalance
                                                              .value;
                                                    },
                                                    child: _homeController
                                                            .isHiddenBalance
                                                            .value
                                                        ? const Icon(
                                                            size: 20,
                                                            Icons
                                                                .visibility_outlined)
                                                        : const Icon(
                                                            Icons
                                                                .visibility_off_outlined,
                                                            size: 20,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  // Lắng nghe sự thay đổi số dư và đơn vị tiền
                                                  Text(
                                                    _homeController
                                                            .isHiddenBalance
                                                            .value
                                                        ? '******'
                                                        : '${_walletController.selectedWallet.value?.balance ?? 0}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  // Dropdown để chọn đơn vị tiền
                                                  DropdownButton<Wallet>(
                                                    padding: EdgeInsets.zero,
                                                    underline: const SizedBox(),
                                                    value: _walletController
                                                        .selectedWallet.value,
                                                    items: _walletController
                                                        .wallets
                                                        .map((wallet) {
                                                      return DropdownMenuItem<
                                                          Wallet>(
                                                        value: wallet,
                                                        child: Text(
                                                            wallet.nameNode),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (Wallet? wallet) {
                                                      if (wallet != null) {
                                                        _walletController
                                                            .selectWallet(
                                                                wallet);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                              onPressed: () {},
                                              child: const Text('Nạp tiền')),
                                        ),
                                      ],
                                    )),
                                const SizedBox(height: kMinPadding),
                                Expanded(
                                  child: GridView.count(
                                    padding: EdgeInsets.zero,
                                    crossAxisCount: 3, // Số cột tối thiểu là 3
                                    crossAxisSpacing: 16.0,
                                    mainAxisSpacing: 16.0,
                                    children: [
                                      CustomGridItem(
                                          title: 'Tài khoản',
                                          index: 1,
                                          imageUrl:
                                              'assets/images/wallet_icon.png'),
                                      CustomGridItem(
                                          title: 'Chuyển tiền',
                                          index: 2,
                                          onPressed: () {
                                            return Get.toNamed(
                                                Routes.transferScreen);
                                          },
                                          imageUrl:
                                              'assets/images/transfer_icon.png'),
                                      CustomGridItem(
                                          title: 'Danh bạ',
                                          index: 3,
                                          imageUrl:
                                              'assets/images/contacts_icon.png'),
                                      CustomGridItem(
                                          title: 'Lịch sử',
                                          index: 4,
                                          imageUrl:
                                              'assets/images/history_icon.png'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              // Footer content luôn nằm dưới cùng
            ],
          ),
        ],
      ),
    );
  }

  Column _buildInfoRow(String title, String content) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: kMinPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.body1),
              Text(
                content,
                style:
                    AppTextStyles.body1.copyWith(color: ColorPalette.primary1),
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: ColorPalette.tfBorder,
        ),
      ],
    );
  }
}

class CustomGridItem extends StatelessWidget {
  final int index;
  final String title;
  final String imageUrl;
  final Function()? onPressed;
  CustomGridItem(
      {required this.index,
      required this.title,
      required this.imageUrl,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          print('Item $index tapped');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imageUrl, height: 40),
            const SizedBox(height: 8),
            Text(title, // Thay thế bằng tiêu đề bạn muốn
                style: AppTextStyles.caption1),
          ],
        ),
      ),
    );
  }
}
