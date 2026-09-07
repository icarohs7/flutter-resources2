import 'package:flutter_resources2/flutter_resources2.dart';

class const MockFailure([final String message = 'Test Failure'])
    extends Equatable
    implements Exception {
  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}
