import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:ourpass/core/failure/failure.dart';
import 'package:ourpass/core/model/user.dart';
import 'package:ourpass/core/utils/async_value.dart';
import 'package:ourpass/feature/authentication/repository/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final IAuthRepository _authRepository;
  AuthProvider({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  AsyncValue<UserModel> _asyncValueOfUser = AsyncValue.loading();
  AsyncValue<UserModel> get asyncValueOfUser => _asyncValueOfUser;
  set asyncValueOfUser(AsyncValue<UserModel> value) {
    _asyncValueOfUser = value;
    notifyListeners();
  }

  UserModel get user => _asyncValueOfUser.data ?? UserModel(uid: '');

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void getUser() async {
    final failureOrUser = await _authRepository.getUser();
    failureOrUser.fold((failure) {
      asyncValueOfUser = AsyncValue.error(failure.msg);
    }, (data) => asyncValueOfUser = AsyncValue.done(data));
  }

  Future<Either<Failure, Unit>> signInAnonymously() async {
    isLoading = true;
    final failureOrUser = await _authRepository.signInAnonymously();
    isLoading = false;
    return failureOrUser.fold((failure) {
      asyncValueOfUser = AsyncValue.error(failure.msg);
      return left(failure);
    }, (data) {
      asyncValueOfUser = AsyncValue.done(data);
      return right(unit);
    });
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    asyncValueOfUser = AsyncValue.error(NotFoundFailure().msg);
  }
}
