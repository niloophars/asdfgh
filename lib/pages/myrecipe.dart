import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/pages/recipe.dart';
import 'package:recipe/services/widget_support.dart';

class MyRecipes extends StatefulWidget {
  @override
  _MyRecipesState createState() => _MyRecipesState();
}

class _MyRecipesState extends State<MyRecipes> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userId;
  bool isLoading = true;
  List<Map<String, dynamic>> myRecipes = [];

  @override
  void initState() {
    super.initState();
    getUserRecipes();
  }

  // Fetch the current user's recipes from Firestore
  void getUserRecipes() async {
    User? user = _auth.currentUser;
    if (user != null) {
      userId = user.uid;

      // Fetch the recipes added by the user
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Recipe")
          .where("userId", isEqualTo: userId)
          .get();

      setState(() {
        myRecipes = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Add recipe ID
          return data;
        }).toList();
        isLoading = false;
      });
    }
  }

  // Delete a recipe added by the user
  void deleteRecipe(String recipeId) async {
    await FirebaseFirestore.instance.collection("Recipe").doc(recipeId).delete();

    setState(() {
      myRecipes.removeWhere((recipe) => recipe["id"] == recipeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 248, 231),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Custom App Bar Style Title
            Container(
              margin: EdgeInsets.only(top: 40.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
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
                  
                  Expanded(
                    child: Center(
                      child: Text(
                        "My Recipes",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 171, 102, 0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40), // Space for the back button
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : myRecipes.isEmpty
                      ? Center(
                          child: Text(
                            "No recipes added yet!",
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color.fromARGB(255, 133, 73, 0),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: myRecipes.length,
                          itemBuilder: (context, index) {
                            var recipe = myRecipes[index];
                            var recipeId = recipe['id'];
        
                            return Card(
                              color: const Color.fromARGB(255, 236, 201, 95),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(10),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    recipe["ImageURL"] ?? '',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  recipe["Name"] ?? "No name",
                                  style: AppWidget.boldTextFieldStyle(),
                                ),
                                subtitle: Text(
                                  recipe["Category"] ?? "",
                                  style: TextStyle(color: const Color.fromARGB(221, 75, 53, 5)),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: const Color.fromARGB(255, 150, 90, 0)),
                                  onPressed: () => deleteRecipe(recipeId),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Recipe(
                                        image: recipe["ImageURL"] ?? '',
                                        dish: recipe["Name"] ?? '',
                                        recipeId: recipeId,
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
      ),
       bottomNavigationBar: AppWidget.buildGlobalNavBar(context),
    );
  }
}
