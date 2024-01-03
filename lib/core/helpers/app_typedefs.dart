import 'package:fpdart/fpdart.dart';

import '../errors/failure.dart';

typedef FutureResult<T> = Future<Either<Failure, T>>;

typedef Result<T> = Either<Failure, T>;

typedef FutureVoid = Future<Either<Failure, void>>;
