import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habo/core/helpers/app_typedefs.dart';
import 'package:habo/core/use_case/use_case.dart';
import 'package:habo/features/habits/domain/entities/habit_entity.dart';
import 'package:habo/features/habits/domain/repository/habit_repository.dart';


final createHabitUseCaseProvider = Provider<CreateHabitUseCase>((ref) {
  return CreateHabitUseCase(
    habitRepository: ref.read(habitRepositoryProvider),
  );
});

class CreateHabitUseCase implements FutureUseCase<void, CreateHabiParams> {
  final HabitRepository habitRepository;

  const CreateHabitUseCase({
    required this.habitRepository,
  });
  @override
  FutureResult<void> call(CreateHabiParams params) {
    return habitRepository.createHabit(habit: params.habit);
  }
}

class CreateHabiParams extends Equatable {
  final HabitEntity habit;

  const CreateHabiParams({
    required this.habit,
  });

  @override
  List<Object?> get props => [habit];
}
