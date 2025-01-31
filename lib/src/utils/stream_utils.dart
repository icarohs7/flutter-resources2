import 'package:core_resources/core_resources.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';

Stream<T> streamFromTask<T>(Task<T> task) {
  return invoke(() async* {
    yield* Stream.fromFuture(task.run());
  }).asBroadcastStream();
}
