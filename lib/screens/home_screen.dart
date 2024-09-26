import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For getting the current day

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String dayOfWeek = DateFormat('EEEE, MMM d').format(DateTime.now()); // Get the current day and format it
    User? user = _auth.currentUser; // Get the currently logged-in user

    return Scaffold(
      backgroundColor: Colors.black, // Dark background color
      appBar: AppBar(
        backgroundColor: Colors.grey[900], // Darker AppBar
        elevation: 0,
        title: Text(
          'Liftura',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text color for contrast
          ),
        ),
        centerTitle: true,
        actions: [
          if (user != null) // Show sign out button only if the user is signed in
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white,
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 16.0), // Reduce the top padding to bring the logo closer to the AppBar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo.png', // Ensure this path is correct
                  height: 200, // Adjusted logo height
                ),
              ),
              SizedBox(height: 20), // Adjusted the space between the logo and the date box
              if (user != null) // Show greeting only if the user is signed in
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Hello, ${user.displayName ?? user.email}!', // Display user's name or email
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // White text for contrast
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800], // Dark background for the date box
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    dayOfWeek,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // White text for contrast
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Features",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink, // Accent color remains pink
                ),
              ),
              SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureButton(
                    context,
                    "Timer",
                    Icons.timer,
                    Colors.pink.shade100,
                    onPressed: () {
                      Navigator.pushNamed(context, '/timer');
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    "Log Workout",
                    Icons.fitness_center,
                    Colors.pink.shade200,
                    onPressed: () {
                      Navigator.pushNamed(context, '/logWorkout');
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    "Workout Planner",
                    Icons.list,
                    Colors.pink.shade300,
                    onPressed: () {
                      Navigator.pushNamed(context, '/workoutPlanner');
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    "Analyze Workout",
                    Icons.camera_alt,
                    Colors.pink.shade400,
                    onPressed: () {
                      Navigator.pushNamed(context, '/workoutAnalyzer');
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  'assets/images/icon.png',
                  height: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context, String label, IconData icon, Color color,
      {required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        shadowColor: Colors.grey.withOpacity(0.5),
        elevation: 5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 25, // Smaller icon
            color: Colors.white,
          ),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20, // Larger text to fit most of the box
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
