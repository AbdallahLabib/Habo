import 'package:equatable/equatable.dart';

class HabitEntity extends Equatable {
  final String habitName;
  final String userId;

  const HabitEntity({
    required this.habitName,
    required this.userId,
  });

  @override
  List<Object> get props => [habitName, userId];
}
