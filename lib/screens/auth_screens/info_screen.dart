import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paychain_mobile/config/color_const.dart';
import 'package:paychain_mobile/config/demension_const.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: ColorPalette.primary1, // Màu nền của status bar
    //   statusBarIconBrightness: Brightness.light,
    // ));
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
                    'Thông tin cá nhân',
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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                child: Image.asset(
                                    'assets/images/fingerprint.png'),
                              ),
                              const SizedBox(
                                width: kMinPadding,
                              ),
                              Expanded(
                                child: Text('zafus2103@gmail.com',
                                    style: AppTextStyles.title2.copyWith(
                                        color: ColorPalette.primary1)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: kMinPadding,
                          ),
                          _buildInfoRow('Tên hiển thị', 'Tên'),
                          _buildInfoRow('Số điện thoại', '0823216213'),
                          // _buildInfoRow('Tên hiển thị', 'Tên'),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              // Xử lý sự kiện nút bấm
                            },
                            child: const Text('Đổi mật khẩu'),
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
