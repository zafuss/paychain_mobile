class Wallet {
  final String id;

  final String account;
  final double balance;
  final String nameNode;

  Wallet({
    required this.id,
    required this.account,
    required this.balance,
    required this.nameNode,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'id: $id, account: $account, balance: $balance, nameNode: $nameNode';
  }

  /// Chuyển đổi từ JSON sang đối tượng Wallet
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] as String,

      account: json['account'] as String,
      balance: (json['balance'] as num).toDouble(), // Đảm bảo kiểu double
      nameNode: json['nameNode'] as String,
    );
  }

  /// Chuyển đổi từ đối tượng Wallet sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account': account,
      'balance': balance,
      'nameNode': nameNode,
    };
  }
}
