import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Add for star rating
import 'package:recipe/services/database.dart';

class Recipe extends StatefulWidget {
  String image, dish, recipeId;
  Recipe({required this.image, required this.dish, required this.recipeId});

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  Map<String, dynamic>? recipeData;
  bool isLoading = true;
  bool isFavorite = false; // Track favorite status
  late String userId;
  double? userRating; // Store the user's rating
  double? averageRating; // Store the recipe's average rating

  DatabaseMethods databaseMethods = DatabaseMethods();

 @override
void initState() {
  super.initState();
  initializeRecipeScreen();
}

void initializeRecipeScreen() async {
  await _getCurrentUserId();        // sets userId
  await getRecipeDetails();         // fetch recipe info
  await getUserRating();            // gets this user's rating
}



  // Fetch recipe details from Firestore
  getRecipeDetails() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Recipe")
        .where("Name", isEqualTo: widget.dish)
        .get();

    if (snap.docs.isNotEmpty) {
      setState(() {
        recipeData = snap.docs.first.data() as Map<String, dynamic>;
        averageRating = recipeData!["rating"] ?? 0.0; // Get current average rating
        isLoading = false;
      });
    }
  }

  // Get the current user's ID from FirebaseAuth
  Future<void> _getCurrentUserId() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    userId = user.uid;              // no need for setState here
    _checkFavoriteStatus(userId);  // check if it's a favorite
  }
}

// Fetch this user's rating for the current recipe
Future<void> getUserRating() async {
  var ratingDoc = await FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("ratings")
      .doc(widget.recipeId)
      .get();

  if (ratingDoc.exists) {
    setState(() {
      userRating = ratingDoc['rating'];
    });
  }
}



  // Check if the recipe is a favorite for the current user
  void _checkFavoriteStatus(String userId) async {
    bool favoriteStatus = await databaseMethods.isFavorite(userId, widget.dish);
    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  // Toggle the favorite status
  void toggleFavorite() async {
    if (isFavorite) {
      // Remove from favorites
      await databaseMethods.removeFavorite(userId, widget.dish);
    } else {
      // Add to favorites
      await databaseMethods.addFavorite(userId, recipeData!, widget.dish);
    }

    // Update the UI to reflect the new favorite status
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  // Update rating in Firestore
  void updateRating(double rating) async {
  if (recipeData != null) {
    final recipeRef = FirebaseFirestore.instance.collection("Recipe").doc(widget.recipeId);
    final userRef = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("ratings")
        .doc(widget.recipeId);

    // Check if user already rated
    var existingRatingDoc = await userRef.get();
    double existingRating = existingRatingDoc.exists ? existingRatingDoc['rating'] : 0.0;

    double totalRating = recipeData!["rating"] ?? 0.0;
    int ratingCount = recipeData!["rating_count"] ?? 0;

    double newTotalRating;
    int newRatingCount;

    if (existingRatingDoc.exists) {
      // If already rated, adjust total
      newTotalRating = totalRating - existingRating + rating;
      newRatingCount = ratingCount;
    } else {
      newTotalRating = totalRating + rating;
      newRatingCount = ratingCount + 1;
    }

    double newAverageRating = newTotalRating / newRatingCount;

    // Update recipe average
    await recipeRef.update({
      "rating": newAverageRating,
      "rating_count": newRatingCount,
    });

    // Store user-specific rating
    await userRef.set({
      "rating": rating,
      "timestamp": FieldValue.serverTimestamp(),
    });

    setState(() {
      averageRating = newAverageRating;
      userRating = rating;
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Image.network(
                  widget.image,
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 40.0,
                  ),
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width / 1.1,
                  ),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 247, 213, 112),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recipe heading with dish name
                        Text(
                          widget.dish,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        SizedBox(height: 10.0),
                        // Timer and Rating in the same row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.timer, color: const Color.fromARGB(255, 112, 79, 1)),
                                SizedBox(width: 6),
                                Text(
                                  recipeData!["TotalTime"] ?? "",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                
                                 Icon(
                                  Icons.star_border,
                                  color: const Color.fromARGB(255, 112, 79, 1),
                                  size: 40,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  averageRating != null
                                      ? averageRating!.toStringAsFixed(1)
                                      : "0.0",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                               
                              ],
                            ),
                            GestureDetector(
                              onTap: toggleFavorite,
                              child: Icon(
                                isFavorite ? Icons.bookmark : Icons.bookmark_border,
                                size: 50.0,
                                color: const Color.fromARGB(255, 112, 79, 1),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "Ingredients",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(height: 10.0),
                        ...List.generate(
                          (recipeData!["Ingredients"] as List).length,
                          (index) {
                            final ingredient = recipeData!["Ingredients"][index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                "• ${ingredient["name"]} - ${ingredient["quantity"]}",
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "Instructions",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(height: 10.0),
                        ...List.generate(
                          (recipeData!["CookingInstructions"] as List).length,
                          (index) {
                            final step = recipeData!["CookingInstructions"][index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Text(
                                "${index + 1}. $step",
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 30),
                        // Rating Input Section
                        Text(
                          "Rate this recipe",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        RatingBar.builder(
                          initialRating: userRating ?? 0.0,
                          minRating: 1,
                          itemCount: 5,
                          itemSize: 40.0,
                          direction: Axis.horizontal,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, index) {
                            // Check if the current star index is less than the user's rating
                            if (index < (userRating ?? 0.0)) {
                              // Return a filled star for rated stars
                              return Icon(
                                Icons.star,
                                color: const Color.fromARGB(255, 157, 126, 1), // Golden color for rated stars
                              );
                            } else {
                              // Return an outlined star for unrated stars
                              return Icon(
                                Icons.star_border,
                                color: const Color.fromARGB(255, 168, 118, 1), // Light gold color for unrated stars
                              );
                            }
                          },
                          onRatingUpdate: (rating) {
                            updateRating(rating);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Small round back button positioned at top left
                Positioned(
                  top: 30,
                  left: 10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Pop the current screen and go back
                    },
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 212, 183, 96),
                      radius: 20,
                      child: Icon(
                        Icons.arrow_back,
                        color: const Color.fromARGB(255, 112, 79, 1),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
