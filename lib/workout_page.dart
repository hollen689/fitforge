import 'package:flutter/material.dart';

class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  List<Workout> workouts = [];

  void _navigateToWorkoutSelection() async {
    final String? selectedWorkout = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WorkoutSelectionPage()),
    );

    if (selectedWorkout != null) {
      setState(() {
        workouts.add(Workout(name: selectedWorkout));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: workouts.isEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start new workout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  FloatingActionButton(
                    onPressed: _navigateToWorkoutSelection,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.add, size: 36, color: Colors.white),
                  ),
                ],
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      itemCount: workouts.length,
                      itemBuilder: (context, index) {
                        return WorkoutCard(
                          workout: workouts[index],
                          onAddSet: () {
                            setState(() {
                              workouts[index].addSet();
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: FloatingActionButton(
                      onPressed: _navigateToWorkoutSelection,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.add, size: 36, color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class Workout {
  final String name;
  List<WorkoutSet> sets;

  Workout({required this.name}) : sets = [WorkoutSet()];

  void addSet() {
    sets.add(WorkoutSet());
  }
}

class WorkoutSet {
  String reps = "";
  String weight = "";
}

class WorkoutCard extends StatelessWidget {
  final Workout workout;
  final VoidCallback onAddSet;

  const WorkoutCard({required this.workout, required this.onAddSet, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workout.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            Column(
              children: List.generate(workout.sets.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Text(
                        "Set ${index + 1}",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Reps',
                            hintStyle: TextStyle(color: Colors.white54),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white38),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Weight',
                            hintStyle: TextStyle(color: Colors.white54),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white38),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),

            SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: onAddSet,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text("Add Set", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutSelectionPage extends StatelessWidget {
  final List<String> workouts = [
    "Push-ups",
    "Squats",
    "Deadlifts",
    "Bench Press",
    "Pull-ups",
    "Lunges",
    "Plank",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Workout'),
        backgroundColor: Colors.grey[850],
        elevation: 0,
        titleTextStyle:
            TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[900],
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(workouts[index], style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context, workouts[index]);
            },
          );
        },
      ),
    );
  }
}