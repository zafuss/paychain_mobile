import 'package:get/get.dart';

class TransferController extends GetxController {
  var isLoading = false.obs;
  var isSaveContactChecked = false.obs;

  var selectedCurrency =
      'BTC - 0123456789'.obs; // Đơn vị tiền tệ (obs để có thể lắng nghe)
  var balance = 0.002.obs; // Số dư (obs để có thể lắng nghe)

  // Hàm thay đổi số dư theo đơn vị tiền
  void updateBalance(String currency) {
    selectedCurrency.value = currency;
    if (currency == 'BTC - 0123456789') {
      balance.value = 0.002;
    } else if (currency == 'ETH - 0123456789') {
      balance.value = 0.05;
    } else if (currency == 'USDT - 0123456789') {
      balance.value = 5.0;
    }
  }
}
