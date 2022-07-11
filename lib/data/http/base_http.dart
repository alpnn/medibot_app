import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:medibot_app/model/error.dart';

class BaseHttp {
  MedibotError _parseError(Response response) {
    try {
      Map<String, dynamic> parsedJson = jsonDecode(response.body);
      Map<String, dynamic> errorDetail = parsedJson['error'];
      return MedibotError(
          code: errorDetail['code'] as int,
          message: errorDetail['message'] as String);
    } catch (e) {
      return MedibotError.unknown;
    }
  }

  Future<Response> dispatchHttpGet(Uri uri, Duration timeout,
      {Map<String, String>? headers}) async {
    headers = headers ?? {};
    headers['Content-Type'] = "application/json;charset=utf-8";
    Response response;
    try {
      response = await get(
        uri,
        headers: headers,
      ).timeout(timeout);
    } catch (e) {
      throw MedibotError.connectionFailed;
    }

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.accepted) {
      return response;
    }
    throw _parseError(response);
  }

  Future<Response> dispatchHttpPost(Uri uri, Duration timeout,
      {Map<String, String>? headers, Object? body}) async {
    headers = headers ?? {};
    headers['Content-Type'] = "application/json;charset=utf-8";
    Response response;
    try {
      response = await post(
        uri,
        headers: headers,
        body: body,
      ).timeout(timeout);
    } catch (e) {
      throw MedibotError.connectionFailed;
    }

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.accepted) {
      return response;
    }
    throw _parseError(response);
  }
}
