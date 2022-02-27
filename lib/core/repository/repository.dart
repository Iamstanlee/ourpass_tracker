import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ourpass/core/failure/exception.dart';
import 'package:ourpass/core/failure/failure.dart';

class Repository {
  Future<Either<Failure, R>> runGuard<R>(Future<R> Function() future) async {
    try {
      final result = await future();
      return right(result);
    } on FirebaseException catch (e) {
      return left(FirebaseFailure(e));
    } on NotfoundException catch (_) {
      return left(NotFoundFailure());
    } catch (e) {
      return left(UnexpectedFailure());
    }
  }
}
