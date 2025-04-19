import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addRecipe(Map<String, dynamic> addrecipe) async {
    return await FirebaseFirestore.instance
        .collection("Recipe")
        .add(addrecipe);

  }


  Future<Stream<QuerySnapshot>> getallRecipe() async {
    return await FirebaseFirestore.instance.collection("Recipe").snapshots();
  }
}