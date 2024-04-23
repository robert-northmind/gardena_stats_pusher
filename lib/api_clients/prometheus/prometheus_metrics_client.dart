import 'package:http/http.dart' as http;

import 'package:gardena_stats_pusher/api_clients/prometheus/prometheus_api_data_provider.dart';

class PrometheusMetricsClient {
  PrometheusMetricsClient({
    required String remoteWriteUrl,
    required String username,
    required String accessToken,
  }) {
    final apiDataProvider = PrometheusApiDataProvider();
    _url = apiDataProvider.getPrometheusUrl(remoteWriteUrl);
    _auth = apiDataProvider.getAuthContent(
      username: username,
      accessToken: accessToken,
    );
  }

  late final String _url;
  late final String _auth;

  Future<void> sendMetrics(List<PrometheusMetric> metrics) async {
    final body = metrics.map((metric) => metric.body).join('\n');
    final response = await http.post(
      Uri.parse(_url),
      headers: <String, String>{
        'authorization': _auth,
        'Content-Type': 'text/plain',
      },
      body: body,
    );
    print('Metrics response: ${response.statusCode} ${response.body}');
  }
}

class PrometheusMetric {
  PrometheusMetric({
    required this.serviceName,
    required this.labels,
    required this.value,
  });

  final String serviceName;
  final Map<String, String> labels;
  final PrometheusMetricValue value;

  String get body {
    final safeServiceName = serviceName.sanitized;
    final safeLabels = labels.entries
        .map((e) => '${e.key.sanitized}=${e.value.sanitized}')
        .join(',');
    final safeMetricName = value.name.sanitized;

    return '$safeServiceName,$safeLabels $safeMetricName=${value.value}';
  }
}

class PrometheusMetricValue {
  PrometheusMetricValue({required this.name, required this.value});
  final String name;
  final num value;
}

extension SanitizedX on String {
  String get sanitized {
    return replaceAll(' ', '_');
  }
}
