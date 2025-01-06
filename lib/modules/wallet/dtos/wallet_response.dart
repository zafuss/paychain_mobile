class WalletResponse {
  final String message;
  final bool status;

  WalletResponse({
    required this.message,
    required this.status,
  });
  factory WalletResponse.fromJson(Map<String, dynamic> json) => WalletResponse(
        message: json['message'],
        status: json['status'],
      );
}
