import 'dart:convert';

import 'package:gardena_stats_pusher/api_clients/loki/loki_data_scheme_converter.dart';
import 'package:gardena_stats_pusher/api_clients/loki/loki_log_entry.dart';
import 'package:http/http.dart' as http;

import 'package:gardena_stats_pusher/api_clients/loki/loki_client_config_provider.dart';

class LokiClient {
  LokiClient({
    required LokiClientConfigProvider configProvider,
    required LokiDataSchemeConverter dataSchemeConverter,
  })  : _dataSchemeConverter = dataSchemeConverter,
        _configProvider = configProvider;

  final LokiDataSchemeConverter _dataSchemeConverter;
  late final LokiClientConfigProvider _configProvider;

  Future<void> sendLogs(List<LokiLogEntry> logEntries) async {
    final Map<String, dynamic> body = _dataSchemeConverter.toJson(logEntries);

    final response = await http.post(
      Uri.parse(_configProvider.getUrl()),
      headers: <String, String>{
        'authorization': _configProvider.getAuth(),
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode != 204) {
      throw Exception(
        'Failed to send logs with: ${response.statusCode} ${response.body}',
      );
    }
  }
}
