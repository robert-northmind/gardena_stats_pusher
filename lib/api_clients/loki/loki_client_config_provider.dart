import 'dart:convert';

class LokiClientConfigProvider {
  LokiClientConfigProvider({
    required String url,
    required String username,
    required String accessToken,
  })  : _url = url,
        _username = username,
        _accessToken = accessToken;

  final String _url;
  final String _username;
  final String _accessToken;

  String getUrl() {
    return _url;
  }

  String getAuth() {
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$_username:$_accessToken'))}';
    return basicAuth;
  }
}
