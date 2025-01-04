import 'package:get/get.dart';
import 'package:paychain_mobile/data/models/wallet.dart';
import 'package:paychain_mobile/data/services/wallet/wallet_service.dart';

class WalletController extends GetxController {
  final WalletService walletService = WalletService();
  var wallets = <Wallet>[].obs; // Observable list of wallets
  var selectedWallet = Rxn<Wallet>(); // Selected wallet (nullable)

  @override
  void onInit() {
    super.onInit();

    // Initialize WebSocket and connect
    String email =
        'zafus2103@gmail.com'; // Có thể lấy từ session hoặc user đã đăng nhập
    walletService.connect(email, _onWalletsUpdated);
  }

  @override
  void onClose() {
    super.onClose();
    walletService.disconnect();
  }

  void _onWalletsUpdated(List<Wallet> newWallets) {
    wallets.value = newWallets;

    // Kiểm tra nếu selectedWallet không còn trong danh sách mới
    if (selectedWallet.value != null &&
        !newWallets.contains(selectedWallet.value)) {
      selectedWallet.value = null; // Reset nếu không hợp lệ
    } else {
      selectedWallet.value = wallets.isNotEmpty ? wallets.first : null;
    }
  }

  void selectWallet(Wallet wallet) {
    selectedWallet.value = wallet;
  }
}
