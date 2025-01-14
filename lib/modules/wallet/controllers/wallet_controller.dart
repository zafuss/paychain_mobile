import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paychain_mobile/data/models/wallet.dart';
import 'package:paychain_mobile/data/services/node/node_service.dart';
import 'package:paychain_mobile/data/services/wallet/wallet_service.dart';
import 'package:paychain_mobile/utils/helpers/helpers.dart';

import '../../../data/models/base_response.dart';

class WalletController extends GetxController {
  var isLoading = false.obs;
  final WalletService walletService = WalletService();
  final NodeService nodeService = NodeService();
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();
  var wallets = <Wallet>[].obs; // Observable list of wallets
  var selectedWallet = Rxn<Wallet>(); // Selected wallet (nullable)
  var createdWalletId = ''.obs;
  var createdNodeId = ''.obs;
  final nodeIdController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    final email = await _sharedPreferencesService
        .getString(SharedPreferencesService.EMAIL);
    print(email);
    // walletService.connect(
    //     email ?? "", _onWalletsUpdated, _onNotificationUpdated);
    fetchWallets(email ?? '');
  }

  @override
  void onClose() {
    super.onClose();
    walletService.disconnect();
  }

  fetchWallets(String email) async {
    isLoading.value = true;

    final result = await walletService.getWalletsByEmail(email);

    switch (result) {
      case Success():
        isLoading.value = false;
        wallets.value = result.data;
        selectedWallet.value = wallets.first;
        // Get.snackbar('Thông báo', result.data.toString());
        break;
      case Failure():
        isLoading.value = false;
        Get.snackbar('Lỗi tạo thêm peer ', result.message);
        break;
      default:
        isLoading.value = false;
        Get.snackbar('Lỗi tạo thêm peer ', 'Lỗi không xác định');
        break;
    }
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

  void _onNotificationUpdated(String message) {
    if (message.isNotEmpty) {
      Get.snackbar('Thông báo', message);
    }
  }

  void selectWallet(Wallet wallet) {
    selectedWallet.value = wallet;
  }

  createWallet() async {
    isLoading.value = true;
    final email = await _sharedPreferencesService
            .getString(SharedPreferencesService.EMAIL) ??
        "";
    final result = await walletService.createWallet(email);
    switch (result) {
      case Success():
        isLoading.value = false;
        createdWalletId.value = result.data!;
        // Get.snackbar('Thông báo', result.data.toString());
        break;
      case Failure():
        isLoading.value = false;
        Get.snackbar('Lỗi tạo ví ', result.message);
        break;
      default:
        isLoading.value = false;
        Get.snackbar('Lỗi tạo ví ', 'Lỗi không xác định');
        break;
    }
  }

  createNode() async {
    isLoading.value = true;

    final result = await nodeService.createNode();
    switch (result) {
      case Success():
        isLoading.value = false;
        createdNodeId.value = result.data!;
        // Get.snackbar('Thông báo', result.data.toString());
        break;
      case Failure():
        isLoading.value = false;
        Get.snackbar('Lỗi tạo node ', result.message);
        break;
      default:
        isLoading.value = false;
        Get.snackbar('Lỗi tạo node ', 'Lỗi không xác định');
        break;
    }
  }

  addPeer() async {
    isLoading.value = true;

    final result = await nodeService.addPeer(createdNodeId.value);
    switch (result) {
      case Success():
        isLoading.value = false;
        // Get.snackbar('Thông báo', result.data.toString());
        break;
      case Failure():
        isLoading.value = false;
        Get.snackbar('Lỗi tạo thêm peer ', result.message);
        break;
      default:
        isLoading.value = false;
        Get.snackbar('Lỗi tạo thêm peer ', 'Lỗi không xác định');
        break;
    }
  }

  addNodeToWallet() async {
    isLoading.value = true;

    final result = await nodeService.addNodeToWallet(
        createdNodeId.value, createdWalletId.value);
    switch (result) {
      case Success():
        isLoading.value = false;
        Get.snackbar('Thông báo', result.data.toString());
        break;
      case Failure():
        isLoading.value = false;
        Get.snackbar('Lỗi tạo thêm peer ', result.message);
        break;
      default:
        isLoading.value = false;
        Get.snackbar('Lỗi tạo thêm peer ', 'Lỗi không xác định');
        break;
    }
  }

  resetValue() {
    createdNodeId.value = '';
    createdWalletId.value = '';
    nodeIdController.text = '';
  }
}
