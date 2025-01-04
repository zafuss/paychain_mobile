import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/data/models/wallet.dart';
import 'package:paychain_mobile/modules/wallet/controllers/wallet_controller.dart';

class WalletScreen extends StatelessWidget {
  final WalletController walletController = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wallet Selection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for wallet selection
            Obx(() {
              if (walletController.wallets.isEmpty) {
                return Center(child: Text('No wallets available'));
              }

              return DropdownButton<Wallet>(
                isExpanded: true,
                value: walletController.selectedWallet.value,
                hint: Text('Select a Wallet'),
                items: walletController.wallets.map((wallet) {
                  return DropdownMenuItem<Wallet>(
                    value: wallet,
                    child: Text(wallet.account),
                  );
                }).toList(),
                onChanged: (Wallet? wallet) {
                  if (wallet != null) {
                    walletController.selectWallet(wallet);
                  }
                },
              );
            }),
            SizedBox(height: 16),
            // Selected Wallet Details
            Obx(() {
              final selectedWallet = walletController.selectedWallet.value;
              if (selectedWallet == null) {
                return Center(child: Text('No wallet selected'));
              }
              return Text(
                'Selected Wallet: ${selectedWallet.account} (ID: ${selectedWallet.balance})',
                style: TextStyle(fontSize: 16),
              );
            }),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(home: WalletScreen()));
}
