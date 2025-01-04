import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:paychain_mobile/data/models/user.dart';
import 'package:paychain_mobile/data/models/wallet.dart';
import 'package:paychain_mobile/modules/transfer/dtos/transaction_request.dart';
import 'package:paychain_mobile/modules/transfer/dtos/wallet_response.dart';
import 'package:paychain_mobile/utils/configs/dio_config.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../models/base_response.dart';

class WalletService {
  late StompClient _stompClient;

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

  void connect(String email, Function(List<Wallet>) onWalletsUpdated) {
    // Initialize StompClient with the onConnect callback inside the StompConfig
    _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8080/ws',
        onConnect: (StompFrame frame) {
          // Now that the connection is established, we can safely send and subscribe
          print('Connected: $frame');

          // Send a request for wallets
          _stompClient.send(destination: '/app/getWallets', body: email);

          // Subscribe to the wallet topic for this email
          _stompClient.subscribe(
            destination: '/topic/wallets/$email',
            callback: (StompFrame frame) {
              if (frame.body != null) {
                final data =
                    List<Map<String, dynamic>>.from(jsonDecode(frame.body!));
                final newWallets = data.map((e) => Wallet.fromJson(e)).toList();
                onWalletsUpdated(
                    newWallets); // Call the callback with new wallet data
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
          message: e.message ?? "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }

  sendTransaction(TransactionRequest request) async {
    try {
      var url = 'wallet/send';
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
          message: e.message ?? "Có lỗi xảy ra",
          statusCode: e.response != null ? e.response!.statusCode! : 500);
    }
  }

  // Hàm xử lý khi kết nối thành công
  void _onConnect(StompFrame frame) {
    print('Connected: $frame');
  }
}
