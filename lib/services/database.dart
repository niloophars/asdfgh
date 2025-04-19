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

  Future<Stream<QuerySnapshot>> getCategoryRecipe(String category) async {
    return await FirebaseFirestore.instance.collection("Recipe").
    where("Category", isEqualTo: category).snapshots();
  }

Future<QuerySnapshot> search(String name) async {
  return await FirebaseFirestore.instance.collection("Recipe")
      .where("Key", arrayContains: name.substring(0, 1).toUpperCase())
      .get();
}



}
