import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget inputBox({required TextEditingController controller, String hintText = "", required bool obsecure}) {
  return TextField(
    obscureText: obsecure,
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.blue, width: 2.0), // Custom border when focused
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.grey, width: 1.0), // Default border
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Padding inside the TextField
    ),
  );
}

Widget Customtopbtn(context, VoidCallback onPressed, IconData icon){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[900], // Background color
        shape: BoxShape.circle, // Make it circular
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white,),),
    ),
  );
}