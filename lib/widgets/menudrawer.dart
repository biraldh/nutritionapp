import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customDrawer (context){
  double screenWidth = MediaQuery.of(context).size.width;
  return Drawer(
    width: screenWidth/2,
    backgroundColor: Colors.black,
    child: ListView(
      children: [
        ListTile(
          leading: Icon(Icons.no_food, color: Colors.white,),
          title: const Text('Goals', style: TextStyle(
              color: Colors.white
          ),),
          onTap: () {
            Navigator.pushNamed(context, '/goal');
          },
        ),
        ListTile(
          leading: Icon(Icons.dashboard, color: Colors.white,),
          title: const Text('Dashboard', style: TextStyle(
              color: Colors.white
          ),),
          onTap: () {
            Navigator.pushNamed(context, '/dashboard');
          },
        ),
        ListTile(
          leading: Icon(CupertinoIcons.photo_camera, color: Colors.white,),
          title: const Text('Nutrition', style: TextStyle(
          color: Colors.white
          ),),
          onTap: () {
            Navigator.pushNamed(context, '/');
          },
        ),
      ],
    ),
  );
}