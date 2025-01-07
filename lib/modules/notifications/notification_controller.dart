import 'package:get/get.dart';
import 'package:paychain_mobile/data/services/notifications/notification_service.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  final NotificationService notificationService = NotificationService();

  @override
  void onInit() async {
    super.onInit();
    notificationService.connect(_onNotificationUpdated);
  }

  @override
  void onClose() {
    super.onClose();
    notificationService.disconnect();
  }

  void _onNotificationUpdated(String message) {
    if (message.isNotEmpty) {
      Get.snackbar('Thông báo', message);
    }
  }
}
