import 'package:flutter/material.dart';
import 'dart:async';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _duration = 60; // Default duration in seconds
  String selectedMinutes = '1'; // Default selected minute
  String selectedSeconds = '0'; // Default selected second
  bool isPaused = false; // Track if the timer is paused
  bool isStarted = false; // Track if the timer has started
  Timer? _timer; // Timer instance
  int _remainingTime = 60; // Remaining time in seconds
  double _progress = 1.0; // Progress value for the circle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer'),
        backgroundColor: Colors.grey[900], // Darker AppBar
      ),
      backgroundColor: Colors.black, // Dark background for the screen
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 1.0, end: _progress),
              duration: Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 20.0,
                        backgroundColor: Colors.grey[300],
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.pink.shade300),
                      ),
                    ),
                    Text(
                      _formatTime(_remainingTime),
                      style: const TextStyle(
                        fontSize: 33.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Dropdown for Minutes
                DropdownButton<String>(
                  value: selectedMinutes,
                  dropdownColor: Colors.grey[850], // Dark background for dropdown
                  items: List.generate(31, (index) => index.toString()) // 0 to 30 minutes
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        '$value min',
                        style: TextStyle(color: Colors.white), // White text color
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMinutes = newValue!;
                      _setDuration(); // Update duration based on selected values
                    });
                  },
                ),
                SizedBox(width: 10),
                // Dropdown for Seconds
                DropdownButton<String>(
                  value: selectedSeconds,
                  dropdownColor: Colors.grey[850], // Dark background for dropdown
                  items: List.generate(60, (index) => index.toString())
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        '$value sec',
                        style: TextStyle(color: Colors.white), // White text color
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSeconds = newValue!;
                      _setDuration(); // Update duration based on selected values
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_duration > 0) {
                      if (isPaused) {
                        _resumeTimer(); // Resume if paused
                      } else {
                        _startTimer(); // Start if not paused
                      }
                      setState(() {
                        isPaused = false;
                        isStarted = true;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please set a duration greater than 0.')),
                      );
                    }
                  },
                  child: Text(isPaused ? 'Resume' : 'Start'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (isStarted) {
                      _pauseTimer();
                      setState(() {
                        isPaused = true;
                      });
                    }
                  },
                  child: Text('Pause'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _resetTimer();
                    setState(() {
                      isPaused = false; // Reset the paused state
                      isStarted = false; // Reset the started state
                    });
                  },
                  child: Text('Reset'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _setDuration() {
    final int minutes = int.parse(selectedMinutes);
    final int seconds = int.parse(selectedSeconds);
    setState(() {
      _duration = (minutes * 60) + seconds;
      _remainingTime = _duration;
      _progress = 1.0; // Reset progress to full when changing duration
    });
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          _progress = _remainingTime / _duration; // Update the progress
        } else {
          _timer?.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Timer Complete!')),
          );
          setState(() {
            isStarted = false;
          });
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  void _resumeTimer() {
    _startTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingTime = _duration;
      _progress = 1.0; // Reset progress to full
    });
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
