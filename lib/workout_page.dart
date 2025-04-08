import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final TextEditingController _controller = TextEditingController();
  List<Workout> workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  void _addWorkout(String name) {
    if (name.trim().isEmpty) return;

    setState(() {
      workouts.add(Workout(name: name));
      _controller.clear();
    });

    _saveWorkouts();
  }

  void _removeWorkout(int index) {
    setState(() {
      workouts.removeAt(index);
    });
    _saveWorkouts();
  }

  void _addSet(int index) {
    setState(() {
      workouts[index].addSet();
    });
    _saveWorkouts();
  }

  void _saveWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(workouts.map((w) => w.toJson()).toList());
    await prefs.setString('workouts', encoded);
  }

  void _loadWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString('workouts');
    if (encoded != null) {
      final decoded = json.decode(encoded) as List;
      setState(() {
        workouts = decoded.map((json) => Workout.fromJson(json)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Workouts',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter workout name',
                      hintStyle: TextStyle(color: Colors.white54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addWorkout(_controller.text),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Add', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  final workout = workouts[index];
                  return WorkoutCard(
                    workout: workout,
                    onAddSet: () => _addSet(index),
                    onRemove: () => _removeWorkout(index),
                    onSetChanged: _saveWorkouts,
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

class Workout {
  final String name;
  final DateTime date;
  List<WorkoutSet> sets;
  bool isEditing;

  Workout({required this.name, DateTime? date, this.isEditing = false})
      : this.date = date ?? DateTime.now(),
        sets = [WorkoutSet()];

  void addSet() {
    sets.add(WorkoutSet());
  }

  Workout.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        date = DateTime.parse(json['date']),
        isEditing = json['isEditing'] is bool ? json['isEditing'] : false,
        sets = (json['sets'] as List)
            .map((setJson) => WorkoutSet.fromJson(setJson))
            .toList();

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date.toIso8601String(),
        'isEditing': isEditing,
        'sets': sets.map((s) => s.toJson()).toList(),
      };
}

class WorkoutSet {
  String reps;
  String weight;

  WorkoutSet({this.reps = '', this.weight = ''});

  WorkoutSet.fromJson(Map<String, dynamic> json)
      : reps = json['reps'],
        weight = json['weight'];

  Map<String, dynamic> toJson() => {
        'reps': reps,
        'weight': weight,
      };
}

class WorkoutCard extends StatefulWidget {
  final Workout workout;
  final VoidCallback onAddSet;
  final VoidCallback onSetChanged;
  final VoidCallback onRemove;

  const WorkoutCard({
    required this.workout,
    required this.onAddSet,
    required this.onSetChanged,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  @override
  Widget build(BuildContext context) {
    final workout = widget.workout;

    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    workout.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: List.generate(workout.sets.length, (index) {
                final set = workout.sets[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Text("Set ${index + 1}", style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 16),
                      if (workout.isEditing)
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: set.reps),
                            decoration: _inputStyle('Reps'),
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              set.reps = value;
                              widget.onSetChanged();
                            },
                          ),
                        )
                      else
                        Expanded(
                          child: Text("Reps: ${set.reps}", style: const TextStyle(color: Colors.white)),
                        ),
                      const SizedBox(width: 16),
                      if (workout.isEditing)
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: set.weight),
                            decoration: _inputStyle('Weight'),
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              set.weight = value;
                              widget.onSetChanged();
                            },
                          ),
                        )
                      else
                        Expanded(
                          child: Text("Weight: ${set.weight}", style: const TextStyle(color: Colors.white)),
                        ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (workout.isEditing)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        workout.isEditing = false;
                      });
                      widget.onSetChanged();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Save", style: TextStyle(color: Colors.white)),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        workout.isEditing = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text("Edit", style: TextStyle(color: Colors.white)),
                  ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: widget.onAddSet,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text("Add Set", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white38),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }
}