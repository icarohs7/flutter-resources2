import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NDurationExtensions', () {
    test('stringify returns correct string for duration with days, hours, minutes, and seconds',
        () {
      final duration = Duration(days: 1, hours: 2, minutes: 3, seconds: 4);
      expect(duration.stringify, '1 dia, 2 horas, 3 minutos, 4 segundos');
    });

    test('stringify returns correct string for duration with only hours, minutes, and seconds', () {
      final duration = Duration(hours: 2, minutes: 3, seconds: 4);
      expect(duration.stringify, '2 horas, 3 minutos, 4 segundos');
    });

    test('stringify returns correct string for duration with only minutes and seconds', () {
      final duration = Duration(minutes: 3, seconds: 4);
      expect(duration.stringify, '3 minutos, 4 segundos');
    });

    test('stringify returns correct string for duration with only seconds', () {
      final duration = Duration(seconds: 4);
      expect(duration.stringify, '4 segundos');
    });

    test('stringify returns correct string for duration with only one unit', () {
      final duration = Duration(days: 1);
      expect(duration.stringify, '1 dia');
    });

    test('stringify returns empty string for zero duration', () {
      const duration = Duration.zero;
      expect(duration.stringify, '');
    });
  });
}
