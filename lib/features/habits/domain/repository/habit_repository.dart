 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habo/core/helpers/app_typedefs.dart';
import 'package:habo/features/habits/data/datasource/habit_remote_data_source.dart';
import 'package:habo/features/habits/data/repositories/i_habit_repository.dart';
import 'package:habo/features/habits/domain/entities/habit_entity.dart';

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return IHabitRepository(
    habitRemoteDataSource: ref.read(habitRemoteDataSourceProvider),
  );
});

abstract class HabitRepository {
  FutureVoid createHabit({required HabitEntity habit});

 /* Stream<List<HabitEntity>> getMyHabits();

  FutureVoid updateHabit({required HabitEntity event});

  FutureVoid deleteHabits({required List<String> habits});*/
}
 