import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ourpass/core/failure/failure.dart';
import 'package:ourpass/core/repository/repository.dart';
import 'package:ourpass/core/utils/extensions.dart';
import 'package:ourpass/feature/weight_tracker/model/weight.dart';

abstract class IWeightRepository {
  Stream<Either<Failure, List<WeightModel>>> watchWeightEntries();
  Future<Either<Failure, Unit>> createEntry(WeightModel weight);
  Future<Either<Failure, Unit>> updateOrDeleteEntry(WeightModel weight,
      {bool delete});
}

class WeightRepository extends Repository implements IWeightRepository {
  final FirebaseFirestore _firestore;
  WeightRepository(this._firestore);

  @override
  Future<Either<Failure, Unit>> createEntry(WeightModel weight) {
    return runGuard(
      () async {
        await _firestore
            .userEntryCollection()
            .doc(weight.id)
            .set(weight.toMap());
        return unit;
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> updateOrDeleteEntry(
    WeightModel weight, {
    bool delete = false,
  }) {
    return runGuard(
      () async {
        final docRef = _firestore.userEntryCollection().doc(weight.id);
        if (delete) {
          await docRef.delete();
        } else {
          await docRef.update(weight.toMap());
        }
        return unit;
      },
    );
  }

  @override
  Stream<Either<Failure, List<WeightModel>>> watchWeightEntries() async* {
    try {
      yield* _firestore
          .userEntryCollection()
          .orderBy("created_at", descending: true)
          .snapshots()
          .map(
            (snapshot) => right(
              snapshot.docs
                  .map(
                    (doc) => WeightModel.fromMap(doc.data()),
                  )
                  .toList(),
            ),
          );
    } on FirebaseException catch (e) {
      yield left(FirebaseFailure(e));
    } catch (e) {
      yield left(UnexpectedFailure());
    }
  }
}
