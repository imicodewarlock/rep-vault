import '../../data/workout_model.dart';

abstract class WorkoutState {}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoaded extends WorkoutState {
  final List<WorkoutModel> workouts;
  final int restTimer;
  final bool isTimerRunning;

  WorkoutLoaded({
    required this.workouts,
    this.restTimer = 0,
    this.isTimerRunning = false,
  });
}