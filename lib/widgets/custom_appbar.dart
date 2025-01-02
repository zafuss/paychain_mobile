import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paychain_mobile/config/demension_const.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // Title is optional
  final VoidCallback? onBackPressed; // Show back button if provided
  final BuildContext context;

  CustomAppBar({
    required this.context,
    this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0, // No shadow
        title: Row(
          children: [
            if (onBackPressed != null)
              IconButton(
                iconSize: 20,
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: onBackPressed,
              ),
            if (onBackPressed == null)
              const SizedBox(width: kDefaultPadding / 2),
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
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Default AppBar height
}
