import 'package:gardena_stats_pusher/api_clients/loki/loki_configuration.dart';
import 'package:gardena_stats_pusher/api_clients/loki/loki_factories.dart';
import 'package:gardena_stats_pusher/api_clients/loki/loki_log_dispatcher.dart';
import 'package:gardena_stats_pusher/api_clients/loki/loki_log_entry.dart';
import 'package:gardena_stats_pusher/api_clients/loki/loki_log_level.dart';

class LokiLogger {
  LokiLogger({
    required LokiConfiguration configuration,
  }) {
    _logDispatcher = LokiFactory().getLokiLogDispatcher(configuration);
  }

  late final LokiLogDispatcher _logDispatcher;

  void trace(String message, {Map<String, String> labels = const {}}) {
    final logEntry = LokiLogEntry(
      message: message,
      level: LokiLogLevel.trace,
      labels: labels,
    );
    _logDispatcher.addLog(logEntry);
  }

  void debug(String message, {Map<String, String> labels = const {}}) {
    final logEntry = LokiLogEntry(
      message: message,
      level: LokiLogLevel.debug,
      labels: labels,
    );
    _logDispatcher.addLog(logEntry);
  }

  void info(String message, {Map<String, String> labels = const {}}) {
    final logEntry = LokiLogEntry(
      message: message,
      level: LokiLogLevel.info,
      labels: labels,
    );
    _logDispatcher.addLog(logEntry);
  }

  void warning(String message, {Map<String, String> labels = const {}}) {
    final logEntry = LokiLogEntry(
      message: message,
      level: LokiLogLevel.warning,
      labels: labels,
    );
    _logDispatcher.addLog(logEntry);
  }

  void error(String message, {Map<String, String> labels = const {}}) {
    final logEntry = LokiLogEntry(
      message: message,
      level: LokiLogLevel.error,
      labels: labels,
    );
    _logDispatcher.addLog(logEntry);
  }

  void fatal(String message, {Map<String, String> labels = const {}}) {
    final logEntry = LokiLogEntry(
      message: message,
      level: LokiLogLevel.fatal,
      labels: labels,
    );
    _logDispatcher.addLog(logEntry);
  }
}
