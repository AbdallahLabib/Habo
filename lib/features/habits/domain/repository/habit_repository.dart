 import 'package:habo/core/helpers/app_typedefs.dart';
import 'package:habo/features/habits/domain/entities/habit_entity.dart';

abstract class HabitRepository {
  FutureVoid createHabit({required HabitEntity habit});

 /* Stream<List<HabitEntity>> getMyHabits();

  FutureVoid updateHabit({required HabitEntity event});

  FutureVoid deleteHabits({required List<String> habits});*/
}
 