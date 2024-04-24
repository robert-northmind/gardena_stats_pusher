class LokiConfiguration {
  LokiConfiguration({
    required this.url,
    required this.username,
    required this.accessToken,
    // Ability to provide batch-time?
    // Ability to log level filter??
    this.labels = const {},
  });

  final String url;
  final String username;
  final String accessToken;
  final Map<String, String> labels;
}
