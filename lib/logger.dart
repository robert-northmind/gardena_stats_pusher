import 'dart:io';

import 'package:gardena_stats_pusher/api_clients/loki/loki_configuration.dart';
import 'package:gardena_stats_pusher/api_clients/loki/loki_logger.dart';

final logger = LokiLogger(
  configuration: LokiConfiguration(
    url: Platform.environment['GRAFANA_LOKI_URL']!,
    username: Platform.environment['GRAFANA_LOKI_USERNAME']!,
    accessToken: Platform.environment['GRAFANA_LOKI_TOKEN']!,
    labels: {
      'app': 'gardena_stats_pusher',
      'version': '0.0.1',
    },
  ),
);
