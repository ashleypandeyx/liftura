import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/timer_screen.dart';
import 'screens/log_workout_screen.dart';
import 'screens/workout_planner.dart';
import 'screens/workout_analyzer_screen.dart';
import 'firebase_options.dart';
import 'package:google_gemini/google_gemini.dart';
// import 'package:mediapipe_core/mediapipe_core.dart';
// import 'package:mediapipe_genai/mediapipe_genai.dart';
// import 'package:mediapipe/mediapipe.dart';

const apiKey = 'AIzaSyDHDe0nE7wQJPijjnrvPWnyMgEWIPV9DBI'; // Make sure you use the correct API key.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Gemini with your API key
  GoogleGemini(
    apiKey: apiKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liftura',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.pink,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/home',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/timer': (context) => TimerScreen(),
        '/logWorkout': (context) => LogWorkoutScreen(),
        '/workoutPlanner': (context) => WorkoutPlannerScreen(),
        '/workoutAnalyzer': (context) => WorkoutAnalyzerScreen(),
      },
    );
  }
}
