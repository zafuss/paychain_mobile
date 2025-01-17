import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paychain_mobile/data/models/transaction.dart';
import 'package:paychain_mobile/data/models/user.dart';
import 'package:paychain_mobile/data/models/wallet.dart';
import 'package:paychain_mobile/modules/transfer/dtos/transaction_request.dart';
import 'package:paychain_mobile/modules/wallet/dtos/contact_response.dart';
import 'package:paychain_mobile/utils/configs/dio_config.dart';
import 'package:paychain_mobile/utils/helpers/datetime_compare.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../models/base_response.dart';

class WalletService {
  late StompClient _stompClient;
  String prvKey = dotenv.env['PRV_KEY'] ?? 'Default';

  WalletService() {
    _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8080/ws',
        onConnect: _onConnect,
        onWebSocketError: (error) => print('WebSocket Error: $error'),
        onStompError: (frame) => print('STOMP Error: ${frame.body}'),
      ),
    );
  }

  void connect(String email, Function(List<Wallet>) onWalletsUpdated,
      Function(String) onNotificationUpdated) {
    _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8080/ws',
        onConnect: (StompFrame frame) {
          print('Connected: $frame');

          _stompClient.send(destination: '/app/getWallets', body: email);

          _stompClient.subscribe(
            destination: '/topic/wallets/$email',
            callback: (StompFrame frame) {
              if (frame.body != null) {
                print('wallet subbed');
                final data =
                    List<Map<String, dynamic>>.from(jsonDecode(frame.body!));
                final newWallets = data.map((e) => Wallet.fromJson(e)).toList();
                print(newWallets);
                onWalletsUpdated(newWallets);
              }
            },
          );
          _stompClient.subscribe(
            destination: '/topic/wallets/',
            callback: (StompFrame frame) {
              if (frame.body != null) {
                print('wallet subbed');
                final data = jsonDecode(frame.body!);

                onNotificationUpdated(data);
              }
            },
          );
        },
        onWebSocketError: (error) => print('WebSocket Error: $error'),
        onStompError: (frame) => print('STOMP Error: ${frame.body}'),
      ),
    );

    // Activate the WebSocket connection
    _stompClient.activate();
  }

  // Hàm ngắt kết nối WebSocket
  void disconnect() {
    _stompClient.deactivate();
    print('Disconnected');
  }

  getUserByAccount(String account) async {
    try {
      var url = 'wallet/user';
      var response = await defaultDio.get(
        url,
        queryParameters: {'account': account},
      );
      // print(response.data!.wallets);
      return Success(User.fromJson(response.data));
    } on DioException catch (e) {
      return Failure(
          message: e.response != null
              ? e.response!.data!['message']
              : "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }

  getContactList(String email) async {
    try {
      var url = 'wallet/getContactList';
      var response = await defaultDio.post(
        url,
        data: {'email': email},
      );
      print(response.data!);
      final data =
          List<Map<String, dynamic>>.from(response.data!['contactList']);
      print(data);
      return Success(data.map((e) => ContactResponse.fromJson(e)).toList());
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
      request.privateKey = prvKey;
      print(request.toJson());
      var response = await defaultDio.post(
        url,
        data: request.toJson(),
      );
      // print(response.data!.wallets);
      return Success(
        TransactionResponse.fromJson(response.data['transaction']),
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

  // Hàm xử lý khi kết nối thành công
  void _onConnect(StompFrame frame) {
    print('Connected: $frame');
  }
}
