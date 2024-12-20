import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nuttritionapp/pages/dashboard.dart';
import 'package:nuttritionapp/pages/goal.dart';
import 'package:nuttritionapp/pages/register.dart';

import 'pages/login.dart';
import 'pages/nutrition.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/': (context) => FoodDetectionPage(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/goal': (context) => Goal(),
        '/dashboard': (context) => Dashboard()
      },
    );
  }
}

