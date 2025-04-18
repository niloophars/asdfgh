// import 'package:cooker/service/database.dart';
// import 'package:cooker/service/shared_pref.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// registration() async {
//   if(password != null &&
//   namecontroller.text != "" && 
//   mailcontroller.text != "") {
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password
//       );
//       String Id = randomAlphaNumeric(10);
//       Map<String, dynamic> userInfoMap = {
//         "Name": namecontroller.text,
//         "Email": mailcontroller.text,
//         "Id": Id,
//       };
//       await SharedpreferenceHelper().saveUserEmail(email);
//       await SharedpreferenceHelper().saveUserName(namecontroller.text);
//       await DatabaseMethods().addUserDetails(userInfoMap, Id);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.green,
//           content: Text(
//             "Registered Successfully",
//             style: TextStyle(
//               fontSize: 18.0,
//               fontWeight: FontWeight.bold,
//             ),
//           )
//         )
//       );
//     }
//     on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Colors.orangeAccent,
//             content: Text(
//               "The password provided is too weak.",
//               style: TextStyle(
//                 fontSize: 18.0,
//               ),
//             )
//           )
//         );
//       } else if (e.code == 'email-already-in-use') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Colors.orangeAccent,
//             content: Text(
//               "The account already exists for that email.",
//               style: TextStyle(
//                 fontSize: 18.0,
//               ),
//             )
//           )
//         );
//       }
//     }
//   }
// }