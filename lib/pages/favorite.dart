import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/pages/recipe.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userId;
  bool isLoading = true;
  List<Map<String, dynamic>> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    getUserFavorites();
  }

  void getUserFavorites() async {
    User? user = _auth.currentUser;
    if (user != null) {
      userId = user.uid;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("favorites")
          .get();

      setState(() {
        favoriteRecipes =
            snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        isLoading = false;
      });
    }
  }

  void removeFavorite(String dishName) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("favorites")
          .doc(dishName)
          .delete();

      setState(() {
        favoriteRecipes.removeWhere((recipe) => recipe["Name"] == dishName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 248, 231),
      body: Column(
        children: [
          // Custom App Bar Style Title
          Container(
            margin: EdgeInsets.only(top: 40.0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "My Favorite Recipes",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 171, 102, 0),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : favoriteRecipes.isEmpty
                    ? Center(
                        child: Text(
                          "No favorites added yet!",
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color.fromARGB(255, 133, 73, 0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        itemCount: favoriteRecipes.length,
                        itemBuilder: (context, index) {
                          var recipe = favoriteRecipes[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: const Color.fromARGB(255, 238, 214, 161), // Light green background
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(10),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  recipe["ImageURL"] ?? '',
                                  width: 60, // Increased from 50
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                recipe["Name"] ?? "No name",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: const Color.fromARGB(255, 156, 118, 5),
                                ),
                              ),
                              subtitle: Text(
                                recipe["Category"] ?? "",
                                style: TextStyle(color: const Color(0xDD885F08)),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: const Color.fromARGB(255, 150, 90, 0)),
                                onPressed: () => removeFavorite(recipe["Name"]),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Recipe(
                                      image: recipe["Image"] ?? '',
                                      dish: recipe["Name"] ?? '',
                                    ),
                                  ),
                                );
                              },
                            ),
                          );

                        },
                      ),
          ),
        ],
      ),
    );
  }
}
