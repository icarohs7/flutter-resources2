import 'dart:io';

File getFile(String path) {
  return File(path);
}

bool isTestEnvironment() => Platform.environment.containsKey('FLUTTER_TEST');
