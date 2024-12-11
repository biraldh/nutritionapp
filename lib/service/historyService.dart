import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> logDetection({
    required String food,
    required String weight,
    required String calories,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        return "User not logged in";
      }
      //create new record of food detection
      await _firestore.collection('users').doc(user.uid).collection('history').add({
        'food': food,
        'weight': weight,
        'calories': calories,
        'timestamp': FieldValue.serverTimestamp(),
      });

      final today = DateTime.now();
      final todayString = DateTime(today.year, today.month, today.day).toIso8601String();
      // Check if the calorie goal exists for today
      final goalSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('goals')
          .where('day', isEqualTo: todayString)  // Match by date
          .get();
      if (goalSnapshot.docs.isNotEmpty) {
        final goalDoc = goalSnapshot.docs.first;
        final calorieValue = (calories != null && calories.isNotEmpty)
            ? double.tryParse(calories)?.toInt() ?? 0
            : 0;

        final currentConsumed = (goalDoc['consumed'] != null)
            ? int.tryParse(goalDoc['consumed'].toString()) ?? 0
            : 0;
        try{
          await _firestore.collection('users').doc(user.uid).collection('goals').doc(goalDoc.id).update({
            'consumed': currentConsumed + calorieValue,
          });
        }
        on FirebaseException catch (e){
          print(e.message);
        }

      }
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }
  Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .orderBy('timestamp', descending: true)
          .get();

      // Convert documents to a list of maps
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? "An error occurred while fetching history");
    }
  }
  Future<List<Map<String, dynamic>>> gethistorybydate(String period) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      // Get the current date
      final DateTime now = DateTime.now();
      DateTime startOfPeriod;

      // Calculate the start of the period based on the selected period
      if (period == 'today') {
        startOfPeriod = DateTime(now.year, now.month, now.day);  // Start of today
      } else if (period == 'week') {
        startOfPeriod = now.subtract(const Duration(days: 7));  // Start of last 7 days
      } else if (period == 'month') {
        startOfPeriod = now.subtract(const Duration(days: 30));  // Start of last 30 days
      } else {
        throw Exception("Invalid period selected");
      }

      // Fetch history for the selected time period
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .where('timestamp', isGreaterThanOrEqualTo: startOfPeriod)
          .where('timestamp', isLessThan: now)
          .orderBy('timestamp', descending: true)
          .get();

      // Convert documents to a list of maps
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? "An error occurred while fetching history for the selected period");
    }
  }
  Future<void> saveCalorieGoal(int calories) async {
    final today = DateTime.now();
    final todayString = DateTime(today.year, today.month, today.day).toIso8601String();
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    try {
      // get existing record with today's date
      QuerySnapshot goalSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('goals')
          .where('day', isEqualTo: todayString)
          .get();

      if (goalSnapshot.docs.isNotEmpty) {
        // Update the existing record
        final goalDoc = goalSnapshot.docs.first;
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('goals')
            .doc(goalDoc.id)
            .update({
          'calorie_goal': calories,
        });
      } else {
        // Create a new record if none exists
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('goals')
            .add({
          'user_email': user.email,
          'calorie_goal': calories,
          'date': DateTime.now().toIso8601String(),
          'consumed': 0,
          'day': todayString,
        });
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  Future fetchCalorieGoal() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    try {
      final DateTime now = DateTime.now();
      final String today = DateTime(now.year, now.month, now.day).toIso8601String();

      // Fetch the latest calorie goal from the Firestore collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('goals')
          .where('day', isEqualTo: today)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Extract the calorie goal from the document
        var data = snapshot.docs.first.data() as Map<String, dynamic>;
        int calorieGoal = data['calorie_goal'] ?? 0;
        int consumed = data['consumed'] ?? 0;
        return {'calorie_goal': calorieGoal, 'consumed': consumed};
        // Return calorie goal if available, else return 0
      } else {
        return 0; // If no goal return 0
      }
    } catch (e) {
      throw Exception("Error fetching calorie goal: $e");
    }
  }
}
