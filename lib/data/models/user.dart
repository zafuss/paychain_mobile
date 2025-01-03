import 'wallet.dart';

class User {
  String? name;
  String email;
  String? phoneNumber;
  String password;
  List<Wallet>? wallets;

  User({
    this.name,
    required this.email,
    this.phoneNumber,
    required this.password,
    this.wallets,
  });

  // Phương thức chuyển đổi từ Map thành đối tượng User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      wallets: json['wallets'] != null
          ? List<Wallet>.from(json['wallets'].map((x) => Wallet.fromJson(x)))
          : null,
    );
  }

  // Phương thức chuyển đổi đối tượng User thành Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
    };
  }
}
