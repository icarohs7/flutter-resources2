import 'dart:async';

import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart' as fp;

import '../mocks.dart';

void main() {
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

  test('TaskEither.andThenRunF runs the given operation and returns the original value', () async {
    final completer = Completer<void>();
    final task = TaskEither<MockFailure, int>(() async => right(10)).andThenRunF((_) async => completer.future);
    final result = task.run();
    completer.complete();
    expect((await result).fold(identity, identity), 10);
  });

  test('TaskEither.andThenRunF handles operation failure gracefully', () async {
    final task = TaskEither<MockFailure, int>(() async => right(10)).andThenRunF((_) async => throw Exception('Operation failed'));
    final result = task.run();
    expect((await result).fold(identity, identity), 10);
  });

  test('TaskEither.withTimeout returns left on timeout', () async {
    final task = TaskEither<MockFailure, int>(() async => Future.delayed(Duration(seconds: 2), () => right(10)))
        .withTimeout(Duration(seconds: 1), () => MockFailure());
    final result = task.run();
    expect((await result).fold(identity, (_) => null), isA<MockFailure>());
  });

  test('TaskEither.withTimeout returns right if completed within timeout', () async {
    final task = TaskEither<MockFailure, int>(() async => Future.delayed(Duration(seconds: 1), () => right(10)))
        .withTimeout(Duration(seconds: 2), () => MockFailure());
    final result = task.run();
    expect((await result).fold(identity, identity), 10);
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
