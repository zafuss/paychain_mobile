import 'package:get/route_manager.dart';

import '../screens/screens.dart';

class Routes {
  static String loginScreen = '/login';
  static String registerScreen = '/register';
  static String infoScreen = '/info';
  static String otpScreen = '/otpScreen';
}

final getPages = [
  GetPage(name: Routes.loginScreen, page: () => const LoginScreen()),
  GetPage(name: Routes.registerScreen, page: () => const RegisterScreen()),
  GetPage(name: Routes.infoScreen, page: () => const InfoScreen()),
  GetPage(name: Routes.otpScreen, page: () => const OtpScreen()),
];
