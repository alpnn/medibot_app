import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medibot_app/data/api/auth_client.dart';
import 'package:medibot_app/model/authentication/token.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  static const _secureStorage = FlutterSecureStorage();
  static const _keyAccessToken = "access_token";
  static const _keyRefreshToken = "refresh_token";

  final AuthClient authClient;

  AuthenticationRepository({required this.authClient});

  Future<String> get authHeader async {
    String token = await _secureStorage.read(key: _keyAccessToken) ?? "";
    return "Bearer " + token;
  }

  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    String? accessToken = await _secureStorage.read(key: _keyRefreshToken);
    yield accessToken != null
        ? AuthenticationStatus.authenticated
        : AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> login(
      {required String username, required String password}) async {
    Token token = await authClient.login(username, password);
    await _secureStorage.write(key: _keyAccessToken, value: token.accessToken);
    await _secureStorage.write(
        key: _keyRefreshToken, value: token.refreshToken);
    _controller.add(AuthenticationStatus.authenticated);
  }

  Future<void> register(
      {required String email, required String username, required String password}) async {
    await authClient.register(email, username, password);
  }

  Future<void> refresh() async {
    String? refreshToken = await _secureStorage.read(key: _keyRefreshToken);
    if (refreshToken == null) {
      _controller.add(AuthenticationStatus.unauthenticated);
      return;
    }
    Token token = await authClient.refresh(refreshToken);
    await _secureStorage.write(key: _keyAccessToken, value: token.accessToken);
    await _secureStorage.write(
        key: _keyRefreshToken, value: token.refreshToken);
  }

  void logout() {
    //TODO invalidate token
    _secureStorage.delete(key: _keyAccessToken);
    _secureStorage.delete(key: _keyRefreshToken);
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() {
    _controller.close();
  }
}
