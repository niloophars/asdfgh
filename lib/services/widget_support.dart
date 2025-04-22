import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class AppWidget{

  static TextStyle headlineTextFieldStyle(){
    return TextStyle(
      color: const Color.fromARGB(255, 146, 88, 0),
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle simpleTextFieldStyle(){
    return TextStyle(
      color: Colors.black,
      fontSize: 18.0,
    );
  }

  static TextStyle whiteTextFieldStyle(){
    return TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.bold
    );
  }

  static TextStyle boldTextFieldStyle(){
    return TextStyle(
      color: Colors.black,
      fontSize: 15.0,
      fontWeight: FontWeight.bold
    );
  }

  static TextStyle priceTextFieldStyle(){
    return TextStyle(
      color: const Color.fromARGB(174, 0, 0, 0),
      fontSize: 10.0,
      fontWeight: FontWeight.bold
    );
  }

  static TextStyle lightTextFieldStyle(){
    return TextStyle(
      color: const Color.fromARGB(255, 103, 78, 4),
      fontSize: 15.0,
      fontWeight: FontWeight.w500
    );
  }

  static TextStyle signupTextFieldStyle(){
    return TextStyle(
      color: const Color.fromARGB(255, 103, 78, 4),
      fontSize: 18.0,
      fontWeight: FontWeight.bold
    );
  }

  static Widget buildGlobalNavBar(BuildContext context) {
    return CurvedNavigationBar(
      height: 70,
      backgroundColor: const Color.fromARGB(255, 255, 248, 231),
      color: const Color.fromARGB(255, 148, 89, 0),
      animationDuration: Duration(milliseconds: 500),
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/search');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/add');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
      items: [
        Icon(Icons.home, color: Colors.white, size: 30.0),
        Icon(Icons.search, color: Colors.white, size: 30.0),
        Icon(Icons.add_circle, color: Colors.white, size: 30.0),
        Icon(Icons.person, color: Colors.white, size: 30.0),
      ],
    );
  }


}