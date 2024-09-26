import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WorkoutAnalyzerScreen(),
    );
  }
}

class WorkoutAnalyzerScreen extends StatefulWidget {
  const WorkoutAnalyzerScreen({Key? key}) : super(key: key);

  @override
  _WorkoutAnalyzerScreenState createState() => _WorkoutAnalyzerScreenState();
}

class _WorkoutAnalyzerScreenState extends State<WorkoutAnalyzerScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}
