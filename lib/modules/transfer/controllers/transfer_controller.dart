import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/data/models/base_response.dart';
import 'package:paychain_mobile/data/services/wallet/wallet_service.dart';
import 'package:paychain_mobile/modules/transfer/dtos/transaction_request.dart';
import 'package:paychain_mobile/routes/routes.dart';
import 'package:paychain_mobile/utils/helpers/helpers.dart';

class TransferController extends GetxController {
  var isLoading = false.obs;
  var isGettingUser = false.obs;
  var isSaveContactChecked = false.obs;
  var receiveAccount = ''.obs;
  var receiveName = ''.obs;
  var amount = 0.0.obs;
  var errorString = ''.obs;
  final WalletService walletService = WalletService();

  final receiveAccountController = TextEditingController();
  final receiveNameController = TextEditingController();
  final amountController = TextEditingController();
  final transferNoteController = TextEditingController();
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();

  Future<void> getUserByAccount(String account, String sender) async {
    isGettingUser.value = true;
    if (account.isEmpty) {
      isGettingUser.value = false;
      errorString.value = "Vui lòng nhập tài khoản";
      receiveNameController.text = "";
      return;
    } else if (account == sender) {
      isGettingUser.value = false;
      errorString.value = "Không thể chuyển tiền cho chính mình";
      receiveNameController.text = "";
      return;
    }
    final result = await walletService.getUserByAccount(account);
    switch (result) {
      case Success():
        isGettingUser.value = false;
        errorString.value = "";
        receiveNameController.text = result.data.name ?? "unknown";
        // Get.snackbar('Thông báo', result.data.toString());
        break;
      case Failure():
        isGettingUser.value = false;
        errorString.value = "Người nhận không tồn tại";
        receiveNameController.text = "";
        break;
      default:
        isGettingUser.value = false;
        errorString.value = "Người nhận không tồn tại";
        receiveNameController.text = "";
        Get.snackbar('Không tìm thấy người nhận', 'Lỗi không xác định');
        break;
    }
  }

  Future<void> sendTransaction(String accountSender) async {
    isLoading.value = true;
    final email = await _sharedPreferencesService
        .getString(SharedPreferencesService.EMAIL);
    TransactionRequest request = TransactionRequest(
      emailSenderID: email,
      accountSender: accountSender,
      accountReceiver: receiveAccountController.text,
      amount: double.parse(amountController.text),
      fee: 0.1,
      transactionDate: DateTime.now().toIso8601String(),
      privateKey: "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCAT4wggE4AgEAAkEAmDQ",
      note: transferNoteController.text,
    );
    final result = await walletService.sendTransaction(request);
    switch (result) {
      case Success():
        isLoading.value = false;
        Get.offAndToNamed(Routes.successTransferScreen);
        // Get.snackbar('Thông báo', result.data.toString());
        break;
      case Failure():
        isLoading.value = false;
        Get.snackbar('Lỗi chuyển tiền', result.message);
        break;
      default:
        isLoading.value = false;
        Get.snackbar('Lỗi chuyển tiền', 'Lỗi không xác định');
        break;
    }
  }
}