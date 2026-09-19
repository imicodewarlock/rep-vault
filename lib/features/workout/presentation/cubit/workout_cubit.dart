import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../data/workout_model.dart';
import 'workout_state.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  final Box<WorkoutModel> workoutBox;
  Timer? _timer;

  WorkoutCubit(this.workoutBox) : super(WorkoutInitial());

  void loadWorkouts() {
    final workouts = workoutBox.values.toList();
    workouts.sort((a, b) => b.date.compareTo(a.date));
    emit(WorkoutLoaded(workouts: workouts));
  }

  Future<void> addWorkout(WorkoutModel workout) async {
    await workoutBox.add(workout);
    loadWorkouts();
  }

  Future<void> deleteWorkout(int index) async {
    await workoutBox.deleteAt(index);
    loadWorkouts();
  }

  void startRestTimer(int seconds) {
    _timer?.cancel();
    int remaining = seconds;

    if (state is WorkoutLoaded) {
      final currentWorkouts = (state as WorkoutLoaded).workouts;
      emit(WorkoutLoaded(workouts: currentWorkouts, restTimer: remaining, isTimerRunning: true));

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remaining > 0) {
          remaining--;
          emit(WorkoutLoaded(workouts: currentWorkouts, restTimer: remaining, isTimerRunning: true));
        } else {
          timer.cancel();
          emit(WorkoutLoaded(workouts: currentWorkouts, restTimer: 0, isTimerRunning: false));
        }
      });
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}