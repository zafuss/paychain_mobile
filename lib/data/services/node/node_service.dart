import 'package:dio/dio.dart';
import 'package:paychain_mobile/data/models/transaction.dart';
import 'package:paychain_mobile/modules/transfer/dtos/transaction_request.dart';
import 'package:paychain_mobile/modules/wallet/dtos/wallet_response.dart';
import 'package:paychain_mobile/utils/configs/dio_config.dart';
import 'package:paychain_mobile/utils/helpers/datetime_compare.dart';

import '../../models/base_response.dart';

class NodeService {
  createNode() async {
    try {
      var url = 'api/nodes/create';
      var response = await defaultDio.post(
        url,
        data: {'name': 'null'},
      );
      print(response.data!['node']['id']);
      return Success(response.data!['node']['id']);
    } on DioException catch (e) {
      return Failure(
          message: e.response != null
              ? e.response!.data!['message']
              : "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }

  addPeer(String nodeId) async {
    try {
      var url = 'api/nodes/addPeer';
      await defaultDio.post(
        url,
        data: {'id': nodeId, 'peerIp': '192.168.191.59'},
      );
      return Success();
    } on DioException catch (e) {
      return Failure(
          message: e.response != null
              ? e.response!.data!['message']
              : "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }

  addNodeToWallet(String nodeId, String walletId) async {
    try {
      var url = 'api/nodes/addToWallet';
      final result = await defaultDio.post(
        url,
        data: {'nodeId': nodeId, 'walletId': walletId},
      );
      return Success(result.data['message']);
    } on DioException catch (e) {
      return Failure(
          message: e.response != null
              ? e.response!.data!['message']
              : "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }

  sendTransaction(TransactionRequest request) async {
    try {
      var url = 'wallet/send';
      print(request.toJson());
      var response = await defaultDio.post(
        url,
        data: request.toJson(),
      );
      // print(response.data!.wallets);
      return Success(
        WalletResponse.fromJson(response.data),
      );
    } on DioException catch (e) {
      return Failure(
          message: e.response != null
              ? e.response!.data!['message']
              : "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }

  getAllTransactions(String email) async {
    try {
      var url = 'wallet/getAllTransactions';

      var response = await defaultDio.post(
        url,
        data: {"email": email},
      );
      // print(response.data!.wallets);
      final data =
          List<Map<String, dynamic>>.from(response.data!['transactionList'])
              .map((e) => TransactionResponse.fromJson(e))
              .toList()
              .reversed
              .toList();
      data.sort((a, b) => compareTimes(a.timestamp, b.timestamp));
      return Success(data);
    } on DioException catch (e) {
      return Failure(
          message: e.response != null
              ? e.response!.data!['message']
              : "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }

  createWallet(String email) async {
    try {
      var url = 'wallet/create';

      var response = await defaultDio.post(
        url,
        data: {"email": email},
      );
      // print(response.data!.wallets);
      return Success(response.data!['walletId']);
    } on DioException catch (e) {
      return Failure(
          message: e.response != null
              ? e.response!.data!['message']
              : "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }
}
