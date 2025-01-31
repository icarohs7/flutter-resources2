import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFailure extends Mock implements NFailure {}

void main() {
  group('eitherCast', () {
    test('returns Right when value is of type R', () {
      final result = eitherCast<int>(42, () => MockFailure());
      expect(result.isRight(), true);
      expect(result.getOrElse((_) => 0), 42);
    });

    test('returns Left when value is not of type R', () {
      final result = eitherCast<int>('not an int', () => MockFailure());
      expect(result.isLeft(), true);
    });
  });

  group('nTaskEitherDo', () {
    test('executes the function and returns a TaskEither', () async {
      final result = await nTaskEitherDo<int>(($, $$) async => 42).run();
      expect(result.isRight(), true);
      expect(result.getOrElse((_) => 0), 42);
    });

    test('returns a Left when the function fails', () async {
      final result = await nTaskEitherDo<int>(($, $$) async => $(left(MockFailure()))).run();
      expect(result.isLeft(), true);
    });
  });

  group('nTaskEitherDoBg', () {
    test('executes the function in the background and returns a TaskEither', () async {
      final result = await nTaskEitherDoBg<int>(($, $$) async => 42).run();
      expect(result.isRight(), true);
      expect(result.getOrElse((_) => 0), 42);
    });

    test('returns a Left when the function fails in the background', () async {
      final result = await nTaskEitherDoBg<int>(($, $$) async => $(left(MockFailure()))).run();
      expect(result.isLeft(), true);
    });
  });
}
