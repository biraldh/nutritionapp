import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuttritionapp/service/historyService.dart';

class Goal extends StatefulWidget {
  const Goal({super.key});

  @override
  State<Goal> createState() => _GoalState();
}

class _GoalState extends State<Goal> {
  final TextEditingController _calorieController = TextEditingController(); // Controller for the input
  final HistoryService _historyService = HistoryService();

  int _calorieGoal = 0;
  int _caloriesConsumed = 0;
  int _remainingCalories = 0;

  @override
  void initState() {
    super.initState();
    _fetchCalorieGoal();
  }

  Future<void> _fetchCalorieGoal() async {
    try {
      // Fetch the calorie goal and consumed data
      Map<String, int> goalData = await _historyService.fetchCalorieGoal();
      setState(() {
        _calorieGoal = goalData['calorie_goal'] ?? 0; // Update the calorie goal
        _caloriesConsumed = goalData['consumed'] ?? 0; // Update the consumed value
      });
    } catch (e) {
      // Handle error (e.g., display a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching calorie goal: $e")),
      );
    }
  }

  void _showCalorieDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: const Text("Edit Calorie Goal", style: TextStyle(color: Colors.white),),
          content: TextField(
            style: TextStyle(color: Colors.white),
            controller: _calorieController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintStyle: TextStyle(
                color: Colors.white
              ),
              hintText: "Enter your calorie goal",
            ),
          ),
          actions: [
            InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Cancel', style: TextStyle(color: Colors.white),),
                ),
              )
            ),

            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                if (_calorieController.text.isNotEmpty) {
                  final int? calories = int.tryParse(_calorieController.text);
                  if (calories != null) {
                    await _historyService.saveCalorieGoal(calories);
                    Navigator.of(context).pop();
                    _calorieController.clear();
                    await _fetchCalorieGoal();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a valid number")),
                    );
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Save', style: TextStyle(color: Colors.white),),
                ),
              )
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    _remainingCalories = _calorieGoal - _caloriesConsumed;
    double progress = _calorieGoal > 0 ? (_caloriesConsumed / _calorieGoal) : 0.0;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Goal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 40),
          Text(
            "$_calorieGoal cal",
            style: TextStyle(fontSize: 60, color: Colors.white),
          ),
          _remainingCalories < 0
              ? Text(
            "You have exceeded your calorie goal!",
            style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
          )
              : Text(
            "$_remainingCalories calories left for today",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 40,
              backgroundColor: Colors.grey,
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Center(
            child: Text(
              "$_caloriesConsumed calories consumed today",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: _showCalorieDialog,
              child: Container(
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(10)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Set Calorie Goal",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
              child: Container(
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                    color: Colors.grey[800], borderRadius: BorderRadius.circular(10)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Detect calories",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        CupertinoIcons.camera,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
