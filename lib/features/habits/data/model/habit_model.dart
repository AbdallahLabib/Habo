import 'package:habo/features/habits/domain/entities/habit_entity.dart';

class HabitModel extends HabitEntity {
  const HabitModel({required super.habitName, required super.userId});

  Map<String, dynamic> toMap() {
    return {
      'habitName': habitName,
      'userId': userId,
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      habitName: map['habitName'] ?? '',
      userId: map['userId'] ?? '',
    );
  }
}
