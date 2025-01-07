import 'package:paychain_mobile/utils/helpers/round_crypto.dart';
import 'package:paychain_mobile/utils/helpers/timestamp_converter.dart';

class TransactionResponse {
  final String accountSender;
  final String accountReceiver;
  final String nameSender;
  final double amount;
  final double fee;
  final String? message;
  final String nameReceiver;
  final String typeTransaction;
  final String? timestamp;

  TransactionResponse(
      {required this.accountReceiver,
      required this.accountSender,
      required this.typeTransaction,
      required this.amount,
      required this.fee,
      this.message,
      required this.nameReceiver,
      required this.nameSender,
      required this.timestamp});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
        accountReceiver: json['accountReceiver'],
        accountSender: json['accountSender'],
        amount: roundCrypto(json['amount'], 4),
        fee: json['fee'] as double,
        message: json['message'] ?? "Giao dịch không có nội dung.",
        typeTransaction: json['typeTransaction'],
        timestamp: json['timestamp'] != null
            ? formatTimestamp(json['timestamp'] as int)
            : null,
        nameReceiver: json['nameReceiver'] ?? 'null',
        nameSender: json['nameSender'] ?? "null");
  }

  @override
  String toString() {
    // TODO: implement toString
    return '$accountReceiver - $accountSender - $nameReceiver - $nameSender - $amount - $fee - $message - $typeTransaction - time: $timestamp';
  }
}
