import 'package:gardena_stats_pusher/models/device.dart';

class ValveFactory {
  static Valve fromJson(
    Map<String, dynamic> jsonItem,
    List<dynamic> jsonList,
  ) {
    final Map<String, dynamic> attributes = jsonItem['attributes'];
    final id = jsonItem['id'];

    final commonDeviceJson = jsonList
        .where((element) {
          if (element['id'] == id && element['type'] == 'COMMON') {
            return true;
          } else {
            return false;
          }
        })
        .toList()
        .firstOrNull;
    final common = commonDeviceJson != null
        ? CommonDeviceFactory.fromJson(commonDeviceJson)
        : null;

    final String name = common?.name ?? attributes.getValue('name');

    return Valve(
      id: id,
      name: name,
      activity: attributes['activity']['value'],
      state: attributes['state']['value'],
      lastErrorCode: attributes['lastErrorCode']['value'],
      common: common,
    );
  }
}

class SensorFactory {
  static Sensor fromJson(
    Map<String, dynamic> jsonItem,
    List<dynamic> jsonList,
  ) {
    final Map<String, dynamic> attributes = jsonItem['attributes'];
    final id = jsonItem['id'];

    final commonDeviceJson = jsonList
        .where((element) {
          if (element['id'] == id && element['type'] == 'COMMON') {
            return true;
          } else {
            return false;
          }
        })
        .toList()
        .firstOrNull;

    return Sensor(
      id: id,
      soilHumidity: attributes.getValue('soilHumidity'),
      soilTemperature: attributes.getValue('soilTemperature'),
      common: CommonDeviceFactory.fromJson(commonDeviceJson),
    );
  }
}

class CommonDeviceFactory {
  static CommonDevice fromJson(
    Map<String, dynamic> jsonItem,
  ) {
    final Map<String, dynamic> attributes = jsonItem['attributes'];

    return CommonDevice(
      id: jsonItem['id'],
      name: attributes.getValue('name'),
      batteryState: attributes.getValue('batteryState'),
      batteryLevel: attributes.getValue('batteryLevel'),
      modelType: attributes.getValue('modelType'),
      rfLinkLevel: attributes.getValue('rfLinkLevel'),
      rfLinkState: attributes.getValue('rfLinkState'),
    );
  }
}

extension MapX<T> on Map<String, dynamic> {
  T getValue(String key) {
    final valueMap = this[key];
    if (valueMap == null) {
      throw Exception('ValueMap not found for: $key');
    }
    final value = valueMap['value'];
    if (value == null) {
      throw Exception('Value not found for: $key');
    }
    return value;
  }
}
