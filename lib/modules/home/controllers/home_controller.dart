import 'package:get/get.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var isHiddenBalance = false.obs;
  // Các biến cần thiết
  var selectedCurrency = 'BTC'.obs; // Đơn vị tiền tệ (obs để có thể lắng nghe)
  var balance = 0.002.obs; // Số dư (obs để có thể lắng nghe)

  // Hàm thay đổi số dư theo đơn vị tiền
  void updateBalance(String currency) {
    selectedCurrency.value = currency;
    if (currency == 'BTC') {
      balance.value = 0.002;
    } else if (currency == 'ETH') {
      balance.value = 0.05;
    } else if (currency == 'USDT') {
      balance.value = 5.0;
    }
  }
}
