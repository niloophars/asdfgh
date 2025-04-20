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

 Future<QuerySnapshot> search(String searchKey) async {
  return FirebaseFirestore.instance
    .collection('Recipe')
    .where('searchIndex', arrayContains: searchKey)
    .get();

}





  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);

  }

  Future<void> addFavorite(String userId, Map<String, dynamic> recipeData, String dishName) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("favorites")
        .doc(dishName)
        .set(recipeData);
  }

  Future<void> removeFavorite(String userId, String dishName) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("favorites")
        .doc(dishName)
        .delete();
  }

  Future<bool> isFavorite(String userId, String dishName) async {
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("favorites")
        .doc(dishName)
        .get();

    return doc.exists;
  }
}



