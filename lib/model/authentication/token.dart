import 'dart:convert';

class Token {
  String accessToken;
  String refreshToken;

  Token({required this.accessToken, required this.refreshToken});

  factory Token.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return Token(
        accessToken: json['access_token'] ?? '',
        refreshToken: json['refresh_token'] ?? '');
  }
}
