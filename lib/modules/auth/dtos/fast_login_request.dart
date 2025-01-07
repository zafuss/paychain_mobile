class FastLoginRequest {
  final String email;
  final String accessToken;
  final String refreshToken;

  FastLoginRequest(
      {required this.email,
      required this.accessToken,
      required this.refreshToken});
}
