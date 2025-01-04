import 'package:get/get.dart';
import 'package:paychain_mobile/data/models/wallet.dart';
import 'package:paychain_mobile/data/services/wallet/wallet_service.dart';
import 'package:paychain_mobile/utils/helpers/helpers.dart';

class WalletController extends GetxController {
  var isLoading = false.obs;
  final WalletService walletService = WalletService();
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();
  var wallets = <Wallet>[].obs; // Observable list of wallets
  var selectedWallet = Rxn<Wallet>(); // Selected wallet (nullable)

  @override
  void onInit() async {
    super.onInit();
    final email = await _sharedPreferencesService
        .getString(SharedPreferencesService.EMAIL);
    print(email);
    walletService.connect(email ?? "", _onWalletsUpdated);
  }

  @override
  void onClose() {
    super.onClose();
    walletService.disconnect();
  }

  void _onWalletsUpdated(List<Wallet> newWallets) {
    wallets.value = newWallets;

    if (selectedWallet.value != null) {
      if (!newWallets.contains(selectedWallet.value)) {
        selectedWallet.value = wallets.first; // Reset nếu không hợp lệ
      } else {
        selectedWallet.value = newWallets
            .firstWhere((wallet) => wallet.id == selectedWallet.value!.id);
      }
    } else {
      selectedWallet.value = wallets.isNotEmpty ? wallets.first : null;
    }
  }

  void selectWallet(Wallet wallet) {
    selectedWallet.value = wallet;
  }
}
