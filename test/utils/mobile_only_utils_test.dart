import 'dart:io';

import 'package:flutter_resources2/src/utils/mobile_only_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getFile', () {
    test('returns a File object for a valid path', () {
      final file = getFile('valid/path/to/file.txt');
      expect(file, isA<File>());
      expect(file.path, 'valid/path/to/file.txt');
    });

    test('returns a File object for an empty path', () {
      final file = getFile('');
      expect(file, isA<File>());
      expect(file.path, '');
    });

    test('returns a File object for a non-existent path', () {
      final file = getFile('non/existent/path/to/file.txt');
      expect(file, isA<File>());
      expect(file.path, 'non/existent/path/to/file.txt');
    });
  });
}
