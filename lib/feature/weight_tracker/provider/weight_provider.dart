import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:ourpass/core/failure/failure.dart';
import 'package:ourpass/core/utils/async_value.dart';
import 'package:ourpass/core/utils/extensions.dart';
import 'package:ourpass/core/utils/pair.dart';
import 'package:ourpass/feature/weight_tracker/model/weight.dart';
import 'package:ourpass/feature/weight_tracker/repository/weight_repository.dart';

class WeightDataProvider with ChangeNotifier {
  final IWeightRepository _weightRepository;
  WeightDataProvider({required IWeightRepository weightRepository})
      : _weightRepository = weightRepository;

  AsyncValue<List<WeightModel>> _asyncValueOfWeightEntries =
      AsyncValue.loading();
  AsyncValue<List<WeightModel>> get asyncValueOfWeightEntries =>
      _asyncValueOfWeightEntries;
  set asyncValueOfWeightEntries(AsyncValue<List<WeightModel>> value) {
    _asyncValueOfWeightEntries = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// pair value that holds the percentage change and increase/decrease of the most recent entries
  Pair<double, bool>? pairOfPercentageChangeAndIncrease() {
    final entries = _asyncValueOfWeightEntries.data ?? [];
    if (entries.length >= 2) {
      final latestEntry = entries[0].value;
      final previousEntry = entries[1].value;
      final didIncreaseFromPreviousEntry = latestEntry > previousEntry;

      final percentageIncreaseOrDecrease = (latestEntry - previousEntry)
          .normalize(
              0, didIncreaseFromPreviousEntry ? latestEntry : previousEntry)
          .floorToDouble()
          .abs();

      return Pair(percentageIncreaseOrDecrease, didIncreaseFromPreviousEntry);
    }
    return null;
  }

  late StreamSubscription<Either<Failure, List<WeightModel>>> _subscription;

  void watchWeightEntries() {
    _subscription =
        _weightRepository.watchWeightEntries().listen((failureOrEntries) {
      failureOrEntries.fold(
        (failure) => asyncValueOfWeightEntries = AsyncValue.error(failure.msg),
        (entries) => asyncValueOfWeightEntries = AsyncValue.done(entries),
      );
    });
  }

  void unwatchWeightEntries() {
    _subscription.cancel();
  }

  Future<Either<Failure, Unit>> createEntry(WeightModel weight) async {
    isLoading = true;
    final failureOrSuccess = await _weightRepository.createEntry(weight);
    isLoading = false;
    return failureOrSuccess.fold(
      (failure) => left(failure),
      (_) => right(_),
    );
  }

  Future<Either<Failure, Unit>> updateOrDeleteEntry(WeightModel weight,
      {bool delete = false}) async {
    isLoading = true;
    final failureOrSuccess = await _weightRepository.updateOrDeleteEntry(
      weight,
      delete: delete,
    );
    isLoading = false;
    return failureOrSuccess.fold(
      (failure) => left(failure),
      (_) => right(_),
    );
  }
}
