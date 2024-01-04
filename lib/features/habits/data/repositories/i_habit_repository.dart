
import 'package:habo/core/helpers/app_typedefs.dart';
import 'package:habo/features/habits/data/datasource/habit_remote_data_source.dart';
import 'package:habo/features/habits/domain/entities/habit_entity.dart';
import 'package:habo/features/habits/domain/repository/habit_repository.dart';

class IHabitRepository extends HabitRepository {
  final HabitRemoteDataSource habitRemoteDataSource;

  IHabitRepository({
    required this.habitRemoteDataSource,
  });

  @override
  FutureVoid createHabit({required HabitEntity habit}) {
    return habitRemoteDataSource.createHabit(habit: habit);
  }

  /* @override
  Stream<List<EventEntity>> getMyEvents() {
    return eventRemoteDataSource.getMyEvents();
  }

  @override
  FutureVoid deleteEvents({required List<String> events}) {
    return eventRemoteDataSource.deleteEvents(events: events);
  }

  @override
  FutureVoid updateEvent({required EventEntity event}) {
    return eventRemoteDataSource.updateEvent(event: event);
  }
*/
}
