// ignore_for_file: avoid_print

import 'dart:io';

Future<void> runCommand(String command) async {
  print('Running: $command\n');

  final parts = command.split(' ');
  final executable = parts.first;
  final arguments = parts.skip(1).toList();

  final result = await Process.run(executable, arguments, runInShell: true);

  if (result.stdout.toString().isNotEmpty) stdout.write(result.stdout);
  if (result.stderr.toString().isNotEmpty) stderr.write(result.stderr);

  if (result.exitCode != 0) {
    print('Command failed: $command');
    print('Exit code: ${result.exitCode}');
    exit(result.exitCode);
  }
}

void main() async {
  final commands = [
    'flutter packages get',
    'flutter pub run build_runner build',
    'flutter analyze',
    'flutter test --coverage',
  ];

  for (final command in commands) {
    await runCommand(command);
  }

  print('\nModule succeeded building');
}
