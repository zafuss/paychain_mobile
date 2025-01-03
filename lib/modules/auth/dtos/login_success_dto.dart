class LoginSuccessDto {
  final String accessToken;
  final String refreshToken;
  final String id;
  final String email;
  final String phoneNumber;
  final bool status;

  LoginSuccessDto(
      {required this.accessToken,
      required this.refreshToken,
      required this.id,
      required this.email,
      required this.phoneNumber,
      this.status = true});

  factory LoginSuccessDto.fromJson(Map<String, dynamic> json) {
    return LoginSuccessDto(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      id: json['id'],
      email: json['email'],
      phoneNumber: json['phoneNumber'] ?? '',
      status: json['status'] ?? true,
    );
  }
}
