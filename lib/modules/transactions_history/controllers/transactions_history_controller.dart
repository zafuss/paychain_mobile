import 'package:get/get.dart';
import 'package:paychain_mobile/data/models/base_response.dart';
import 'package:paychain_mobile/data/models/transaction.dart';
import 'package:paychain_mobile/data/services/wallet/wallet_service.dart';
import 'package:paychain_mobile/routes/routes.dart';
import 'package:paychain_mobile/utils/helpers/helpers.dart';

class TransactionsHistoryController extends GetxController {
  var isLoading = false.obs;
  var transactionList = <TransactionResponse>[].obs;
  final _walletService = WalletService();
  final _sharedPreferencesService = SharedPreferencesService();
  var email = ''.obs;
  @override
  onInit() async {
    email.value = await _sharedPreferencesService
            .getString(SharedPreferencesService.EMAIL) ??
        "";

    await getTransactionList();
    super.onInit();
  }

  getTransactionList() async {
    isLoading.value = true;

    final result = await _walletService.getAllTransactions(email.value);
    switch (result) {
      case Success():
        isLoading.value = false;
        transactionList.value = result.data!;
        // Get.snackbar('Thông báo', result.data.toString());
        break;
      case Failure():
        isLoading.value = false;
        print(result.statusCode);
        if (result.statusCode == 401) {
          Get.offAndToNamed(Routes.loginScreen);
        }
        Get.snackbar('Lỗi lấy thông tin lịch sử giao dịch ', result.message);
        break;
      default:
        isLoading.value = false;
        Get.snackbar(
            'Lỗi lấy thông tin lịch sử giao dịch ', 'Lỗi không xác định');
        break;
    }
  }
}
