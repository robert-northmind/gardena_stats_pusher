enum LokiLogLevel {
  trace,
  debug,
  info,
  warning,
  error,
  fatal,
}

extension ToStringX on LokiLogLevel {
  String toLokiString() {
    switch (this) {
      case LokiLogLevel.trace:
        return 'TRACE';
      case LokiLogLevel.debug:
        return 'DEBUG';
      case LokiLogLevel.info:
        return 'INFO';
      case LokiLogLevel.warning:
        return 'WARNING';
      case LokiLogLevel.error:
        return 'ERROR';
      case LokiLogLevel.fatal:
        return 'FATAL';
    }
  }
}
