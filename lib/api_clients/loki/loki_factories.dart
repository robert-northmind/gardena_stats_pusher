import 'package:gardena_stats_pusher/api_clients/loki/loki_client.dart';
import 'package:gardena_stats_pusher/api_clients/loki/loki_client_config_provider.dart';
import 'package:gardena_stats_pusher/api_clients/loki/loki_configuration.dart';
import 'package:gardena_stats_pusher/api_clients/loki/loki_data_scheme_converter.dart';
import 'package:gardena_stats_pusher/api_clients/loki/loki_log_dispatcher.dart';

class LokiFactory {
  LokiClientConfigProvider getLokiClientConfigProvider(
    LokiConfiguration configuration,
  ) {
    return LokiClientConfigProvider(
      url: configuration.url,
      username: configuration.username,
      accessToken: configuration.accessToken,
    );
  }

  LokiDataSchemeConverter getLokiDataSchemeConverter(
    LokiConfiguration configuration,
  ) {
    return LokiDataSchemeConverter(globalLabels: configuration.labels);
  }

  LokiClient getLokiClient(LokiConfiguration configuration) {
    final clientConfigProvider = getLokiClientConfigProvider(configuration);
    final dataSchemeConverter = getLokiDataSchemeConverter(configuration);
    return LokiClient(
      configProvider: clientConfigProvider,
      dataSchemeConverter: dataSchemeConverter,
    );
  }

  LokiLogDispatcher getLokiLogDispatcher(LokiConfiguration configuration) {
    final lokiClient = getLokiClient(configuration);
    return LokiLogDispatcher(client: lokiClient);
  }
}
