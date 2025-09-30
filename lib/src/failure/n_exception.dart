import 'package:equatable/equatable.dart';

class NException extends Equatable implements Exception {
  final String message;
  final Object? parentError;
  final StackTrace? parentStackTrace;

  NException([this.message = 'NException', this.parentError, StackTrace? parentStackTrace])
      : parentStackTrace = parentStackTrace ?? StackTrace.current;

  @override
  String toString() => 'NException: $message';

  @override
  List<Object?> get props => [message, parentError, parentStackTrace];

  //<editor-fold desc="Data Methods">
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'parentError': parentError,
      'parentStackTrace': parentStackTrace,
    };
  }

  factory NException.fromJson(Map<String, dynamic> map) {
    return NException(
      map['message'] as String,
      map['parentError'] as Object?,
      map['parentStackTrace'] as StackTrace?,
    );
  }
//</editor-fold>
}
