import 'package:gardena_stats_pusher/api_clients/prometheus/prometheus_metrics_client.dart';

abstract class Device {
  String get id;
  String get name;
  CommonDevice? get common;

  List<PrometheusMetricValue> getMetricValues();
  Map<String, String> getLabels();
}

class Valve implements Device {
  Valve({
    required this.id,
    required this.name,
    required this.activity,
    required this.state,
    required this.lastErrorCode,
    required this.common,
  });

  @override
  final String id;

  @override
  final String name;

  @override
  final CommonDevice? common;

  final String activity; // "CLOSED"

  final String state; // "OK"

  final String lastErrorCode; // "NO_MESSAGE"

  @override
  String toString() {
    return 'Valve(name: $name, activity: $activity, state: $state, lastErrorCode: $lastErrorCode, common: $common)';
  }

  @override
  List<PrometheusMetricValue> getMetricValues() {
    return [
      PrometheusMetricValue(name: 'activity', value: getActivityAsInt()),
      if (common?.batteryLevel != null)
        PrometheusMetricValue(
            name: 'batteryLevel', value: common!.batteryLevel!),
      if (common?.rfLinkLevel != null)
        PrometheusMetricValue(name: 'linkLevel', value: common!.rfLinkLevel),
    ];
  }

  @override
  Map<String, String> getLabels() {
    final labels = <String, String>{
      'type': 'valve',
      'name': name,
      'device_id': id,
    };
    if (common != null) {
      labels.addAll(common!.getLabels());
    }
    return labels;
  }

  int getActivityAsInt() {
    return activity == 'CLOSED' ? 0 : 1;
  }
}

class Sensor implements Device {
  Sensor({
    required this.id,
    required this.soilHumidity,
    required this.soilTemperature,
    required this.common,
  });

  @override
  final String id; // "1e3d2609-3f5a-4875-be0c-197daf7bfe23"

  @override
  String get name => common.name;

  @override
  final CommonDevice common;

  final int soilHumidity; // 70

  final int soilTemperature; // 3

  @override
  String toString() {
    return 'Sensor(name: $name, soilHumidity: $soilHumidity, soilTemperature: $soilTemperature, common: $common)';
  }

  @override
  List<PrometheusMetricValue> getMetricValues() {
    return [
      PrometheusMetricValue(name: 'humidity', value: soilHumidity),
      PrometheusMetricValue(name: 'temperature', value: soilTemperature),
      if (common.batteryLevel != null)
        PrometheusMetricValue(
            name: 'batteryLevel', value: common.batteryLevel!),
      PrometheusMetricValue(name: 'linkLevel', value: common.rfLinkLevel),
    ];
  }

  @override
  Map<String, String> getLabels() {
    final labels = <String, String>{
      'type': 'sensor',
      'name': name,
      'device_id': id,
    };
    labels.addAll(common.getLabels());
    return labels;
  }
}

class CommonDevice {
  CommonDevice({
    required this.id,
    required this.name,
    required this.batteryState,
    required this.batteryLevel,
    required this.modelType,
    required this.rfLinkLevel,
    required this.rfLinkState,
  });

  final String id; // "1e3d2609-3f5a-4875-be0c-197daf7bfe23"
  final String name; // "Irrigation Control"
  final String batteryState; // "NO_BATTERY"
  final int? batteryLevel; // 81
  final String modelType; // "GARDENA smart Irrigation Control"
  final int rfLinkLevel; // 100,
  final String rfLinkState; // "ONLINE"

  @override
  String toString() {
    return 'Common(name: $name, batteryState: $batteryState, batteryLevel: $batteryLevel, modelType: $modelType, rfLinkLevel: $rfLinkLevel, rfLinkState: $rfLinkState)';
  }

  Map<String, String> getLabels() {
    return <String, String>{
      'batteryState': batteryState,
      'modelType': modelType,
      'linkState': rfLinkState,
    };
  }
}
