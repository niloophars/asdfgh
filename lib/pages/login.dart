import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/pages/bottomnavbar.dart';
import 'package:recipe/pages/signup.dart';
import 'package:recipe/services/shared_pref.dart';
import 'package:recipe/services/widget_support.dart';

class LogIn extends StatefulWidget {
  const LogIn ({Key? key}) : super(key: key);

  @override
 State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email ="", password = "", name = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();

    userLogin() async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null) {
      print("Logged in with user UID: ${user.uid}"); // Log user UID
      
      // Fetch user info from Firestore
      var userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      print("Document exists: ${userDoc.exists}"); // Log if the document exists

      if (userDoc.exists) {
        String userName = userDoc["Name"];
        String userEmail = userDoc["Email"];

        // Save to SharedPreferences
        await SharedpreferenceHelper().saveUserId(user.uid);
        await SharedpreferenceHelper().saveUserName(userName);
        await SharedpreferenceHelper().saveUserEmail(userEmail);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar()),
        );
      } else {
        // Handle case where document does not exist
        print("No document found for this UID in Firestore.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("User data not found in Firestore."),
          ),
        );
      }
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "No user found for that email.",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } else if (e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Wrong password provided for that user.",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }
  }
}



     






 @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              padding: EdgeInsets.only(top: 40.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(0xffffefbf),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              child: Column(
                children: [
                  Image.asset(
                  "images/nomnom.png",
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
                  "Login",
                  style: AppWidget.headlineTextFieldStyle(),
                ),
                ),
                SizedBox(height: 10.0),
                SizedBox(height: 20.0),
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
          height: 10.0
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Forgot Password?",
              style: AppWidget.simpleTextFieldStyle(),
            )
          ],
        ),
        SizedBox(
          height: 40.0
        ),
        GestureDetector(
          onTap: () {
            if(mailcontroller.text != "" && passwordcontroller.text != "") {
              setState(() {
                email = mailcontroller.text;
              password = passwordcontroller.text;
                
              });
             
              userLogin();
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
                  "Log In", 
                  style: AppWidget.boldTextFieldStyle()
                )
              ),
            ),
          ),
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No account?",
              style: AppWidget.simpleTextFieldStyle(),
            ),
            SizedBox(width: 10.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Signup()));
              },
              child: Text("Sign Up", style: AppWidget.boldTextFieldStyle()),
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
      ),
      );
  }
}

