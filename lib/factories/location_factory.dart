import 'package:gardena_stats_pusher/models/gardena_location.dart';

class GardenaLocationFactory {
  static List<GardenaLocation> locationsFromJson(
    List<dynamic> json,
  ) {
    final locations = <GardenaLocation>[];
    for (final locationJson in json) {
      locations.add(GardenaLocationFactory.locationFromJson(locationJson));
    }
    print(json);
    return locations;
  }

  static GardenaLocation locationFromJson(
    Map<String, dynamic> json,
  ) {
    return GardenaLocation(
      id: json['id'],
      name: json['attributes']['name'],
    );
  }
}
