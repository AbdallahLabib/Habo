import 'package:equatable/equatable.dart';
import 'package:habo/core/helpers/constants.dart';

abstract class Failure extends Equatable {
  final String? message;
  final StackTrace? stackTrace;

  const Failure([this.message, this.stackTrace]);

  StackTrace? get stacktrace => stackTrace;
}

class NetworkFailure extends Failure {
  @override
  List<Object> get props => [];

  @override
  String toString() => NO_INTERNET_CONNECTION_FAILURE;
}

class TimeoutFailure extends Failure {
  @override
  List<Object> get props => [];

  @override
  String toString() => TIMEOUT_FAILURE;
}

class FormatFailure extends Failure {
  @override
  List<Object> get props => [];

  @override
  String toString() => FORMATTING_FAILURE;
}

class HttpFailure extends Failure {
  @override
  List<Object> get props => [];

  @override
  String toString() => HTTP_FAILURE;
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message, super.stacktrace]);

  @override
  List<Object> get props => [];

  @override
  String toString() => super.message ?? UNKNOWN_FAILURE;

  @override
  StackTrace? get stackTrace => super.stacktrace;
}
