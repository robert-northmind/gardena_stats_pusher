import 'package:gardena_stats_pusher/api_clients/loki/loki_log_level.dart';

class LokiLogEntry {
  LokiLogEntry({
    required this.message,
    required this.level,
    required this.labels,
  });

  final String message;
  final LokiLogLevel level;
  final Map<String, String> labels;
  final String timestamp = getTimestamp();

  static String getTimestamp() {
    DateTime now = DateTime.now();
    int microsecondsSinceEpoch = now.microsecondsSinceEpoch;
    int nanoseconds = microsecondsSinceEpoch * 1000;
    return nanoseconds.toString();
  }
}
