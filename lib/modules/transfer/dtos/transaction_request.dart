class TransactionRequest {
  String? emailSenderID;
  String? accountSender;
  String? accountReceiver;
  double? amount;
  double? fee;
  String? privateKey;
  String? transactionDate;
  String? receiverName;
  String? senderName;
  String? note;
  bool saveContact;

  // Constructor
  TransactionRequest(
      {this.emailSenderID,
      this.accountSender,
      this.accountReceiver,
      this.amount,
      this.fee,
      this.privateKey,
      this.transactionDate,
      this.note,
      this.receiverName,
      this.senderName,
      required this.saveContact});

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
      'receiverName': receiverName,
      'senderName': senderName,
      'message': note,
      'saveContact': saveContact
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
        note: json['message'] as String?,
        saveContact: json['saveContact'] as bool);
  }
}
