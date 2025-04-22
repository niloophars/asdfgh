import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe/pages/recipe.dart';
import 'package:recipe/services/database.dart';
import 'package:recipe/services/widget_support.dart';

class Search extends StatefulWidget {
  @override
  _Search createState() => _Search();
}

class _Search extends State<Search> {
  List queryResultSet = [];
  List tempSearchStore = [];
  bool search = false;

  String _searchQuery = "";
  String _searchMode = ""; // Initially empty
  List<QueryDocumentSnapshot> _results = [];

  
  


      void initiateSearch(String value) {
  String searchKey = value.toLowerCase();

  if (_searchMode.isEmpty || searchKey.isEmpty) {
    setState(() {
      tempSearchStore = [];
      search = false;
    });
    return;
  }

  Future<QuerySnapshot> future = _searchMode == "Recipe Name"
      ? DatabaseMethods().searchByRecipeName(searchKey)
      : DatabaseMethods().searchByIngredient(searchKey);

  future.then((snapshot) {
    List<Map<String, dynamic>> results = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data["id"] = doc.id;

      // 🔍 Only if searching by Ingredient
      if (_searchMode == "Ingredient") {
        final ingredients = List<Map<String, dynamic>>.from(data["Ingredients"] ?? []);
        final matchedIngredients = <String>[];

        // Check if the searchKey matches the beginning of the ingredient name (case insensitive)
        for (var ingredient in ingredients) {
          String ingredientName = ingredient['name'].toString().toLowerCase();

          // Add the full ingredient name if the searchKey matches the start of the ingredient name
          if (ingredientName.startsWith(searchKey)) {
            matchedIngredients.add(ingredient['name']);  // Add full ingredient name here
          }
        }

        // Only include recipes where we found matching ingredients
        data["matchedIngredients"] = matchedIngredients;
      }

      return data;
    }).toList();

    setState(() {
      tempSearchStore = results;
      search = true;
    });
  });
}





  Widget _buildToggleButton(String label) {
    final isActive = _searchMode == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _searchMode = label;
            _searchQuery = "";
            _results.clear();
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Color.fromARGB(255, 148, 89, 0) : const Color.fromARGB(255, 235, 214, 151),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Color.fromARGB(255, 148, 89, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildResultCard(Map<String, dynamic> data) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Recipe(
            dish: data["Name"],
            image: data["ImageURL"],
            recipeId: data["id"],
          ),
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 236, 201, 95),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      data["ImageURL"],
                      height: 60.0,
                      width: 60.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      data["Name"],
                      style: AppWidget.boldTextFieldStyle(),
                    ),
                  )
                ],
              ),
              if (_searchMode == "Ingredient" && data["matchedIngredients"] != null && data["matchedIngredients"].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Wrap(
                    spacing: 6,
                    children: (data["matchedIngredients"] as List<String>)
                        .map((ingredient) => Chip(
                              label: Text(ingredient),
                              backgroundColor: const Color.fromARGB(255, 197, 151, 15),
                              labelStyle: TextStyle(color: Colors.brown[800]),
                            ))
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}



@override
Widget build(BuildContext context) {
  return Scaffold(
    // Remove the AppBar and add the custom Container as the header
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Custom Container for the header (replacing AppBar)
          Container(
            margin: EdgeInsets.only(top: 40.0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Back Button
                Positioned(
                  top: 30,
                  left: 10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Go back to the previous screen
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
                SizedBox(
                  width: 10,
                ),
                // Title
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
          SizedBox(height: 20),
          // Toggle Buttons
          Row(
            children: [
            
              _buildToggleButton("Recipe Name"),
              SizedBox(width: 8),
              _buildToggleButton("Ingredient"),
            ],
          ),
          SizedBox(height: 20),

          // Custom Search Bar
          Container(
            padding: EdgeInsets.only(left: 10.0),
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 231, 202, 159),
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar (always visible)
                TextField(
                  onChanged: (value) {
                    if (_searchMode.isNotEmpty) {
                      _searchQuery = value;
                      initiateSearch(value);
                    }
                  },
                  enabled: _searchMode.isNotEmpty, // Disable if no category is selected
                  decoration: InputDecoration(
                    hintText: _searchMode.isEmpty
                        ? "Choose a filter"  // Show hint text when no mode is selected
                        : "Search by $_searchMode", // Show the filter type when one is selected
                    border: InputBorder.none,
                    suffixIcon: Icon(
                      Icons.search_outlined,
                      color: Color.fromARGB(255, 137, 84, 4),
                    ),
                  ),
                  style: TextStyle(
                    color: _searchMode.isNotEmpty
                        ? Color.fromARGB(255, 137, 84, 4)
                        : Colors.grey, // Change color based on enabled state
                  ),
                  cursorColor: Color.fromARGB(255, 137, 84, 4),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Results
          Expanded(
            child: _searchMode.isEmpty
                ? Center(
                    child: Text(
                      "Start searching for recipes!",
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 133, 73, 0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : !search
                    ? Center(
                        child: Text(
                          "Start searching for recipes!",
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color.fromARGB(255, 133, 73, 0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : tempSearchStore.isEmpty
                        ? Center(
                            child: Text(
                              "No recipes found",
                              style: TextStyle(
                                fontSize: 18,
                                color: const Color.fromARGB(255, 133, 73, 0),
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: tempSearchStore.length,
                            itemBuilder: (context, index) {
                              final data = tempSearchStore[index];
                              return buildResultCard(data);
                            },
                          ),
          ),
        ],
      ),
    ),
  );
}

  

  

}
