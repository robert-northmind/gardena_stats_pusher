import 'dart:async';

import 'package:gardena_stats_pusher/api_clients/loki/loki_client.dart';
import 'package:gardena_stats_pusher/api_clients/loki/loki_log_entry.dart';

class LokiLogDispatcher {
  LokiLogDispatcher({
    required LokiClient client,
  }) : _client = client;

  final LokiClient _client;

  List<LokiLogEntry> _logEntries = [];
  Timer? _timer;

  void addLog(LokiLogEntry logEntry) {
    _logEntries.add(logEntry);
    _timer ??= Timer(Duration(seconds: 5), _sendLogs);
  }

  Future<void> _sendLogs() async {
    final List<LokiLogEntry> logEntriesToSend = _logEntries;
    _logEntries = [];
    _timer?.cancel();
    _timer = null;

    try {
      await _client.sendLogs(logEntriesToSend);
    } catch (error) {
      print('Failed to send loki logs with: $error');
      _logEntries.addAll(logEntriesToSend);
    }

    if (_logEntries.isNotEmpty && _timer == null) {
      _timer = Timer(Duration(seconds: 5), _sendLogs);
    }
  }
}
