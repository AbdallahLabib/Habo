import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import 'package:habo/core/helpers/constants.dart';
import 'package:habo/core/helpers/helpers.dart';
import 'package:habo/features/habits/data/model/habit_data.dart';
import 'package:habo/features/habits/presentation/screen/habit.dart';

class HabitLocalDatabase {
  late Database db;
  
  HabitLocalDatabase({
    required this.db,
  });
  
  Future<void> deleteEvent(int id, DateTime dateTime) async {
    try {
      await db.delete("events",
          where: "id = ? AND dateTime = ?",
          whereArgs: [id, dateTime.toString()]);
    } catch (_) {
      if (kDebugMode) {
        print(_);
      }
    }
  }

  Future<void> deleteHabit(int id) async {
    try {
      await db.delete("habits", where: "id = ?", whereArgs: [id]);
      await db.delete("events", where: "id = ?", whereArgs: [id]);
    } catch (_) {
      if (kDebugMode) {
        print(_);
      }
    }
  }

  Future<void> emptyTables() async {
    try {
      await db.delete("habits");
      await db.delete("events");
    } catch (_) {
      if (kDebugMode) {
        print(_);
      }
    }
  }

  Future<void> editHabit(Habit habit) async {
    try {
      await db.update(
        "habits",
        habit.toMap(),
        where: "id = ?",
        whereArgs: [habit.habitData.id],
      );
    } catch (_) {
      if (kDebugMode) {
        print(_);
      }
    }
  }

  Future<List<Habit>> getAllHabits() async {
    final List<Map<String, dynamic>> habits =
        await db.query("habits", orderBy: "position");
    List<Habit> result = [];

    await Future.forEach(
      habits,
      (hab) async {
        int id = hab["id"];
        SplayTreeMap<DateTime, List> eventsMap = SplayTreeMap<DateTime, List>();
        await db.query("events", where: "id = $id").then(
          (events) {
            for (var event in events) {
              eventsMap[DateTime.parse(event["dateTime"] as String)] = [
                DayType.values[event["dayType"] as int],
                event["comment"]
              ];
            }
            result.add(
              Habit(
                habitData: HabitData(
                  id: id,
                  position: hab["position"],
                  title: hab["title"],
                  twoDayRule: hab["twoDayRule"] == 0 ? false : true,
                  cue: hab["cue"] ?? "",
                  routine: hab["routine"] ?? "",
                  reward: hab["reward"] ?? "",
                  showReward: hab["showReward"] == 0 ? false : true,
                  advanced: hab["advanced"] == 0 ? false : true,
                  notification: hab["notification"] == 0 ? false : true,
                  notTime: parseTimeOfDay(hab["notTime"]),
                  events: eventsMap,
                  sanction: hab["sanction"] ?? "",
                  showSanction: (hab["showSanction"] ?? 0) == 0 ? false : true,
                  accountant: hab["accountant"] ?? "",
                ),
              ),
            );
          },
        );
      },
    );
    return result;
  }

  Future<void> insertEvent(int id, DateTime date, List event) async {
    try {
      db.insert(
          "events",
          {
            "id": id,
            "dateTime": date.toString(),
            "dayType": event[0].index,
            "comment": event[1],
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (_) {
      if (kDebugMode) {
        print(_);
      }
    }
  }

  Future<int> insertHabit(Habit habit) async {
    try {
      var id = await db.insert("habits", habit.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return id;
    } catch (_) {
      if (kDebugMode) {
        print(_);
      }
    }
    return 0;
  }

  Future<void> updateOrder(List<Habit> habits) async {
    try {
      for (var habit in habits) {
        db.update(
          "habits",
          habit.toMap(),
          where: "id = ?",
          whereArgs: [habit.habitData.id],
        );
      }
    } catch (_) {
      if (kDebugMode) {
        print(_);
      }
    }
  }

  Future<void> useBackup(List<Habit> habits) async {
    try {
      await emptyTables();
      for (var element in habits) {
        insertHabit(element);
        element.habitData.events.forEach(
          (key, value) {
            insertEvent(element.habitData.id!, key, value);
          },
        );
      }
    } catch (_) {
      if (kDebugMode) {
        print(_);
      }
    }
  }
}
