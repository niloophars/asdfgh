import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:recipe/pages/home.dart';
import 'package:recipe/pages/search.dart';
import 'package:recipe/pages/add_recipe.dart';
import 'package:recipe/pages/profile.dart';

class BottomNavBar extends StatefulWidget {
  final int initialIndex;
  const BottomNavBar({super.key, this.initialIndex = 0});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int currentTabIndex;
  late List<Widget> pages;

  late Home homePage;
  late Search search;
  late AddRecipe addRecipe;
  late Profile profile;

  @override
  void initState() {
    super.initState();
    currentTabIndex = widget.initialIndex; // Start with the passed initialIndex
    homePage = Home();
    search = Search();
    addRecipe = AddRecipe();
    profile = Profile();

    pages = [
      homePage,
      search,
      addRecipe,
      profile,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 70,
        backgroundColor: Colors.white,
        color: const Color.fromARGB(255, 148, 89, 0),
        animationDuration: Duration(milliseconds: 500),
        index: currentTabIndex, // <-- Keep track of the current index here
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(
            Icons.home,
            color: Colors.white,
            size: 30.0,
          ),
          Icon(
            Icons.search,
            color: Colors.white,
            size: 30.0,
          ),
          Icon(
            Icons.add_circle,
            color: Colors.white,
            size: 30.0,
          ),
          Icon(
            Icons.person,
            color: Colors.white,
            size: 30.0,
          )
        ],
      ),
      body: pages[currentTabIndex], // <-- Display the selected page based on currentTabIndex
    );
  }
}
