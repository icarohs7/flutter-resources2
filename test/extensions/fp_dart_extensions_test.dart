import 'dart:async';

import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
