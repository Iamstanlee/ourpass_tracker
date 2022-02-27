import 'package:firebase_core/firebase_core.dart';

abstract class Failure {
  String get msg;
}

class FirebaseFailure implements Failure {
  final FirebaseException exception;
  FirebaseFailure(this.exception);

  @override
  String get msg => exception.message ?? "An error occured with the server";
}

class NotFoundFailure implements Failure {
  @override
  String get msg => "entity not found";
}

class UnexpectedFailure implements Failure {
  @override
  String get msg => "An unexpected error occured";
}
