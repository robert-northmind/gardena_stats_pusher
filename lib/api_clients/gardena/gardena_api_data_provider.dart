import 'dart:io';

class GardenaApiDataProvider {
  String getApiClientId() {
    final clientId = Platform.environment['GARDENA_CLIENT_ID'];
    if (clientId == null) {
      throw Exception('GARDENA_CLIENT_ID is not set');
    }
    return clientId;
  }

  String getApiClientSecret() {
    final clientSecret = Platform.environment['GARDENA_CLIENT_SECRET'];
    if (clientSecret == null) {
      throw Exception('GARDENA_CLIENT_SECRET is not set');
    }
    return clientSecret;
  }
}
