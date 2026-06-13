import 'dart:async';

import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart' as fp;

import '../mocks.dart';

void main() {
  group('Either.orNull', () {
    test('returns value on right', () {
      expect(right<int, int>(1).orNull(), 1);
    });

    test('returns null on left', () {
      expect(left<int, int>(0).orNull(), isNull);
    });
  });

  group('TaskEither.orNull', () {
    test('returns value on right', () async {
      expect(await TaskEither<int, int>.right(1).orNull(), 1);
    });

    test('returns null on left', () async {
      expect(await TaskEither<int, int>.left(0).orNull(), isNull);
    });
  });

  test('TaskEither.withLoading', () async {
    //arrange
    final completer = Completer();
    final isLoading = Reactor(false);
    final task = taskEitherDo<MockFailure, int>(($, $$) async {
      await completer.future;
      return 10;
    }).withLoading(isLoading);
    //assert
    expect(isLoading.value, false);

    //act
    final result = task.run();
    //assert
    expect(isLoading.value, true);

    //act
    completer.complete();
    //assert
    expect((await result).fold(identity, identity), 10);
    expect(isLoading.value, false);
  });

  test('Task.withLoading', () async {
    //arrange
    final completer = Completer();
    final isLoading = Reactor(false);
    final task = Task(() async {
      await completer.future;
      return 10;
    }).withLoading(isLoading);
    //assert
    expect(isLoading.value, false);

    //act
    final result = task.run();
    //assert
    expect(isLoading.value, true);

    //act
    completer.complete();
    //assert
    expect(await result, 10);
    expect(isLoading.value, false);
  });

  test('TaskEither.andThenRun runs the given operation and returns the original value', () async {
    var r = 0;
    final task = TaskEither<MockFailure, int>(() async => right(10)).andThenRun((_) => r = 1);
    final result = task.run();
    expect((await result).fold(identity, identity), 10);
    expect(r, equals(1));
  });

  test('TaskEither.andThenRun handles operation failure gracefully', () async {
    var a = 0;
    var b = 0;
    final task = TaskEither<MockFailure, int>(() async => right(10)).andThenRun((_) {
      a = 1;
      throw Exception('Operation failed');
      // ignore: dead_code
      b = 1;
    });
    final result = task.run();
    expect((await result).fold(identity, identity), 10);
    expect(a, equals(1));
    expect(b, equals(0));
  });

  test('TaskEither.andThenRunF runs the given operation and returns the original value', () async {
    final completer = Completer<void>();
    final task = TaskEither<MockFailure, int>(
      () async => right(10),
    ).andThenRunF((_) async => completer.future);
    final result = task.run();
    completer.complete();
    expect((await result).fold(identity, identity), 10);
  });

  test('TaskEither.andThenRunF handles operation failure gracefully', () async {
    final task = TaskEither<MockFailure, int>(
      () async => right(10),
    ).andThenRunF((_) async => throw Exception('Operation failed'));
    final result = task.run();
    expect((await result).fold(identity, identity), 10);
  });

  test('TaskEither.withTimeout returns left on timeout', () async {
    final task = TaskEither<MockFailure, int>(
      () async => Future.delayed(Duration(seconds: 2), () => right(10)),
    ).withTimeout(Duration(seconds: 1), () => MockFailure());
    final result = task.run();
    expect((await result).fold(identity, (_) => null), isA<MockFailure>());
  });

  test('TaskEither.withTimeout returns right if completed within timeout', () async {
    final task = TaskEither<MockFailure, int>(
      () async => Future.delayed(Duration(seconds: 1), () => right(10)),
    ).withTimeout(Duration(seconds: 2), () => MockFailure());
    final result = task.run();
    expect((await result).fold(identity, identity), 10);
  });

  group('TaskEither.withTiming', () {
    late List<LogRecord> records;
    late StreamSubscription<LogRecord> subscription;

    setUp(() {
      records = [];
      subscription = Logger.root.onRecord.listen(records.add);
    });

    tearDown(() async {
      await subscription.cancel();
    });

    test('logs completion and returns right result', () async {
      final task = TaskEither<MockFailure, int>(() async => right(10)).withTiming('fetch');
      final result = await task.run();

      expect(result.fold(identity, identity), 10);
      expect(records, hasLength(1));
      expect(records.first.level, Level.INFO);
      expect(records.first.message, matches(RegExp(r'^\[fetch\] completed in \d+ms$')));
    });

    test('logs completion and returns left result', () async {
      final failure = MockFailure();
      final task = TaskEither<MockFailure, int>(() async => left(failure)).withTiming('fetch');
      final result = await task.run();

      expect(result.fold(identity, (_) => null), failure);
      expect(records, hasLength(1));
      expect(records.first.level, Level.INFO);
      expect(records.first.message, matches(RegExp(r'^\[fetch\] completed in \d+ms$')));
    });

    test('rethrows and logs failure when run throws', () async {
      final task = TaskEither<MockFailure, int>(() async {
        throw Exception('boom');
      }).withTiming('fetch');

      await expectLater(task.run(), throwsA(isA<Exception>()));
      expect(records, hasLength(1));
      expect(records.first.level, Level.INFO);
      expect(records.first.message, matches(RegExp(r'^\[fetch\] failed in \d+ms$')));
    });
  });

  test('TaskEither.moveToIsolate runs the task on an isolate and returns the result', () async {
    final task = TaskEither<MockFailure, int>(() async => right(10)).moveToIsolate();
    final result = task.run();
    expect((await result).fold(identity, identity), 10);
  });

  test('Task.andThenF runs the given operation and returns its result', () async {
    final completer = Completer<int>();
    final task = Task(() async => 10).andThenF(() async => completer.future);
    final result = task.run();
    completer.complete(20);
    expect(await result, 20);
  });

  test('Task.andThenRunF runs the given operation and returns the original value', () async {
    final completer = Completer<void>();
    final task = Task(() async => 10).andThenRunF((_) async => completer.future);
    final result = task.run();
    completer.complete();
    expect(await result, 10);
  });

  test('Task.andThenRunF handles operation failure gracefully', () async {
    final task = Task(() async => 10).andThenRunF((_) async => throw Exception('Operation failed'));
    final result = task.run();
    expect(await result, 10);
  });

  test('Future<void>.unit converts to Future<Unit>', () async {
    final future = Future<void>.value();
    final result = await future.unit;
    expect(result, fp.unit);
  });

  test('void Function().unit changes return type to Unit', () {
    fn() {}
    final unitFn = fn.unit;
    expect(unitFn(), fp.unit);
  });

  test('Future<void> Function().unit changes return type to Future<Unit>', () async {
    fn() async {}
    final unitFn = fn.unit;
    final result = await unitFn();
    expect(result, fp.unit);
  });
}
