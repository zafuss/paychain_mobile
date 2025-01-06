class ContactResponse {
  final String account;
  final String name;

  ContactResponse({required this.account, required this.name});

  factory ContactResponse.fromJson(Map<String, dynamic> json) =>
      ContactResponse(
        account: json['account'],
        name: json['name'],
      );
}
