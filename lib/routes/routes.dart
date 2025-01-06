import 'package:get/route_manager.dart';

import '../screens/screens.dart';

class Routes {
  static String loginScreen = '/login';
  static String registerScreen = '/register';
  static String infoScreen = '/info';
  static String otpScreen = '/otpScreen';
  static String forgotPasswordScreen = '/forgotPasswordScreen';
  static String homeScreen = '/homeScreen';
  static String mainWrapper = '/mainWrapper';
  static String settingScreen = '/settingScreen';
  static String transferScreen = '/transferScreen';
  static String successTransferScreen = '/successTransferScreen';
  static String contactListScreen = '/contactListScreen';
  static String transactionsHistoryScreen = '/transactionsHistoryScreen';
}

final getPages = [
  GetPage(name: Routes.loginScreen, page: () => const LoginScreen()),
  GetPage(name: Routes.registerScreen, page: () => const RegisterScreen()),
  GetPage(name: Routes.infoScreen, page: () => const InfoScreen()),
  GetPage(name: Routes.otpScreen, page: () => const OtpScreen()),
  GetPage(
      name: Routes.forgotPasswordScreen,
      page: () => const ForgotPasswordScreen()),
  GetPage(name: Routes.homeScreen, page: () => const HomeScreen()),
  GetPage(name: Routes.mainWrapper, page: () => const MainWrapper()),
  GetPage(name: Routes.settingScreen, page: () => const SettingScreen()),
  GetPage(name: Routes.transferScreen, page: () => const TransferScreen()),
  GetPage(
      name: Routes.successTransferScreen,
      page: () => const SuccessTransferScreen()),
  GetPage(
      name: Routes.contactListScreen, page: () => const ContactListScreen()),
  GetPage(
      name: Routes.transactionsHistoryScreen,
      page: () => const TransactionsHistoryScreen()),
];
