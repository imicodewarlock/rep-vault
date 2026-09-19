import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:rep_vault/features/workout/data/workout_model.dart';
import 'package:rep_vault/main.dart';

void main() {
  late Box<WorkoutModel> testBox;
  late Directory tempDir;

  setUpAll(() async {
    // Set up a temporary directory for Hive testing
    tempDir = await Directory.systemTemp.createTemp('hive_testing');
    Hive.init(tempDir.path);
    Hive.registerAdapter(WorkoutModelAdapter());
  });

  setUp(() async {
    // Open a fresh test box before each test
    testBox = await Hive.openBox<WorkoutModel>('test_workouts_box');
  });

  tearDown(() async {
    // Clean up test data after each test
    await testBox.clear();
    await testBox.close();
  });

  tearDownAll(() async {
    // Delete temporary directory after all tests finish
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets('RepVault renders home screen correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp(workoutBox: testBox));
    await tester.pumpAndSettle();

    // Verify app title is displayed in AppBar
    expect(find.text('FitProgress'), findsOneWidget);

    // Verify initial empty state message is shown
    expect(find.text('No workouts logged yet. Add one!'), findsOneWidget);

    // Verify FloatingActionButton exists for adding workouts
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}