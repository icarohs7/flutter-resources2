import 'package:reactor_fp_resources/reactor_fp_resources.dart';

import '../failure/failure.dart';

typedef NEither<R> = Either<NFailure, R>;
typedef NIOEither<R> = IOEither<NFailure, R>;
typedef NTaskEither<R> = TaskEither<NFailure, R>;
typedef NRight<R> = Right<NFailure, R>;
typedef NLeft<R> = Left<NFailure, R>;
