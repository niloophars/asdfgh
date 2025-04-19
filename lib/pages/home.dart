import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:recipe/pages/category.dart';
import 'package:recipe/pages/recipe.dart';
import 'package:recipe/services/database.dart';
import 'package:recipe/services/widget_support.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Stream? recipeStream;

  getontheload() async {
    recipeStream = await DatabaseMethods().getallRecipe();
    setState(() {});

  }

  @override
  void initState() {
    getontheload();
    super.initState();
    
  }

  Widget allRecipe () {
  return StreamBuilder(
    stream: recipeStream,
    builder: (context, AsyncSnapshot snapshot) {
      return snapshot.hasData
          ? MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              padding: EdgeInsets.only(right: 20.0),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Recipe(image: ds["ImageURL"], dish: ds["Name"]),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 231, 202, 159),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            ds["ImageURL"],
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          ds["Name"],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 137, 84, 4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Container();
    },
  );
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 169, 129, 9),
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: 50.0, 
          left: 20.0
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 20.0,
              ),
              child: Row(
                children: [
                  Text(
                    "Let's get Cooking!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      "images/Profile.png",
                      height: 50.0,
                      width: 50.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.only(
                left: 10.0,
              ),
              margin: EdgeInsets.only(
                right: 20.0,
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 231, 202, 159),
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: MediaQuery.of(context).size.width,
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(
                  Icons.search_outlined,
                  color: const Color.fromARGB(255, 137, 84, 4)  
                ),
                hintText: "Search recipes",               
                ),        
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 100.0,
              width: MediaQuery.of(context).size.width,
              child: Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryRecipe(category: "Breakfast"),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          right: 20.0,
                        ),
                        child: Column(                 
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                "images/breakfast.jpg",
                                height: 60.0,
                                width: 80.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Breakfast",
                              style: AppWidget.lightTextFieldStyle(),                          
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryRecipe(category: "Lunch"),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          right: 20.0,
                        ),
                        child: Column(                 
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                "images/Lunch.jpg",
                                height: 60.0,
                                width: 80.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Lunch",
                              style: AppWidget.lightTextFieldStyle(),                          
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryRecipe(category: "Dinner"),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          right: 20.0,
                        ),
                        child: Column(                 
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                "images/dinner.jpg",
                                height: 60.0,
                                width: 80.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Dinner",
                              style: AppWidget.lightTextFieldStyle(),                          
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryRecipe(category: "Dessert"),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          right: 20.0,
                        ),
                        child: Column(                 
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                "images/Dessert.jpg",
                                height: 60.0,
                                width: 80.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Dessert",
                              style: AppWidget.lightTextFieldStyle(),                          
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryRecipe(category: "Drinks"),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          right: 20.0,
                        ),
                        child: Column(                 
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                "images/drinks.jpg",
                                height: 60.0,
                                width: 80.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Drinks",
                              style: AppWidget.lightTextFieldStyle(),                          
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),



            Expanded(child: allRecipe())
           


          ],  
        ),
      ),
  );
    
  }
}

