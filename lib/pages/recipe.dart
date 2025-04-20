import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:recipe/pages/shared_pref.dart';
import 'package:recipe/services/widget_support.dart';

class Recipe extends StatefulWidget {
  String image, dish;
  Recipe({required this.image, required this.dish});

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {

  Map<String, dynamic>? recipeData;
  String? name, id;
  bool isLoading = true;

  // getthesharedpref() async {
  //   name = await SharedpreferenceHelper().getUserName();
  //   id = await SharedpreferenceHelper().getUserId();
  //   setState(() {
      
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // getthesharedpref();
    getRecipeDetails();
  }

  getRecipeDetails() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Recipe")
        .where("Name", isEqualTo: widget.dish)
        .get();

    if (snap.docs.isNotEmpty) {
      setState(() {
        recipeData = snap.docs.first.data() as Map<String, dynamic>;
        isLoading = false;
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
                        Text(
                          widget.dish,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            Icon(Icons.timer, color: Colors.black54),
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
                        SizedBox(height: 20.0),
                        Text(
                          "Ingredients",
                          style: AppWidget.boldTextFieldStyle(),
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
                          style: AppWidget.boldTextFieldStyle(),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
