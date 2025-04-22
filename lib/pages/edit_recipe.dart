import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe/services/widget_support.dart';

class EditRecipePage extends StatefulWidget {
  final String recipeId;
  final Map<String, dynamic> recipeData;

  EditRecipePage({required this.recipeId, required this.recipeData});

  @override
  _EditRecipePageState createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController timeController;
  late TextEditingController imageUrlController;
  List<Map<String, String>> ingredientsList = [];
  List<String> instructionsList = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.recipeData['Name']);
    timeController = TextEditingController(text: widget.recipeData['TotalTime']);
    imageUrlController = TextEditingController(text: widget.recipeData['ImageURL']);

    ingredientsList = List<Map<String, String>>.from(
      (widget.recipeData['Ingredients'] as List).map((item) => {
            'name': item['name'].toString(),
            'quantity': item['quantity'].toString(),
          }),
    );

    instructionsList = List<String>.from(widget.recipeData['CookingInstructions'] ?? []);
  }

  void saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('Recipe').doc(widget.recipeId).update({
        'Name': nameController.text.trim(),
        'TotalTime': timeController.text.trim(),
        'ImageURL': imageUrlController.text.trim(),
        'Ingredients': ingredientsList,
        'CookingInstructions': instructionsList,
      });

      Navigator.pop(context); // Go back to recipe detail
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          // 🔶 Custom Header (like "My Favorite Recipes")
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Edit Recipe",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 171, 102, 0),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: saveRecipe,
                  icon: Icon(Icons.save),
                  color: const Color.fromARGB(255, 112, 79, 1),
                  iconSize: 28,
                ),
              ],
            ),
          ),

          // 📋 Form Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text(
                      "Dish Name",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 171, 107, 13),
                        fontWeight: FontWeight.bold
                        ),
                      ),
                    TextFormField(
                      controller: nameController,
                      validator: (value) => value!.isEmpty ? 'Enter a name' : null,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Total Time",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 171, 107, 13),
                        fontWeight: FontWeight.bold
                        ),
                      ),
                    TextFormField(
                      controller: timeController,
                      validator: (value) => value!.isEmpty ? 'Enter time' : null,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Image URL",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 171, 107, 13),
                        fontWeight: FontWeight.bold
                        ),
                      ),
                    TextFormField(
                      controller: imageUrlController,
                      validator: (value) => value!.isEmpty ? 'Enter image URL' : null,
                    ),
                    SizedBox(height: 24),

                    Text("Ingredients", 
                    style: TextStyle(
                        color: const Color.fromARGB(255, 171, 107, 13),
                        fontWeight: FontWeight.bold
                        ),
                      ),
                    ...ingredientsList.asMap().entries.map((entry) {
                      int index = entry.key;
                      return Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: entry.value['name'],
                              decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(
                                  color: const Color.fromARGB(255, 171, 107, 13)
                                )
                                ),
                              onChanged: (val) => ingredientsList[index]['name'] = val,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              initialValue: entry.value['quantity'],
                              decoration: InputDecoration(
                                labelText: 'Quantity',
                                labelStyle: TextStyle(
                                  color: const Color.fromARGB(255, 171, 107, 13)
                                )
                                ),
                              onChanged: (val) => ingredientsList[index]['quantity'] = val,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: const Color.fromARGB(255, 156, 94, 0)),
                            onPressed: () => setState(() => ingredientsList.removeAt(index)),
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 202, 121, 0),
                          borderRadius: BorderRadius.circular(20.0),
                          
                        ),
                        
                         child: TextButton.icon(
                        onPressed: () => setState(() => ingredientsList.add({'name': '', 'quantity': ''})),
                        icon: Icon(Icons.add, color: Colors.white),
                        
                        label: Text(
                          "Add Ingredient",
                          style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    Text("Instructions", 
                    style: TextStyle(
                        color: const Color.fromARGB(255, 171, 107, 13),
                        fontWeight: FontWeight.bold
                        ),),
                    ...instructionsList.asMap().entries.map((entry) {
                      int index = entry.key;
                      return Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: entry.value,
                              decoration: InputDecoration(
                                labelText: 'Step ${index + 1}',
                                labelStyle: TextStyle(
                                  color: const Color.fromARGB(255, 171, 107, 13)
                                )
                              ),
                              onChanged: (val) => instructionsList[index] = val,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: const Color.fromARGB(255, 156, 94, 0),),
                            onPressed: () => setState(() => instructionsList.removeAt(index)),
                          ),
                        ],
                      );
                    }),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 202, 121, 0),
                          borderRadius: BorderRadius.circular(20.0),
                          
                        ),
                      child: TextButton.icon(
                        onPressed: () => setState(() => instructionsList.add('')),
                        icon: Icon(
                          Icons.add,
                          color: Colors.white
                        ),
                        label: Text(
                          "Add Step",
                          style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                          
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}