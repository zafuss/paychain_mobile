class TransactionRequest {
  String? emailSenderID;
  String? accountSender;
  String? accountReceiver;
  double? amount;
  double? fee;
  String? privateKey;
  String? transactionDate;
  String? note;

  // Constructor
  TransactionRequest({
    this.emailSenderID,
    this.accountSender,
    this.accountReceiver,
    this.amount,
    this.fee,
    this.privateKey,
    this.transactionDate,
    this.note,
  });

  // toJson Method
  Map<String, dynamic> toJson() {
    return {
      'emailSenderID': emailSenderID,
      'accountSender': accountSender,
      'accountReceiver': accountReceiver,
      'amount': amount,
      'fee': fee,
      'privateKey': privateKey,
      'transactionDate': transactionDate,
      'note': note,
    };
  }

  // Optional: fromJson factory constructor
  factory TransactionRequest.fromJson(Map<String, dynamic> json) {
    return TransactionRequest(
      emailSenderID: json['emailSenderID'] as String?,
      accountSender: json['accountSender'] as String?,
      accountReceiver: json['accountReceiver'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      fee: (json['fee'] as num?)?.toDouble(),
      privateKey: json['privateKey'] as String?,
      transactionDate: json['transactionDate'] as String?,
      note: json['note'] as String?,
    );
  }
}
