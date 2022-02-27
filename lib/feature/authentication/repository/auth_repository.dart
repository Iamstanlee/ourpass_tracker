import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ourpass/core/failure/exception.dart';
import 'package:ourpass/core/failure/failure.dart';
import 'package:ourpass/core/model/user.dart';
import 'package:ourpass/core/repository/repository.dart';

abstract class IAuthRepository {
  Future<Either<Failure, UserModel>> signInAnonymously();
  Future<void> signOut();
  Future<Either<Failure, UserModel>> getUser();
}

class AuthRepository extends Repository implements IAuthRepository {
  final FirebaseAuth _auth;
  AuthRepository(this._auth);

  @override
  Future<Either<Failure, UserModel>> signInAnonymously() {
    return runGuard<UserModel>(() async {
      final credentials = await _auth.signInAnonymously();
      return UserModel(uid: credentials.user!.uid);
    });
  }

  @override
  Future<Either<Failure, UserModel>> getUser() {
    return runGuard<UserModel>(() async {
      final user = _auth.currentUser;
      if (user != null) {
        return UserModel(uid: user.uid);
      }
      throw NotfoundException();
    });
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
