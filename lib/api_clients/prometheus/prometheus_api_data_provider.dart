import 'dart:convert';

class PrometheusApiDataProvider {
  String getPrometheusUrl(String url) {
    final fixedUrl = url
        .replaceAll('prometheus', 'influx')
        .replaceAll('/api/prom/push', '/api/v1/push/influx/write');
    return fixedUrl;
  }

  String getAuthContent({
    required String username,
    required String accessToken,
  }) {
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$accessToken'))}';
    return basicAuth;
  }
}
