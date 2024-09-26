import 'package:flutter/material.dart';

class WorkoutPlannerScreen extends StatefulWidget {
  @override
  _WorkoutPlannerScreenState createState() => _WorkoutPlannerScreenState();
}

class _WorkoutPlannerScreenState extends State<WorkoutPlannerScreen> {
  List<String> selectedMuscles = [];
  String selectedGoal = 'Strength';
  int workoutTime = 30; // Default to 30 minutes
  List<String> generatedWorkout = [];

  // Data structure for exercises categorized by muscle groups
  Map<String, List<String>> exercises = {
    'Chest': [
      'Bench Press',
      'Push-Up',
      'Chest Fly',
      'Incline Bench Press',
      'Decline Bench Press',
    ],
    'Back': [
      'Pull-Up',
      'Deadlift',
      'Row',
      'Lat Pulldown',
      'Bent Over Row',
    ],
    'Quads': [
      'Squat',
      'Leg Press',
      'Goblet Squat',
      'Bulgarian Split Squat',
      'Leg Extension',
    ],
    'Biceps': [
      'Bicep Curl',
      'Hammer Curl',
      'Concentration Curl',
      'Cable Curl',
      'Zottman Curl',
    ],
    'Triceps': [
      'Tricep Extension',
      'Close-Grip Bench Press',
      'Tricep Kickback',
      'Dips',
      'Overhead Tricep Extension',
    ],
    'Shoulders': [
      'Shoulder Press',
      'Lateral Raise',
      'Arnold Press',
      'Front Raise',
      'Reverse Fly',
    ],
    'Core': [
      'Plank',
      'Crunch',
      'Leg Raise',
      'Russian Twist',
      'Bicycle Crunch',
    ],
    'Glutes': [
      'Hip Thrust',
      'Glute Bridge',
      'Cable Kickback',
      'Bulgarian Split Squat',
      'Sumo Squat',
    ],
    'Hamstrings': [
      'Romanian Deadlift',
      'Leg Curl',
      'Glute-Ham Raise',
      'Good Morning',
      'Kettlebell Swing',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Planner'),
        backgroundColor: Colors.pink,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Muscles to Train',
              style: TextStyle(
                color: Colors.pink,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: exercises.keys.map((muscle) {
                return ChoiceChip(
                  label: Text(muscle, style: TextStyle(color: Colors.white)),
                  selected: selectedMuscles.contains(muscle),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedMuscles.add(muscle);
                      } else {
                        selectedMuscles.remove(muscle);
                      }
                    });
                  },
                  selectedColor: Colors.pink.shade300,
                  backgroundColor: Colors.grey.shade800,
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Text(
              'Set Workout Time (minutes)',
              style: TextStyle(
                color: Colors.pink,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Slider(
              value: workoutTime.toDouble(),
              min: 10,
              max: 120,
              divisions: 22,
              label: '$workoutTime minutes',
              activeColor: Colors.pink.shade300,
              inactiveColor: Colors.grey.shade800,
              onChanged: (double value) {
                setState(() {
                  workoutTime = value.toInt();
                });
              },
            ),
            SizedBox(height: 30),
            Text(
              'Select Goal',
              style: TextStyle(
                color: Colors.pink,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedGoal,
              dropdownColor: Colors.grey.shade900,
              items: ['Strength', 'Endurance', 'Hypertrophy'].map((String goal) {
                return DropdownMenuItem<String>(
                  value: goal,
                  child: Text(
                    goal,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGoal = newValue!;
                });
              },
              isExpanded: true,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _generateWorkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text('Generate Workout', style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: generatedWorkout.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      tileColor: Colors.grey.shade800,
                      title: Text(
                        generatedWorkout[index],
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.refresh, color: Colors.pink),
                        onPressed: () {
                          _replaceExercise(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateWorkout() {
    List<String> workout = [];
    int sets = selectedGoal == 'Strength'
        ? 4
        : selectedGoal == 'Endurance'
            ? 3
            : 4; // 4 sets for Hypertrophy
    int reps = selectedGoal == 'Strength'
        ? 5
        : selectedGoal == 'Endurance'
            ? 15
            : 8; // 8 reps for Hypertrophy

    // Calculate the number of exercises based on the workout time
    int exercisesCount = (workoutTime ~/ 15).clamp(1, 6); // 1 exercise per 15 minutes, max 6

    for (String muscle in selectedMuscles) {
      List<String> availableExercises = exercises[muscle]!;
      availableExercises.shuffle();
      int count = 0;
      for (int i = 0; i < availableExercises.length && count < exercisesCount; i++) {
        String exercise = '${availableExercises[i]}: $sets sets x $reps reps';
        if (!workout.contains(exercise)) {
          workout.add(exercise);
          count++;
        }
      }
    }

    setState(() {
      generatedWorkout = workout.take(exercisesCount).toList(); // Ensure max 6 exercises
    });
  }

  void _replaceExercise(int index) {
    int sets = selectedGoal == 'Strength'
        ? 4
        : selectedGoal == 'Endurance'
            ? 3
            : 4; // 4 sets for Hypertrophy
    int reps = selectedGoal == 'Strength'
        ? 5
        : selectedGoal == 'Endurance'
            ? 15
            : 8; // 8 reps for Hypertrophy

    List<String> allSelectedExercises = selectedMuscles
        .expand((muscle) => exercises[muscle]!)
        .toList();
    allSelectedExercises.shuffle();

    String newExercise;
    do {
      newExercise = '${allSelectedExercises.removeAt(0)}: $sets sets x $reps reps';
    } while (generatedWorkout.contains(newExercise) && allSelectedExercises.isNotEmpty);

    if (newExercise.isNotEmpty) {
      setState(() {
        generatedWorkout[index] = newExercise;
      });
    }
  }
}
