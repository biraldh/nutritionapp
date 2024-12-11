import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuttritionapp/service/loginService.dart';

Widget customDrawer (context){
  LoginService _loginServie = LoginService();
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
          title: const Text('History', style: TextStyle(
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
        ListTile(
          leading: Icon(Icons.logout_rounded,color: Colors.white,),
          title: const Text('LogOut', style: TextStyle(
              color: Colors.white
          ),),
          onTap: (){
            _loginServie.signOut();
            Navigator.pushNamed(context, '/login');
          },
        ),
      ],
    ),
  );
}