import 'package:get/get.dart';
import 'package:paychain_mobile/utils/helpers/helpers.dart';

class LocalDataController extends GetxController {
  final SharedPreferencesService service = SharedPreferencesService();
  final currentEmail = ''.obs;
  final currentName = ''.obs;
  final currentPhone = ''.obs;
  final accessToken = ''.obs;
  final refreshToken = ''.obs;
  final isLoggedIn = false.obs;

  @override
  void onInit() async {
    super.onInit();
    loadAllUserData();
  }

  void loadAllUserData() async {
    currentEmail.value =
        await service.getString(SharedPreferencesService.EMAIL) ?? '';
    currentName.value =
        await service.getString(SharedPreferencesService.NAME) ?? '';
    currentPhone.value =
        await service.getString(SharedPreferencesService.PHONE_NUMBER) ?? '';
    accessToken.value =
        await service.getString(SharedPreferencesService.ACCESS_TOKEN) ?? '';
    refreshToken.value =
        await service.getString(SharedPreferencesService.REFRESH_TOKEN) ?? '';
    isLoggedIn.value =
        await service.getBool(SharedPreferencesService.IS_LOGGED_IN) ?? false;
  }
}
