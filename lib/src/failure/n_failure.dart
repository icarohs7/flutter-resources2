import 'n_exception.dart';

class NFailure extends NException {
  NFailure(Object? parentError, StackTrace? parentStackTrace, [String? message])
    : super(message ?? 'Erro ao realizar operação', parentError, parentStackTrace);

  NFailure.message(String? message) : super(message ?? 'Erro ao realizar operação', null, null);

  @override
  String toString() => message;
}

class NOperationCancelledFailure extends NFailure {
  NOperationCancelledFailure([Object? parentError, StackTrace? parentStackTrace])
    : super(parentError, parentStackTrace, 'Operação Cancelada');

  NOperationCancelledFailure.msg(String? message) : super.message(message ?? 'Operação Cancelada');
}
