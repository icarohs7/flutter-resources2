import 'n_exception.dart';

class NFailure extends NException {
  const NFailure(Object? parentError, StackTrace? parentStackTrace, [String? message])
      : super(message ?? 'Erro ao realizar operação', parentError, parentStackTrace);

  const NFailure.message(String? message)
      : super(message ?? 'Erro ao realizar operação', null, null);

  @override
  String toString() => message;
}

class NOperationCancelledFailure extends NFailure {
  const NOperationCancelledFailure([Object? parentError, StackTrace? parentStackTrace])
      : super(parentError, parentStackTrace, 'Operação Cancelada');

  const NOperationCancelledFailure.msg(String? message)
      : super.message(message ?? 'Operação Cancelada');
}
