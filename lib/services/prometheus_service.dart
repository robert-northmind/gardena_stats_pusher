import 'dart:io';

import 'package:gardena_stats_pusher/api_clients/prometheus/prometheus_metrics_client.dart';
import 'package:gardena_stats_pusher/logger.dart';
import 'package:gardena_stats_pusher/models/device.dart';

class PrometheusService {
  Future<void> sendMetrics({required List<Device> forDevices}) async {
    logger.info('Sending metrics to Prometheus...');

    final url = Platform.environment['GRAFANA_PROM_REMOTE_WRITE_URL'];
    final username = Platform.environment['GRAFANA_PROM_USERNAME'];
    final token = Platform.environment['GRAFANA_PROM_TOKEN'];

    if (url == null) {
      throw Exception('GRAFANA_PROM_REMOTE_WRITE_URL is not set');
    }
    if (username == null) {
      throw Exception('GRAFANA_PROM_USERNAME is not set');
    }
    if (token == null) {
      throw Exception('GRAFANA_PROM_TOKEN is not set');
    }

    final promClient = PrometheusMetricsClient(
      username: username,
      accessToken: token,
      remoteWriteUrl: url,
    );

    final metrics = <PrometheusMetric>[];
    for (final device in forDevices) {
      for (final metricValue in device.getMetricValues()) {
        metrics.add(
          PrometheusMetric(
            serviceName: 'gardena',
            labels: device.getLabels(),
            value: metricValue,
          ),
        );
      }
    }

    if (metrics.isEmpty) {
      throw Exception('No metrics to send');
    }
    promClient.sendMetrics(metrics);
  }
}
