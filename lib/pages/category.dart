import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:recipe/pages/recipe.dart';
import 'package:recipe/services/database.dart';

class CategoryRecipe extends StatefulWidget {
  String category;
  CategoryRecipe({required this.category});

  @override
  State<CategoryRecipe> createState() => _CategoryRecipeState();
}

class _CategoryRecipeState extends State<CategoryRecipe> {

  Stream? categoryStream;

  getontheload() async {
    categoryStream = await DatabaseMethods().getCategoryRecipe(widget.category);
    setState(() {
      
    });
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }


  Widget allRecipe(){
    return StreamBuilder(
      stream: categoryStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData? 
        MasonryGridView.count(
          padding: EdgeInsets.zero,
          
            crossAxisCount: 2,
            
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            
          
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
          }
        ): Container(
        

        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: 50.0,
          left: 20.0,
          right: 20.0,
        ),
        child: Column(
          children: [
            Center(
              child: Text(
                widget.category,
                style: TextStyle(
                  color: const Color.fromARGB(255, 202, 121, 0),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Expanded(child: allRecipe())
          ],
        ),
      ),
    );
  }
}
