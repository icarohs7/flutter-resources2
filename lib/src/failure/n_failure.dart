import 'n_exception.dart';

class NFailure extends NException {
  new(Object? parentError, StackTrace? parentStackTrace, [String? message])
    : super(message ?? 'Erro ao realizar operação', parentError, parentStackTrace);

  new message(String? message) : super(message ?? 'Erro ao realizar operação', null, null);

  @override
  String toString() => message;
}

class NOperationCancelledFailure extends NFailure {
  new([Object? parentError, StackTrace? parentStackTrace])
    : super(parentError, parentStackTrace, 'Operação Cancelada');

  new msg(String? message) : super.message(message ?? 'Operação Cancelada');
}
