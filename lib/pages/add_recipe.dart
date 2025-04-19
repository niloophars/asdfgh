import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recipe/services/database.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  String? value;

  final List<String> recipe = [
    "Breakfast",
    "Lunch",
    "Dinner",
    "Dessert",
    "Drinks",
  ];
  PageController _pageController = PageController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ingredientNameController = TextEditingController();
  TextEditingController ingredientQuantityController = TextEditingController();
  TextEditingController cookingInstructionsController = TextEditingController();
  TextEditingController totalTimeController = TextEditingController();

  List<Map<String, String>> ingredientsList = [];
  List<String> cookingInstructionsList = [];

  void addIngredient(String name, String quantity) {
    setState(() {
      ingredientsList.add({"name": name, "quantity": quantity});
      ingredientNameController.clear();
      ingredientQuantityController.clear();
    });
  }

  void addInstruction(String instruction) {
    setState(() {
      cookingInstructionsList.add(instruction);
      cookingInstructionsController.clear();
    });
  }

  uploadItem() async {
    if (imageUrlController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        ingredientsList.isNotEmpty &&
        cookingInstructionsList.isNotEmpty &&
        totalTimeController.text.isNotEmpty) {
      Map<String, dynamic> addRecipe = {
        "Name": nameController.text,
        "ImageURL": imageUrlController.text,
        "Ingredients": ingredientsList,
        "CookingInstructions": cookingInstructionsList,
        "TotalTime": totalTimeController.text,
        "Category": value,
      };

      DatabaseMethods().addRecipe(addRecipe).then((value) {
        Fluttertoast.showToast(
          msg: "Recipe Added Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 175, 152, 76),
          textColor: Colors.white,
          fontSize: 16.0,
        );




        nameController.clear();
        ingredientsList.clear();
        cookingInstructionsList.clear();
        totalTimeController.clear();
        imageUrlController.clear();
        _pageController.jumpToPage(0); // Go back to the first page
      });
    } else {
      print("Please fill all fields.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          _buildPage(1),
          _buildPage(2),
          _buildPage(3),
          _buildPage(4),
        ],
      ),
    );
  }

  Widget _buildPage(int pageNumber) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Recipe Title
          Container(
            margin: EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add Recipe",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 202, 121, 0),  // Using orange for the title
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          if (pageNumber == 1) _buildPage1(),
          if (pageNumber == 2) _buildPage2(),
          if (pageNumber == 3) _buildPage3(),
          if (pageNumber == 4) _buildPage4(),
        ],
      ),
    );
  }

  Widget _buildPage1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recipe Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: const Color.fromARGB(255, 198, 150, 6))),
        SizedBox(height: 10.0),
        _buildTextField(controller: nameController, hintText: "Enter Recipe Name"),
        SizedBox(height: 20.0),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0
          ),
          width: MediaQuery.of(context).size.width, 
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: recipe.map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                  ),
                )
              ).toList(),
              onChanged: ((value)=> 
                setState(() {
                  this.value = value;
                })
              ),
              dropdownColor: Colors.white,
              hint: Text(
                "Select Category",
              ),
              iconSize: 36,
              icon: Icon(
                Icons.arrow_drop_down,
                color: const Color.fromARGB(255, 202, 121, 0),
            
              ),
              value: value,
            ),

          ),
        ),
        SizedBox(height: 20.0),
        Text("Total Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: const Color.fromARGB(255, 198, 150, 6))),
        SizedBox(height: 10.0),
        _buildTextField(controller: totalTimeController, hintText: "Enter Total Time"),
        SizedBox(height: 20.0),
        GestureDetector(
          onTap: () {
            _pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          child: _buildNextButton("Next"),
        ),
      ],
    );
  }

  Widget _buildPage2() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ingredient Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: const Color.fromARGB(255, 198, 150, 6))),
          SizedBox(height: 10.0),
          _buildTextField(controller: ingredientNameController, hintText: "Enter Ingredient Name"),
          SizedBox(height: 10.0),
          Text("Ingredient Quantity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: const Color.fromARGB(255, 198, 150, 6))),
          SizedBox(height: 10.0),
          _buildTextField(controller: ingredientQuantityController, hintText: "Enter Ingredient Quantity"),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              String name = ingredientNameController.text.trim();
              String quantity = ingredientQuantityController.text.trim();
              if (name.isNotEmpty && quantity.isNotEmpty) {
                addIngredient(name, quantity);
              } else {
                print("Please enter both name and quantity.");
              }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 202, 121, 0)),
            ),
            child: Text("Add Ingredient", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 10.0),
          Text("Ingredients List:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: const Color.fromARGB(255, 198, 150, 6))),
          
          // Wrap the ListView in a Container with a fixed height to avoid overflow
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: ingredientsList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${ingredientsList[index]['name']}"),
                  subtitle: Text("Quantity: ${ingredientsList[index]['quantity']}"),
                );
              },
            ),
          ),
          
          // Ensure the next button stays at the bottom of the screen
          GestureDetector(
            onTap: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: _buildNextButton("Next"),
          ),
        ],
      ),
    );
  }

Widget _buildPage3() {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cooking Instructions
        Text(
          "Cooking Instructions",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: const Color.fromARGB(255, 198, 150, 6)),
        ),
        SizedBox(height: 10.0),
        _buildTextField(
          controller: cookingInstructionsController,
          hintText: "Enter Instruction Line",
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            String instruction = cookingInstructionsController.text.trim();
            if (instruction.isNotEmpty) {
              addInstruction(instruction);
            } else {
              print("Please enter a cooking instruction.");
            }
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
                const Color.fromARGB(255, 202, 121, 0)),
          ),
          child: Text("Add Instruction", style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 20.0),
        Text(
          "Instructions List:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: const Color.fromARGB(255, 198, 150, 6)),
        ),
        // Wrap the ListView to avoid overflow and place inside Expanded
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: cookingInstructionsList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("Step ${index + 1}: ${cookingInstructionsList[index]}"),
              );
            },
          ),
        ),
        SizedBox(height: 20.0),
        // Ensure the next button stays at the bottom of the screen
        GestureDetector(
          onTap: () {
            _pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          child: _buildNextButton("Next"),
        ),
      ],
    ),
  );
}






Widget _buildPage4() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Image URL Input
      Text(
        "Image URL",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: const Color.fromARGB(255, 198, 150, 6),
        ),
      ),
      SizedBox(height: 10.0),
      _buildTextField(
        controller: imageUrlController,
        hintText: "Enter Image URL",
      ),
      SizedBox(height: 8.9),
      // Show Image Preview if URL is provided
      if (imageUrlController.text.isNotEmpty)
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrlController.text),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
    
    
      SizedBox(height: 10.0),
      // Save Button
      GestureDetector(
        onTap: uploadItem,
        child: _buildNextButton("Save"),
      ),
    
    ],
  );
}




  Widget _buildTextField({required TextEditingController controller, required String hintText}) {
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }

  Widget _buildNextButton(String text) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 202, 121, 0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
