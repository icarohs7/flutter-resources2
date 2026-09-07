import 'package:equatable/equatable.dart';

// ignore: prefer_const_constructors_in_immutables
class NException([
  final String message = 'NException',
  final Object? parentError,
  StackTrace? parentStackTrace,
  String? eventId,
]) extends Equatable implements Exception {
  final StackTrace? parentStackTrace = parentStackTrace ?? StackTrace.current;
  final String? eventId = eventId ?? (parentError is NException ? parentError.eventId : null);

  @override
  String toString() => 'NException: $message';

  @override
  List<Object?> get props => [message, parentError, parentStackTrace, eventId];

  //<editor-fold desc="Data Methods">
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'parentError': parentError,
      'parentStackTrace': parentStackTrace,
      if (eventId != null) 'eventId': eventId,
    };
  }

  factory fromJson(Map<String, dynamic> map) {
    return NException(
      map['message'] as String,
      map['parentError'] as Object?,
      map['parentStackTrace'] as StackTrace?,
      map['eventId'] as String?,
    );
  }
  //</editor-fold>
}
