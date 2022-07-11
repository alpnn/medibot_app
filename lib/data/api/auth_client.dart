import 'dart:convert';
import 'package:http/http.dart';
import 'package:medibot_app/data/api/abstract_client.dart';
import 'package:medibot_app/data/http/base_http.dart';
import 'package:medibot_app/model/error.dart';
import 'package:medibot_app/model/authentication/token.dart';

class AuthClient extends AbstractClient{
  final BaseHttp baseHttp;

  AuthClient({required this.baseHttp});

  Token _tryParseToken(Response response) {
    Map<String, dynamic> parsedJson = jsonDecode(response.body);
    String accessToken = parsedJson['accessToken'] as String;
    String refreshToken = parsedJson['refreshToken'] as String;
    return Token(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<Token> login(String username, String password) async {
    Response response = await baseHttp.dispatchHttpPost(
      buildUri('/auth/login'),
      const Duration(seconds: 5),
      body: jsonEncode(
          <String, String>{'username': username, 'password': password}),
    );
    try {
      return _tryParseToken(response);
    } catch (e) {
      throw MedibotError.jsonParseFailed;
    }
  }

  Future<void> register(String email, String username, String password) async {
    await baseHttp.dispatchHttpPost(buildUri('/auth/register'), const Duration(seconds: 5),
        body: jsonEncode(
            <String, String>{'email': email, 'username': username, 'password': password}));
  }

  Future<Token> refresh(String refreshToken) async {
    Response response = await baseHttp.dispatchHttpPost(
        buildUri('/auth/refresh'), const Duration(seconds: 5),
        body: refreshToken);
    try {
      return _tryParseToken(response);
    } catch (e) {
      throw MedibotError.jsonParseFailed;
    }
  }
}