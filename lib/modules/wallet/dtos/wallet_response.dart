import 'package:paychain_mobile/data/models/transaction.dart';

class WalletResponse {
  final String message;
  final bool status;
  final TransactionResponse response;

  WalletResponse(
      {required this.message, required this.status, required this.response});
  factory WalletResponse.fromJson(Map<String, dynamic> json) => WalletResponse(
      message: json['message'],
      status: json['status'],
      response: TransactionResponse.fromJson(json['response']));
}
