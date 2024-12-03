import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuttritionapp/service/loginService.dart';
import 'package:nuttritionapp/widgets/login_widgets.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final LoginService ls = LoginService();
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    setState(() {
      _isLoading = true;
    });

    final result = await ls.register(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (result is User) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Register Successful")),
      );
      Navigator.popAndPushNamed(context, '/');
    } else if (result is String) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
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
            Text("Username"),
            Container(
              width: screenWidth/1.5,
              child: inputBox(controller: _usernameController, obsecure: false, hintText: "Enter Unsername")
            ),
            Text("Email"),
            Container(
                width: screenWidth/1.5,
                child: inputBox(controller: _emailController, obsecure: false, hintText: "Enter Email")
            ),
            Text("Password"),
            Container(
                width: screenWidth/1.5,
                child: inputBox(controller: _passwordController, obsecure: true, hintText: "Enter Password")
            ),
            SizedBox(height: 20,),

            GestureDetector(
              onTap: _isLoading ? null : _handleRegister,
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
                      : const Text("Register", style: TextStyle(fontSize: 25)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
