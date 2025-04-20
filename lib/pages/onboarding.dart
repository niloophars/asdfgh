import 'package:recipe/pages/signup.dart';
import 'package:recipe/services/widget_support.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 187, 105),
      body: Container(
        margin: EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            SizedBox(height: 120.0,),
            Image.asset(
              "images/icon.png",
            ),
            SizedBox(height: 20.0,),
           
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Looking for Recipes?\nRight place to begin!",
              textAlign: TextAlign.center,
              style: AppWidget.signupTextFieldStyle(),
            ),
            SizedBox(
              height: 30.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Signup(),
                  ),
                );
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 150, 111, 75),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Center(
                  child: Text(
                    "Get Started!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}