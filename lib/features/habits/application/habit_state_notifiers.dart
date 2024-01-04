import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habo/core/helpers/constants.dart';
import 'package:habo/features/habits/domain/entities/habit_entity.dart';
import 'package:habo/features/habits/domain/usecase/create_habit_use_case.dart';

final eventStateNotifiers =
    StateNotifierProvider<EventStateNotifiers, bool>((ref) {
  return EventStateNotifiers(
    createHabitUseCase: ref.read(createHabitUseCaseProvider),
    ref: ref,
  );
});

class EventStateNotifiers extends StateNotifier<bool> {
  final CreateHabitUseCase createHabitUseCase;
  final Ref ref;
  
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  EventStateNotifiers({
    required this.createHabitUseCase,
    required this.ref,
  }) : super(false);

  void createEvent({required HabitEntity habitEntity}) async {
    final event = await createHabitUseCase(
      CreateHabiParams(habit: habitEntity),
    );

    _scaffoldKey.currentState!.showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 3),
        content: Text("Creating Habit"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: HaboColors.primary,
      ),
    );

    event.fold((l) {
      _scaffoldKey.currentState!.showSnackBar(
       SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(l.message!),
        behavior: SnackBarBehavior.floating,
        backgroundColor: HaboColors.red,
      ),
    );
    }, (r) {
      _scaffoldKey.currentState!.showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 3),
        content: Text("Created Habit Successfully"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: HaboColors.primary,
      ),
    );
      // Future.delayed(const Duration(seconds: 1)).then((value) {
      //   navigationService.pushNamedAndRemoveUntil(MAIN_SCREEN_ROUTE,
      //       args: accountType);
      // });
    });
  }

/*   Stream<List<HabitEntity>> getMyHabits() {
    return getMyEventsUseCase();
  }

  Future<void> deleteHabits({required List<String> events}) async {
    final result = await deleteEventsUseCase(DeleteEventParams(events: events));

    result.fold(
        (l) => toastService.show(type: ToastType.ERROR, message: l.message),
        (r) => toastService.show(
            type: ToastType.SUCCESS,
            message: events.length > 1
                ? LocaleKeys.events_deleted_successfully.tr()
                : LocaleKeys.event_deleted_successfully.tr()));
  }

  Future<void> updateHabit({required HabitEntity habit}) async {
    final result = await updateEventUseCase(UpdateEventParams(event: habit));

    result.fold((l) => toastService.show(type: ToastType.ERROR, message: '$l'),
        (r) {
      toastService.show(
          type: ToastType.SUCCESS,
          message: LocaleKeys.event_updated_successfully.tr());
      Future.delayed(const Duration(seconds: 1)).then((value) {
        navigationService.pushNamed(MAIN_SCREEN_ROUTE, args: accountType);
      });
    });
  }
 */
}
