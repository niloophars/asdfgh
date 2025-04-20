

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:recipe/pages/login.dart';

import 'package:recipe/services/database.dart';
import 'package:recipe/services/shared_pref.dart';
import 'package:recipe/services/widget_support.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email = "", password = "", name = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  

  registration() async {
  if (password != null &&
      namecontroller.text != "" &&
      mailcontroller.text != "") {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        Map<String, dynamic> userInfoMap = {
          "Name": namecontroller.text,
          "Email": mailcontroller.text,
          "Id": user.uid, // ✅ Set correct UID here
        };

        await SharedpreferenceHelper().saveUserEmail(email);
        await SharedpreferenceHelper().saveUserName(namecontroller.text);
        await DatabaseMethods().addUserDetails(userInfoMap, user.uid); // ✅ Use FirebaseAuth UID as doc ID

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(255, 175, 152, 76),
            content: Text(
              "Registered Successfully",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogIn ()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(255, 199, 165, 52),
            content: Text(
              "The password provided is too weak.",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor:const Color.fromARGB(255, 199, 165, 52),
            content: Text(
              "The account already exists for that email.",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }
}






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              padding: EdgeInsets.only(top: 40.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 216, 191, 113),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              child: Column(
                children: [
                  Image.asset(
                  "images/icon.png",
                  height: 180,
                  fit: BoxFit.fill,
                  width: 240,
                ),
          
          ],
        ),
                ),
                Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height / 4,
          left: 20.0,
          right: 20.0
        ),
        child: Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.only(
               left: 20.0,
               right: 20.0,          
         ),                   
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            height: MediaQuery.of(context).size.height / 1.65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0,),
                Center(
                  child: Text(
                  "Signup",
                  style: AppWidget.headlineTextFieldStyle(),
                ),
                ),
                SizedBox(height: 10.0),
                Text(
                   "Name", 
                    style: AppWidget.signupTextFieldStyle()
                ),                
                SizedBox(height: 5.0),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Name",
                        prefixIcon: Icon(Icons.person_outline)
                    ),
                  ),
                ),
            
                SizedBox(height: 10.0),
                Text("Email", style: AppWidget.signupTextFieldStyle()),
                SizedBox(height: 5.0),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: mailcontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Email",
                        prefixIcon: Icon(Icons.mail_outline)),
                  ),
                ),
                SizedBox(height: 10.0),
                Text("Password", style: AppWidget.signupTextFieldStyle()),
                SizedBox(height: 5.0),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    obscureText: true,
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Password",
                        prefixIcon: Icon(Icons.password_outlined)),
                  ),
                ),
              
        SizedBox(
          height: 20.0
        ),
        GestureDetector(
          onTap: () {
            if(namecontroller.text!="" && mailcontroller.text!="" && passwordcontroller.text!="") {
              setState(() {
              name = namecontroller.text;
              email = mailcontroller.text;
              password = passwordcontroller.text;
              });
              registration();
                
              
              
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color.fromARGB(255, 199, 165, 52),
                  content: Text(
                    "Please fill all the fields",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                )
              );
            }
          },
          child: Center(
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 202, 121, 0),
                  borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: Text(
                  "Sign Up", 
                  style: AppWidget.boldTextFieldStyle()
                )
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Have an account?",
              style: AppWidget.simpleTextFieldStyle(),
            ),
            SizedBox(width: 10.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => LogIn()));
              },
              child: Text("Log In", style: AppWidget.boldTextFieldStyle()),
            ),
          ],
        ),
            ],
          ),
        ),
          ),
        )
            ],
          ),
      )
      );
  }
}

