import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habo/core/errors/failure.dart';
import 'package:habo/core/helpers/app_typedefs.dart';
import 'package:habo/core/helpers/firebase_providers.dart';
import 'package:habo/features/habits/data/model/habit_model.dart';
import 'package:habo/features/habits/domain/entities/habit_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

final habitRemoteDataSourceProvider = Provider<HabitRemoteDataSource>((ref) {
  return IHabitRemoteDateSource(firestore: ref.read(firestoreProvider));
});

abstract class HabitRemoteDataSource {
  FutureVoid createHabit({required HabitEntity habit});

/*   Stream<List<HabitEntity>> getMyHabits();

  FutureVoid updateHabit({required HabitEntity habit});

  FutureVoid deleteHabits({required List<String> habits}); */
}

class IHabitRemoteDateSource extends HabitRemoteDataSource {
  final FirebaseFirestore firestore;

  IHabitRemoteDateSource({required this.firestore});

  @override
  FutureVoid createHabit({required HabitEntity habit}) async {
    try {
      final habitRef = firestore.collection('habit').doc();

      final habitModel = HabitModel(
        userId: habit.userId.trim(),
        habitName: habit.habitName,
      );

      await habitRef.set(habitModel.toMap());

      return right(null);
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

/*   @override
  Stream<List<HabitEntity>> getMyHabits() {
    try {
      return firestore
          .collection('habit')
          .where('userId', isEqualTo: 'HqfRpEga6B1eKW6tLcnN ')
          .snapshots()
          .asyncMap((event) =>
              event.docs.map((e) => HabitModel.fromMap(e.data())).toList());
    } on FirebaseException catch (e) {
      return Stream.error(e.message.toString());
    }
  }

  @override
  FutureVoid deleteHabits({required List<String> habits}) async {
    try {
      // remove events from event_types collection
      await firestore
          .collection('event_types')
          .get()
          .then((value) => value.docs.forEach((element) async {
                await element.reference.update({
                  'events': FieldValue.arrayRemove(events),
                });
              }));

      await firestore
          .collection('events')
          .where('eventId', whereIn: events)
          .get()
          .then((value) => value.docs.forEach((element) async {
                await element.reference.delete();
              }));
      return right(null);
    } on FirebaseException catch (e) {
      return left(UnknownFailure(e.message.toString()));
    }
  }

  @override
  FutureVoid updateHabit({required HabitEntity habit}) async {
    try {
      final habitRef = firestore.collection('habit').doc(habit.eventId);

      final eventModel = HabitModel(
        userId: habit.userId.trim(),
        habitName: habit.habitName,
      );

      habitRef.update(eventModel.toMap());

      return right(null);
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }
 */
}
