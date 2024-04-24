import 'dart:convert';

import 'package:gardena_stats_pusher/api_clients/gardena/gardena_api_data_provider.dart';
import 'package:gardena_stats_pusher/factories/device_factory.dart';
import 'package:gardena_stats_pusher/factories/location_factory.dart';
import 'package:gardena_stats_pusher/logger.dart';
import 'package:gardena_stats_pusher/models/gardena_location.dart';
import 'package:http/http.dart' as http;

import 'package:gardena_stats_pusher/models/device.dart';

class GardenaStatsClient {
  GardenaStatsClient() {
    final apiDataProvider = GardenaApiDataProvider();
    _clientId = apiDataProvider.getApiClientId();
    _clientSecret = apiDataProvider.getApiClientSecret();
  }

  late final String _clientId;
  late final String _clientSecret;

  String? _accessToken;

  Future<String> _getToken() async {
    final url = 'https://api.authentication.husqvarnagroup.dev/v1/oauth2/token';
    final response = await http.post(
      Uri.parse(url),
      body: <String, String>{
        'grant_type': 'client_credentials',
        'client_id': _clientId,
        'client_secret': _clientSecret,
      },
    );

    final body = json.decode(response.body);
    final accessToken = body['access_token'];
    if (accessToken == null) {
      throw Exception('No access token found');
    }
    _accessToken = accessToken;
    return accessToken;
  }

  Future<List<GardenaLocation>> getLocations() async {
    final accessToken = _accessToken ?? await _getToken();

    final url = 'https://api.smart.gardena.dev/v1/locations';
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'authorization': 'Bearer $accessToken',
        'X-Api-Key': _clientId,
      },
    );

    final body = json.decode(response.body);
    final data = body['data'];
    final locations = GardenaLocationFactory.locationsFromJson(data);
    logger.info('Got Gardena locations: $locations');
    return locations;
  }

  Future<List<Device>> getDevices(GardenaLocation location) async {
    final accessToken = _accessToken ?? await _getToken();
    final locationId = location.id;
    final url = 'https://api.smart.gardena.dev/v1/locations/$locationId';

    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'authorization': 'Bearer $accessToken',
        'X-Api-Key': _clientId,
      },
    );

    final body = json.decode(response.body);
    final devices = _getAllDevices(body);

    final devicesNames = devices.map((device) => device.name).join(',');
    logger.info('Found Gardena Devices: $devicesNames');

    return devices;
  }

  List<Device> _getAllDevices(Map<String, dynamic> jsonData) {
    final List<Device> devices = [];
    final includedList = jsonData['included'];
    for (final includedItem in includedList) {
      if (includedItem['type'] == 'VALVE') {
        devices.add(ValveFactory.fromJson(includedItem, includedList));
      } else if (includedItem['type'] == 'SENSOR') {
        devices.add(SensorFactory.fromJson(includedItem, includedList));
      }
    }
    return devices;
  }
}
