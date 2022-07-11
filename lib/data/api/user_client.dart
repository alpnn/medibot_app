import 'dart:convert';

import 'package:medibot_app/data/api/abstract_client.dart';
import 'package:medibot_app/data/http/auth_http.dart';
import 'package:medibot_app/model/error.dart';
import 'package:medibot_app/model/user/user_profile.dart';
import 'package:http/http.dart';

class UserClient extends AbstractClient {
  final AuthHttp authHttp;

  UserClient({required this.authHttp});

  UserProfile _tryParseUser(Response response) {
    Map<String, dynamic> parsedJson = jsonDecode(response.body);
    String username = parsedJson['username'];
    List<String> roles =
        List<String>.from(parsedJson['roles'].map((role) => role as String));
    return UserProfile(username: username, roles: roles);
  }

  Future<UserProfile> getUserProfile() async {
    Response response = await authHttp.dispatchHttpGet(
        buildUri('/user/current'), const Duration(seconds: 5));
    try {
      return _tryParseUser(response);
    } catch (e) {
      throw MedibotError.jsonParseFailed;
    }
  }

  List<UserProfile> _tryParseUserList(Response response){
    List<dynamic> parsedJson = jsonDecode(response.body);
    return List<UserProfile>.from(parsedJson.map((json) {
      String username = json['username'];
      List<String> roles =
      List<String>.from(json['roles'].map((role) => role as String));
      return UserProfile(username: username, roles: roles);
    }));
  }

  Future<List<UserProfile>> listUser() async {
    Response response = await authHttp.dispatchHttpGet(
        buildUri('/admin/user'), const Duration(seconds: 5));
    try {
      return _tryParseUserList(response);
    } catch (e) {
      throw MedibotError.jsonParseFailed;
    }
  }
}
