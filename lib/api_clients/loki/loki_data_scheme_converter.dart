import 'package:gardena_stats_pusher/api_clients/loki/loki_log_entry.dart';
import 'package:gardena_stats_pusher/api_clients/loki/loki_log_level.dart';

class LokiDataSchemeConverter {
  LokiDataSchemeConverter({
    required Map<String, String> globalLabels,
  }) : _globalLabels = globalLabels;

  final Map<String, String> _globalLabels;

  Map<String, dynamic> toJson(
    List<LokiLogEntry> logEntries,
  ) {
    final logsWithNoCustomLabels =
        logEntries.where((logEntry) => logEntry.labels.isEmpty).toList();
    final logsWithCustomLabels =
        logEntries.where((logEntry) => logEntry.labels.isNotEmpty).toList();

    final logValuesForLevel = <LokiLogLevel, List<List<String>>>{};
    for (final logEntry in logsWithNoCustomLabels) {
      final logValues = logValuesForLevel[logEntry.level] ?? [];
      logValues.add([logEntry.timestamp, logEntry.message]);
      logValuesForLevel[logEntry.level] = logValues;
    }

    final streamsListWithNoCustomLabels = _getStreamsList(
      logValuesForLevel: logValuesForLevel,
      globalLabels: _globalLabels,
    );

    final streamsListWithCustomLabels = _getStreamsListWithCustomLabels(
      logEntries: logsWithCustomLabels,
      globalLabels: _globalLabels,
    );

    final json = <String, dynamic>{
      'streams': [
        ...streamsListWithNoCustomLabels,
        ...streamsListWithCustomLabels,
      ]
    };
    return json;
  }

  List<Map<String, Object>> _getStreamsListWithCustomLabels({
    required List<LokiLogEntry> logEntries,
    required Map<String, String> globalLabels,
  }) {
    return logEntries.map((logEntry) {
      final stream = _getStream(
        logLevel: logEntry.level,
        globalLabels: globalLabels,
      );
      stream.addAll(logEntry.labels);
      return {
        'stream': stream,
        'values': [
          [logEntry.timestamp, logEntry.message],
        ],
      };
    }).toList();
  }

  List<Map<String, dynamic>> _getStreamsList({
    required Map<LokiLogLevel, List<List<String>>> logValuesForLevel,
    required Map<String, String> globalLabels,
  }) {
    final streamsList = <Map<String, dynamic>>[];

    for (final logLevel in logValuesForLevel.keys) {
      final logValues = logValuesForLevel[logLevel];
      if (logValues?.isNotEmpty == true) {
        final stream = _getStream(
          logLevel: logLevel,
          globalLabels: globalLabels,
        );
        streamsList.add({
          'stream': stream,
          'values': logValues!,
        });
      }
    }
    return streamsList;
  }

  Map<String, String> _getStream({
    required LokiLogLevel logLevel,
    required Map<String, String> globalLabels,
  }) {
    final stream = {
      'level': logLevel.toLokiString(),
    };
    stream.addAll(globalLabels);
    return stream;
  }
}
