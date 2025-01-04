import 'dart:convert';
import 'package:paychain_mobile/data/models/wallet.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

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

  // Hàm xử lý khi kết nối thành công
  void _onConnect(StompFrame frame) {
    print('Connected: $frame');
  }
}
