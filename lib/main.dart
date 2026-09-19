import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_theme.dart';
import 'features/workout/data/workout_model.dart';
import 'features/workout/presentation/cubit/workout_cubit.dart';
import 'features/workout/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive Initialization
  await Hive.initFlutter();
  Hive.registerAdapter(WorkoutModelAdapter());
  final workoutBox = await Hive.openBox<WorkoutModel>('workouts_box');

  runApp(MyApp(workoutBox: workoutBox));
}

class MyApp extends StatelessWidget {
  final Box<WorkoutModel> workoutBox;

  const MyApp({super.key, required this.workoutBox});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutCubit(workoutBox)..loadWorkouts(),
      child: MaterialApp(
        title: 'FitProgress',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}