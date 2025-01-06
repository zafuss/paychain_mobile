import 'package:paychain_mobile/data/models/transaction.dart';
import 'package:paychain_mobile/utils/helpers/round_crypto.dart';

class Wallet {
  final String id;

  final String account;
  final double balance;
  final String nameNode;
  final List<TransactionResponse>? transactions;

  Wallet(
      {required this.id,
      required this.account,
      required this.balance,
      required this.nameNode,
      this.transactions});

  @override
  String toString() {
    // TODO: implement toString
    return 'id: $id, account: $account, balance: $balance, nameNode: $nameNode, transactions: $transactions';
  }

  /// Chuyển đổi từ JSON sang đối tượng Wallet
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] as String,
      account: json['account'] as String,
      balance: roundCrypto(json['balance'], 4), // Đảm bảo kiểu double
      nameNode: json['nameNode'] as String,
      transactions: json['transaction'] != null
          ? (json['transaction'] as List)
              .map((transactionJson) =>
                  TransactionResponse.fromJson(transactionJson))
              .toList()
          : null, // Nếu không có transactions, trả về null
    );
  }

  /// Chuyển đổi từ đối tượng Wallet sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account': account,
      'balance': roundCrypto(balance, 4),
      'nameNode': nameNode,
      'transactions': transactions
    };
  }
}
