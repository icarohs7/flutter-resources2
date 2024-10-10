import 'package:reactor_fp_resources/reactor_fp_resources.dart';

import '../failure/failure.dart';
import '../types/types.dart';

Either<NFailure, R> eitherCast<R>(dynamic value, NFailure Function() onFailure) {
  return switch (value) {
    R v => right(v),
    _ => left(onFailure()),
  };
}

NTaskEither<R> nTaskEitherDo<R>(CRDoFunctionTaskEither<NFailure, R> f) => taskEitherDo(f);

NTaskEither<R> nTaskEitherDoBg<R>(CRDoFunctionTaskEither<NFailure, R> f) => taskEitherDoBg(f);
