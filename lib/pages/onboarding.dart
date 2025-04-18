import 'package:recipe/service/widget_support.dart';
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
      backgroundColor: const Color.fromARGB(255, 188, 188, 188),
      body: Container(
        margin: EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            Image.asset(
              "images/background.jpg",
            ),
            SizedBox(height: 20.0,),
            Text("Find Apps\nStart Cooking",
            textAlign: TextAlign.center,
            style: AppWidget.headlineTextFieldStyle(),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Looking for Cookers?\nRight place to look!",
              textAlign: TextAlign.center,
              style: AppWidget.simpleTextFieldStyle(),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width/2,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 191, 148, 107),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Center(
                child: Text(
                  "Get Cooked!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
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