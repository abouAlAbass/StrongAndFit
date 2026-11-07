import 'package:equatable/equatable.dart';

/// Base class representing failure domain results.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'A local database error occurred']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'The requested entity was not found']);
}
