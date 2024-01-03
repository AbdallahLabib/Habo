import 'package:equatable/equatable.dart';

import '../helpers/app_typedefs.dart';

abstract class FutureUseCase<Type, Params> {
  FutureResult<Type> call(Params params);
}

abstract class UseCase<Type, Params> {
  Result<Type> call(Params params);
}

abstract class VoidUseCase<Type, Params> {
  void call(Params params);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
