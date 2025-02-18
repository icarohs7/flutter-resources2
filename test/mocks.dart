import 'package:flutter_resources2/flutter_resources2.dart';

class MockFailure extends Equatable implements Exception {
  final String message;

  const MockFailure([this.message = 'Test Failure']);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}
