import 'package:gardena_stats_pusher/api_clients/gardena/gardena_stats_client.dart';
import 'package:gardena_stats_pusher/logger.dart';
import 'package:gardena_stats_pusher/services/prometheus_service.dart';

void main() async {
  logger.info('Starting up Gardena Stats Pusher.');

  try {
    final gardenaStatClient = GardenaStatsClient();
    final locations = await gardenaStatClient.getLocations();
    final devices = await gardenaStatClient.getDevices(locations.first);

    final promService = PrometheusService();
    promService.sendMetrics(forDevices: devices);
  } catch (error) {
    print('Error: $error');
    logger.error('Failed to send metrics with: $error');
  }
}
