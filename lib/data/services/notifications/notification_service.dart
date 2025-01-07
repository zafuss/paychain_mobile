import 'package:stomp_dart_client/stomp_dart_client.dart';

class NotificationService {
  late StompClient _stompClient;

  NotificationService() {
    _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8080/ws',
        onConnect: _onConnect,
        onWebSocketError: (error) => print('WebSocket Error: $error'),
        onStompError: (frame) => print('STOMP Error: ${frame.body}'),
      ),
    );
  }

  void connect(Function(String) onNotificationUpdated) {
    _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8080/ws',
        onConnect: (StompFrame frame) {
          print('Connected: $frame');

          _stompClient.send(destination: '/app/getNotifications');

          _stompClient.subscribe(
            destination: '/topic/notifications',
            callback: (StompFrame frame) {
              print('subbed');
              if (frame.body != null) {
                final data = frame.body ?? "";
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

  // Hàm xử lý khi kết nối thành công
  void _onConnect(StompFrame frame) {
    print('Connected: $frame');
  }
}
