import 'package:paychain_mobile/data/models/wallet.dart';

class LoginSuccessDto {
  final String accessToken;
  final String refreshToken;
  final String id;
  final String email;
  final String phoneNumber;
  final bool status;
  final List<Wallet>? wallets;

  LoginSuccessDto(
      {required this.accessToken,
      required this.refreshToken,
      required this.id,
      required this.email,
      required this.phoneNumber,
      this.wallets,
      this.status = true});

  @override
  String toString() {
    // TODO: implement toString
    return 'accessToken: $accessToken, refreshToken: $refreshToken, id: $id, email: $email, phoneNumber: $phoneNumber, status: $status, wallets: $wallets';
  }

  factory LoginSuccessDto.fromJson(Map<String, dynamic> json) {
    return LoginSuccessDto(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      id: json['id'],
      email: json['email'],
      phoneNumber: json['phoneNumber'] ?? '',
      status: json['status'] ?? true,
    );
  }
}
