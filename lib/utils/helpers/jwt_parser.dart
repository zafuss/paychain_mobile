import 'dart:convert';

class JwtParser {
  // Hàm parse JWT
  static Map<String, dynamic> parseJwt(String token) {
    // Tách token thành các phần: header, payload, signature
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT token');
    }

    // Lấy phần payload (phần thứ 2) và giải mã
    final payload = _decodeBase64(parts[1]);

    // Chuyển chuỗi JSON thành Map
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('Invalid payload in JWT token');
    }

    return payloadMap;
  }

  // Giải mã Base64
  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    // Padding Base64 nếu thiếu
    while (output.length % 4 != 0) {
      output += '=';
    }

    // Decode Base64
    return utf8.decode(base64Url.decode(output));
  }
}
