import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {
  final String message;
  ServerFailure(this.message);
}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class ConnectionFailure extends Failure {}
