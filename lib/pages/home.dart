import 'package:recipe/model/biriyani_model.dart';
import 'package:recipe/model/burger_model.dart';
import 'package:recipe/model/category_model.dart';
import 'package:recipe/services/biriyani_data.dart';
import 'package:recipe/services/burger_data.dart';
import 'package:recipe/services/category_data.dart';
import 'package:recipe/services/widget_support.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];
  List<BiriyaniModel> biriyani = [];
  List<BurgerModel> burger = [];
  String track =  "0";

  @override
  void initState() {
    categories = getCategories();
    biriyani = getBiriyani();
    burger = getBurger();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {},

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
          left: 15.0,
          top: 40.0,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "images/nomnom.png",
                      height: 50,
                      width: 90,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      "Browse your cooker",
                      style: AppWidget.simpleTextFieldStyle(),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "images/title.png",
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 10.0
                    ),
                    margin: EdgeInsets.only(
                      right: 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffececf8),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search cookers",
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 10.0,
                  ),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xffef2b39),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30.0,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 60,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index){
                  return categoryTile(
                    categories[index].name!,
                    categories[index].image!,
                    index.toString(),
                  );
              }),
            ),
            SizedBox(
              height: 10.0,
            ),
            track == "0" ?
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: 10.0
                ),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.69,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 15.0
                  ),
                  itemCount: biriyani.length,
                  itemBuilder: (context, index){
                    return foodTile(biriyani[index].name!, biriyani[index].image!, biriyani[index].time!);
                  }
                ),
              ),
            ) : track == "1" ?
                        Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: 10.0
                ),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.69,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 15.0
                  ),
                  itemCount: burger.length,
                  itemBuilder: (context, index){
                    return foodTile(burger[index].name!, burger[index].image!, burger[index].time!);
                  }
                ),
              ),
            ): Container(),
          ],
        ),
      ),
    );
  }

Widget foodTile(String name, String image, String time) {
  return Container(
    margin: EdgeInsets.only(
      right: 10.0,
    ),
    padding: EdgeInsets.only(
      left: 5.0,
      top: 8.0
    ),
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.black38,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            image,
            height: 110,
            width: 120,
            fit: BoxFit.contain,
          ),
        ),
        Text(
          name,
          style: AppWidget.boldTextFieldStyle(),
        ),
        Text(
          time,
          style: AppWidget.priceTextFieldStyle(),
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                color: Color(0xffef2b39),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(10)
                ),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ],
        )
      ],
    ),
  );
}

  Widget categoryTile(String name, String image, String categoryindex){
    return GestureDetector(
      onTap: () {
        track =  categoryindex.toString();
        setState(() {
          
        });
      },

      child: track == categoryindex ?
      Container(
        margin: EdgeInsets.only(  
              right: 20.0,
              bottom: 10.0
            ),
        child: Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            decoration: BoxDecoration(
              color: Color(0xffef2b39),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Image.asset(
                  image,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  name,
                  style: AppWidget.whiteTextFieldStyle(),
                )
              ],
            ),
          ),
        ),
      )
      :Container(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
        ),
        margin: EdgeInsets.only(
          right: 20.0,
          bottom: 10.0
        ),
        decoration: BoxDecoration(
          color: Color(0xFFececf8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Image.asset(
              image,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              name,
              style: AppWidget.simpleTextFieldStyle(),
            ) 
          ],
        ),
      )
    );
  }
}
