import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:paychain_mobile/config/color_const.dart';
import 'package:paychain_mobile/screens/screens.dart';

import '../features/home/controllers/main_wrapper_controller.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late PageController pageController;
  final _mainWrapperController = Get.put(MainWrapperController());
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  /// Top Level Pages
  final List<Widget> topLevelPages = const [HomeScreen(), SettingScreen()];

  /// on Page Changed
  void onPageChanged(int page) {
    // BlocProvider.of<BottomNavCubit>(context).changeSelectedIndex(page);
    _mainWrapperController.pageIndex.value = page;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mainWrapperBody(),
      bottomNavigationBar: _mainWrapperBottomNavBar(context),
    );
  }

  // Bottom Navigation Bar - MainWrapper Widget
  BottomAppBar _mainWrapperBottomNavBar(BuildContext context) {
    return BottomAppBar(
      height: 70,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bottomAppBarItem(
                  context,
                  defaultIcon: Image.asset(
                    'assets/images/home_outline.png',
                    height: 20,
                  ),
                  page: 0,
                  label: "Trang chủ",
                  filledIcon: Image.asset(
                    'assets/images/home_filled.png',
                    height: 20,
                  ),
                ),
                _bottomAppBarItem(
                  context,
                  defaultIcon: Image.asset(
                    'assets/images/setting_outline.png',
                    height: 20,
                  ),
                  page: 1,
                  label: "Cài đặt",
                  filledIcon: Image.asset(
                    'assets/images/setting_filled.png',
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Body - MainWrapper Widget
  PageView _mainWrapperBody() {
    return PageView(
      onPageChanged: (int page) => onPageChanged(page),
      controller: pageController,
      children: topLevelPages,
    );
  }

  // Bottom Navigation Bar Single item - MainWrapper Widget
  Widget _bottomAppBarItem(
    BuildContext context, {
    required defaultIcon,
    required page,
    required label,
    required filledIcon,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        _mainWrapperController.pageIndex.value = page;
        pageController.animateToPage(
          page,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn,
        );
      },
      child: Obx(
        () => AnimatedContainer(
          width: 120,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: _mainWrapperController.pageIndex.value == page
                ? ColorPalette.primary1
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.bounceIn,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      AnimatedSwitcher(
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        duration: const Duration(milliseconds: 300),
                        child: _mainWrapperController.pageIndex.value == page
                            ? filledIcon
                            : defaultIcon,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      AnimatedCrossFade(
                        firstChild: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        secondChild: const SizedBox.shrink(),
                        crossFadeState:
                            _mainWrapperController.pageIndex.value == page
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
