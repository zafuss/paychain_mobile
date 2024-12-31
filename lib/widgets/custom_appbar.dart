import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paychain_mobile/config/demension_const.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // Title is optional
  final VoidCallback? onBackPressed; // Show back button if provided

  CustomAppBar({
    this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Đảm bảo StatusBar có nền trong suốt
      statusBarIconBrightness: Brightness
          .dark, // Thiết lập màu sắc của icon và chữ (dark hoặc light)
      statusBarBrightness:
          Brightness.light, // Đảm bảo màu nền sáng cho thanh trạng thái
    ));
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent, // Transparent background
      elevation: 0, // No shadow
      title: Row(
        children: [
          if (onBackPressed != null)
            IconButton(
              iconSize: 20,
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: onBackPressed,
            ),
          if (onBackPressed == null) const SizedBox(width: kDefaultPadding / 2),
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
        ],
      ),
      centerTitle: false, // Title aligns to the left
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Default AppBar height
}
