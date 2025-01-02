import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/config/color_const.dart';
import 'package:paychain_mobile/config/demension_const.dart';
import 'package:paychain_mobile/config/routes.dart';

import '../../helpers/shared_preferences_service.dart'; // Import SharedPreferencesService

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

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
              const Padding(
                padding:
                    EdgeInsets.only(left: kDefaultPadding, bottom: kMinPadding),
                child: SafeArea(
                  bottom: false,
                  child: Text(
                    'Cài đặt',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Container màu trắng lấp toàn bộ phía dưới
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: FutureBuilder<Map<String, String?>>(
                    future: _loadUserData(), // Lấy dữ liệu từ SharedPreferences
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator()); // Chờ dữ liệu
                      } else if (snapshot.hasError) {
                        return Center(
                            child:
                                Text('Error: ${snapshot.error}')); // Nếu có lỗi
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(
                            child:
                                Text('No data found')); // Nếu không có dữ liệu
                      } else {
                        var data = snapshot.data!; // Dữ liệu đã được tải
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(kDefaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data['email'] ?? 'Email chưa có',
                                    style: AppTextStyles.title2.copyWith(
                                        color: ColorPalette.primary1)),
                                const SizedBox(height: kMinPadding),
                                _buildButton('Thông tin cá nhân',
                                    () => Get.toNamed(Routes.infoScreen)),
                                _buildButton('Đổi mật khẩu',
                                    () => Get.toNamed(Routes.infoScreen)),
                                _buildButton('Thông tin',
                                    () => Get.toNamed(Routes.infoScreen)),
                              ],
                            ),
                          ),
                        );
                      }
                    },
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

  Widget _buildButton(String title, Function()? onPressed) {
    return InkWell(
      onTap: () {
        onPressed != null ? onPressed() : {};
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kMinPadding),
            child: Text(title, style: AppTextStyles.body1),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: ColorPalette.tfBorder,
          ),
        ],
      ),
    );
  }
}
