import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}
//General failures

class ServerException extends Failure {}

class CacheException extends Failure  {}

