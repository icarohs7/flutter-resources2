import 'package:core_resources/core_resources.dart';
import 'package:flutter/foundation.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart' as fp;
import 'package:reactor_fp_resources/reactor_fp_resources.dart';

extension NTaskEitherExtensions<L, R> on TaskEither<L, R> {
  /// Change the given [loadingObservable] to true when the task
  /// start running, changing it to false when the execution is done
  TaskEither<L, R> withLoading(ValueNotifier<bool> loadingObservable) {
    return TaskEither(() async {
      try {
        loadingObservable.value = true;
        return await run();
      } finally {
        loadingObservable.value = false;
      }
    });
  }

  /// Run the given operation if the result of
  /// `this` is [right], ignoring the operation's
  /// result and passing the original value down
  /// the chain
  TaskEither<L, R> andThenRunF(Future<void> Function(R) op) {
    return flatMap((r) {
      return TaskEither(() async {
        await op(r).orNull();
        return right(r);
      });
    });
  }

  /// If the execution of the task takes more time than
  /// [timeout], return a left wraping the result of
  /// calling [onTimeout]
  TaskEither<L, R> withTimeout(Duration timeout, L Function() onTimeout) {
    return TaskEither(() async {
      return await run().timeout(timeout, onTimeout: () => left(onTimeout()));
    });
  }

  /// Make the operation of the given [TaskEither]
  /// run on an isolate through the [compute] function
  /// from Flutter
  TaskEither<L, R> moveToIsolate() => TaskEither(() => compute((_) => run(), 0));
}

extension NTaskExtensions<R> on Task<R> {
  /// Run this [Task] and right after the [Future] returned from `then`.
  Task<B> andThenF<B>(Future<B> Function() then) => andThen(() => Task(() => then()));

  /// Run the given operation
  /// ignoring the parameterized operation's
  /// result and passing the original value down
  /// the chain
  Task<R> andThenRunF(Future<void> Function(R) op) {
    return flatMap((r) {
      return Task(() async {
        await op(r).orNull();
        return r;
      });
    });
  }

  /// Change the given [loadingObservable] to true when the task
  /// start running, changing it to false when the execution is done
  Task<R> withLoading(ValueNotifier<bool> loadingObservable) {
    return Task(() async {
      try {
        loadingObservable.value = true;
        return await run();
      } finally {
        loadingObservable.value = false;
      }
    });
  }
}

extension NFutureVoidExtensions on Future<void> {
  /// Convert an async [void] to an async [unit]
  Future<Unit> get unit => then((_) => fp.unit);
}

extension NVoidFnExtensions0 on void Function() {
  /// Change the return type of the function to [Unit]
  Unit Function() get unit =>
          () {
        this();
        return fp.unit;
      };
}

extension NVoidFnExtensions1<A> on void Function<A>(A) {
  /// Change the return type of the function to [Unit]
  Unit Function(A) get unit =>
          (a) {
        this(a);
        return fp.unit;
      };
}

extension NVoidFnExtensions2<A, B> on void Function<A, B>(A, B) {
  /// Change the return type of the function to [Unit]
  Unit Function(A, B) get unit =>
          (a, b) {
        this(a, b);
        return fp.unit;
      };
}

extension NFutureVoidFnExtensions0 on Future<void> Function() {
  /// Change the return type of the function to [Future<Unit>]
  Future<Unit> Function() get unit =>
          () async {
        await this();
        return fp.unit;
      };
}

extension NFutureVoidFnExtensions1<A> on Future<void> Function<A>(A) {
  /// Change the return type of the function to [Future<Unit>]
  Future<Unit> Function(A) get unit =>
          (a) async {
        await this(a);
        return fp.unit;
      };
}

extension NFutureVoidFnExtensions2<A, B> on Future<void> Function<A, B>(A, B) {
  /// Change the return type of the function to [Future<Unit>]
  Future<Unit> Function(A, B) get unit =>
          (a, b) async {
        await this(a, b);
        return fp.unit;
      };
}
