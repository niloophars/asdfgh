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

 Future<QuerySnapshot> searchByRecipeName(String searchKey) async {
  return FirebaseFirestore.instance
      .collection('Recipe')
      .where('searchIndex', arrayContains: searchKey)
      .get();
}

Future<QuerySnapshot> searchByIngredient(String searchKey) async {
  return FirebaseFirestore.instance
      .collection('Recipe')
      .where('searchIndexIngredients', arrayContains: searchKey)
      .get();
}






  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);

  }

  Future<void> addFavorite(String userId, Map<String, dynamic> recipeData, String recipeId) async {
  return await FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("favorites")
      .doc(recipeId) // use real Recipe doc ID as doc name
      .set({
        ...recipeData,
        "recipeId": recipeId, // ensure it's stored
      });
}


  Future<void> removeFavorite(String userId, String recipeId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("favorites")
        .doc(recipeId)
        .delete();
  }

  Future<bool> isFavorite(String userId, String recipeId) async {
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("favorites")
        .doc(recipeId)
        .get();

    return doc.exists;
  }

   // Save user rating to the subcollection
  Future<void> addUserRating(String recipeId, String userId, double rating) async {
    return await FirebaseFirestore.instance
        .collection("Recipe")
        .doc(recipeId)
        .collection("Ratings")
        .doc(userId)
        .set({
          "rating": rating,
        });
  }

  // Check if user has already rated
  Future<double?> getUserRating(String recipeId, String userId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Recipe")
        .doc(recipeId)
        .collection("Ratings")
        .doc(userId)
        .get();

    if (snapshot.exists) {
      return (snapshot.data() as Map<String, dynamic>)["rating"]?.toDouble();
    } else {
      return null;
    }
  }

  // Update average rating and count in recipe document
  Future<void> updateRecipeAverageRating(String recipeId, double newAvg, int newCount) async {
    return await FirebaseFirestore.instance
        .collection("Recipe")
        .doc(recipeId)
        .update({
          "rating": newAvg,
          "rating_count": newCount,
        });
  }


  // Fetch a recipe by its ID
  Future<Map<String, dynamic>?> getRecipeById(String recipeId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Recipe')
        .doc(recipeId)
        .get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    }
    return null;
  }

  // Update the recipe in the database
  Future<void> updateRecipe(String recipeId, Map<String, dynamic> updatedRecipe) async {
    await FirebaseFirestore.instance
        .collection('Recipe')
        .doc(recipeId)
        .update(updatedRecipe);
  
}


  // Method to fetch recipes added by the current user
  Future<Stream<QuerySnapshot>> getUserRecipes(String userId) async {
    return FirebaseFirestore.instance
        .collection("Recipe")
        .where("userId", isEqualTo: userId) // Assuming you store userId in each recipe document
        .snapshots();
  }
}


