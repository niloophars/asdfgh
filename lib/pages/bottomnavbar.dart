import 'package:recipe/pages/order.dart';
import 'package:recipe/pages/profile.dart';
import 'package:recipe/pages/wallet.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:recipe/pages/home.dart';



class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();

}

class _BottomNavBarState extends State<BottomNavBar> {
  late List<Widget> pages; 

  late Home homePage;
  late Order order;
  late Wallet wallet;
  late Profile profilePage;

  int currentTabIndex = 0;
  
  @override
  void initState() {
    homePage = Home();
    order = Order();
    wallet = Wallet();
    profilePage = Profile();

    pages = [
      homePage,
      order,
      wallet,
      profilePage,
    ];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 70,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 500),
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
            Icons.wallet,
            color: Colors.white,
            size: 30.0,
          ),
          Icon(
            Icons.shopping_bag,
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
      body: pages[currentTabIndex],
    );
  }
}