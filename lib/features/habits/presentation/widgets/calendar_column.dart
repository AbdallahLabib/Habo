import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habo/features/habits/data/model/habit_model.dart';
import 'package:habo/features/habits/domain/entities/habit_entity.dart';
import 'package:habo/features/habits/presentation/widgets/calendar_header.dart';
import 'package:habo/features/habits/presentation/widgets/empty_list_image.dart';
import 'package:habo/features/habits/presentation/widgets/habit.dart';
import 'package:habo/features/habits/application/habits_manager.dart';
import 'package:provider/provider.dart';

class CalendarColumn extends StatelessWidget {
  const CalendarColumn({super.key});

  @override
  Widget build(BuildContext context) {
    List<Habit> calendars = Provider.of<HabitsManager>(context).getAllHabits;

    Stream<List<HabitEntity>> getMyHabits() {
      final firestore = FirebaseFirestore.instance;
      try {
        return firestore
            .collection('habit')
            .where('userId', isEqualTo: 'HqfRpEga6B1eKW6tLcnN')
            .snapshots()
            .asyncMap((event) =>
                event.docs.map((e) => HabitModel.fromMap(e.data())).toList());
      } on FirebaseException catch (e) {
        return Stream.error(e.message.toString());
      }
    }

    List<HabitEntity> habitsListFirestore = [];

    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
          child: CalendarHeader(),
        ),
        StreamBuilder<List<HabitEntity>>(
            stream: getMyHabits(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                habitsListFirestore = snapshot.data!;
              }
              return Expanded(
                child: (calendars.isNotEmpty)
                    ? ReorderableListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 120),
                        children: calendars
                            .map(
                              (habit) => Container(
                                key: ObjectKey(habit),
                                child: habit,
                              ),
                            )
                            .toList(),
                        onReorder: (oldIndex, newIndex) {
                          Provider.of<HabitsManager>(context, listen: false)
                              .reorderList(oldIndex, newIndex);
                        },
                      )
                    : const EmptyListImage(),
              );
            }),
      ],
    );
  }
}
