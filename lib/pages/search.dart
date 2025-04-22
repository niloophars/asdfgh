import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe/pages/recipe.dart';
import 'package:recipe/services/widget_support.dart';

class RecipeSearchAltUI extends StatefulWidget {
  @override
  _RecipeSearchAltUIState createState() => _RecipeSearchAltUIState();
}

class _RecipeSearchAltUIState extends State<RecipeSearchAltUI> {

List queryResultSet = [];
List tempSearchStore = [];
bool search = false;






  String _searchQuery = "";
  String _searchMode = "Name"; // or "Ingredient"
  List<QueryDocumentSnapshot> _results = [];

   void initiateSearch(String value) {
  if (value.isEmpty) {
    setState(() {
      queryResultSet = [];
      tempSearchStore = [];
      search = false;
    });
    return;
  }

  String searchKey = value.toLowerCase();

  if (queryResultSet.isEmpty) {
    FirebaseFirestore.instance
        .collection('Recipe')
        .get()
        .then((QuerySnapshot docs) {
      List tempList = [];
      for (var doc in docs.docs) {
        var recipeData = doc.data() as Map<String, dynamic>;
        recipeData["id"] = doc.id;
        tempList.add(recipeData);
      }

      setState(() {
        queryResultSet = tempList;

        if (_searchMode == "Recipe Name") {
          tempSearchStore = tempList.where((element) =>
            element['SearchedName'].toString().startsWith(searchKey)).toList();
        } else {
          tempSearchStore = tempList.where((element) {
            List ingredients = element['Ingredients'];
            return ingredients.any((i) =>
              i['name'].toString().toLowerCase().startsWith(searchKey));
          }).toList();
        }

        search = true;
      });
    });
  } else {
    setState(() {
      if (_searchMode == "Recipe Name") {
        tempSearchStore = queryResultSet.where((element) =>
            element['SearchedName'].toString().startsWith(searchKey)).toList();
      } else {
        tempSearchStore = queryResultSet.where((element) {
          List ingredients = element['Ingredients'];
          return ingredients.any((i) =>
            i['name'].toString().toLowerCase().startsWith(searchKey));
        }).toList();
      }

      search = true;
    });
  }
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
          child: Row(
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
              Text(
                data["Name"],
                style: AppWidget.boldTextFieldStyle(),
              )
            ],
          ),
        ),
      ),
    ),
  );
}


  Widget _buildRecipeCard(DocumentSnapshot doc) {
    final name = doc['Name'];
    final ingredients = List<Map<String, dynamic>>.from(doc['Ingredients']);

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: ingredients
              .map((i) => Text("- ${i['name']} (${i['quantity']})", style: TextStyle(fontSize: 14)))
              .toList(),
        ),
      ),
    );
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Search Recipes')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
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
            child: TextField(
              onChanged: (value) {
                _searchQuery = value;
                initiateSearch(value);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                
                suffixIcon: Icon(
                  Icons.search_outlined,
                  color: Color.fromARGB(255, 137, 84, 4),
                ),
              ),
              style: TextStyle(color: Color.fromARGB(255, 137, 84, 4)),
              cursorColor: Color.fromARGB(255, 137, 84, 4),
            ),
          ),

          SizedBox(height: 20),

          // Results
          Expanded(
  child: !search
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
                  color: Colors.grey[700],
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