import 'package:gardena_stats_pusher/gardena_stats_pusher.dart'
    as gardena_stats_pusher;

void main(List<String> arguments) {
  try {
    gardena_stats_pusher.main();
  } catch (error) {
    print('gardena_stats_pusher failed with error: $error');
  }
}
