import 'package:medibot_app/data/repository/authentication_repository.dart';
import 'package:medibot_app/model/error.dart';
import 'package:http/http.dart';
import 'base_http.dart';

class AuthHttp extends BaseHttp{
  final AuthenticationRepository authenticationRepository;

  AuthHttp({required this.authenticationRepository});

  Future<Map<String, String>> _makeHeader(Map<String, String>? headers) async {
    String authToken = await authenticationRepository.authHeader;
    Map<String, String> wrappedHeaders = headers ?? {};
    wrappedHeaders['Authorization'] = authToken;
    return wrappedHeaders;
  }

  @override
  Future<Response> dispatchHttpGet(Uri uri, Duration timeout,
      {Map<String, String>? headers}) async {
    try {
      Map<String, String> wrappedHeaders = await _makeHeader(headers);
      return await super.dispatchHttpGet(uri, timeout,
          headers: wrappedHeaders);
    } on MedibotError catch (e) {
      if (e.code == 101) {
        await authenticationRepository.refresh();
        Map<String, String> wrappedHeaders = await _makeHeader(headers);
        return await super.dispatchHttpGet(uri, timeout,
            headers: wrappedHeaders);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<Response> dispatchHttpPost(Uri uri, Duration timeout,
      {Map<String, String>? headers, Object? body}) async {
    try {
      Map<String, String> wrappedHeaders = await _makeHeader(headers);
      return await super.dispatchHttpPost(uri, timeout,
          headers: wrappedHeaders, body: body);
    } on MedibotError catch (e) {
      if (e.code == 101) {
        await authenticationRepository.refresh();
        Map<String, String> wrappedHeaders = await _makeHeader(headers);
        return await super.dispatchHttpPost(uri, timeout,
            headers: wrappedHeaders, body: body);
      } else {
        rethrow;
      }
    }
  }
}
