class Wallet {
  final String id;
  final String privateKeyBase64;
  final String publicKeyBase64;
  final String account;
  final double balance;
  final String nameNode;

  Wallet({
    required this.id,
    required this.privateKeyBase64,
    required this.publicKeyBase64,
    required this.account,
    required this.balance,
    required this.nameNode,
  });

  /// Chuyển đổi từ JSON sang đối tượng Wallet
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] as String,
      privateKeyBase64: json['privateKeyBase64'] as String,
      publicKeyBase64: json['publicKeyBase64'] as String,
      account: json['account'] as String,
      balance: (json['balance'] as num).toDouble(), // Đảm bảo kiểu double
      nameNode: json['nameNode'] as String,
    );
  }

  /// Chuyển đổi từ đối tượng Wallet sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'privateKeyBase64': privateKeyBase64,
      'publicKeyBase64': publicKeyBase64,
      'account': account,
      'balance': balance,
      'nameNode': nameNode,
    };
  }
}
