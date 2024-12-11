import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuttritionapp/service/loginService.dart';
import 'package:nuttritionapp/widgets/login_widgets.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginService ls = LoginService();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    String? errorMessage = await ls.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful")),

      );
      Navigator.popAndPushNamed(context, '/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("NutriLens"), centerTitle: true, ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Email", style: TextStyle(fontSize: 20),),
            Container(
              width: screenWidth/2,
              child: inputBox(controller: _emailController, hintText : "Enter Email", obsecure: false),
            ),
            SizedBox(height: 20,),
            Text("Password", style: TextStyle(fontSize: 20),),
            Container(
              width: screenWidth/2,
              child: inputBox(controller: _passwordController, hintText : "Enter Password", obsecure: true),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: _isLoading ? null : _handleLogin,
              child: Container(
                width: screenWidth / 1.5,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login", style: TextStyle(fontSize: 25)),
                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/register");
              },
              child: Container(
                width: screenWidth / 1.5,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text("Register", style: TextStyle(fontSize: 25)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
