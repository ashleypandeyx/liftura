import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogWorkoutScreen extends StatefulWidget {
  @override
  _LogWorkoutScreenState createState() => _LogWorkoutScreenState();
}

class _LogWorkoutScreenState extends State<LogWorkoutScreen> {
  final TextEditingController _workoutController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> _addWorkout() async {
    if (_workoutController.text.isNotEmpty &&
        _weightController.text.isNotEmpty &&
        _repsController.text.isNotEmpty) {
      await _firestore
          .collection('workouts')
          .doc(_auth.currentUser!.uid)
          .collection('user_workouts')
          .add({
        'workout': _workoutController.text,
        'weight': _weightController.text,
        'reps': _repsController.text,
      });
    }
    _workoutController.clear();
    _weightController.clear();
    _repsController.clear();
  }


  Future<void> _deleteWorkout(String id) async {
    await _firestore
        .collection('workouts')
        .doc(_auth.currentUser!.uid)
        .collection('user_workouts')
        .doc(id)
        .delete();
  }


  Future<void> _editWorkout(String id) async {
    if (_workoutController.text.isNotEmpty &&
        _weightController.text.isNotEmpty &&
        _repsController.text.isNotEmpty) {
      await _firestore
          .collection('workouts')
          .doc(_auth.currentUser!.uid)
          .collection('user_workouts')
          .doc(id)
          .update({
        'workout': _workoutController.text,
        'weight': _weightController.text,
        'reps': _repsController.text,
      });
      _workoutController.clear();
      _weightController.clear();
      _repsController.clear();
    }
  }


  void _showEditDialog(Map<String, dynamic> workoutData, String id) {
    _workoutController.text = workoutData['workout'];
    _weightController.text = workoutData['weight'];
    _repsController.text = workoutData['reps'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Workout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _workoutController,
                decoration: const InputDecoration(labelText: 'Workout Name'),
              ),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Weight (lbs)'),
              ),
              TextField(
                controller: _repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Reps'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editWorkout(id);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Workout'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _workoutController,
              decoration: const InputDecoration(labelText: 'Workout Name'),
            ),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Weight (lbs)'),
            ),
            TextField(
              controller: _repsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Reps'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addWorkout,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              child: const Text('Add Workout'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('workouts')
                    .doc(_auth.currentUser!.uid)
                    .collection('user_workouts')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final workouts = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workoutData =
                          workouts[index].data() as Map<String, dynamic>;
                      final workoutId = workouts[index].id;

                      return Card(
                        color: Colors
                            .primaries[index % Colors.primaries.length], // Colorful boxes
                        child: ListTile(
                          title: Text(workoutData['workout'],
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              '${workoutData['weight']} lbs x ${workoutData['reps']} reps'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _showEditDialog(workoutData, workoutId),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteWorkout(workoutId),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
