import 'package:bfmh_canteen/constant/Appcolours.dart';
import 'package:bfmh_canteen/screen/bottom_nav_pages/MDrawer.dart';
import 'package:bfmh_canteen/screen/bottom_nav_pages/QRcode.dart';
import 'package:bfmh_canteen/screen/bottom_nav_pages/cart.dart';
import 'package:bfmh_canteen/screen/bottom_nav_pages/favourite.dart';
import 'package:bfmh_canteen/screen/bottom_nav_pages/home.dart';
import 'package:bfmh_canteen/screen/bottom_nav_pages/notification.dart';
import 'package:bfmh_canteen/screen/bottom_nav_pages/profile.dart';
import 'package:bfmh_canteen/screen/bottom_nav_pages/tracelist.dart';
import 'package:bfmh_canteen/screen/bottom_nav_pages/update.dart';
import 'package:bfmh_canteen/screen/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class bottomnavcontroller extends StatefulWidget {
  const bottomnavcontroller({super.key});

  @override
  State<bottomnavcontroller> createState() => _bottomnavcontrollerState();
}

class _bottomnavcontrollerState extends State<bottomnavcontroller> {
  final _pages = [Home(), Favourite(), Cart(), tracelist()];
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: myDrawer(),
      drawer: const Drawer(child: MDrawer()),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Text(
          "BFMH",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              child: CircleAvatar(
                child: Icon(
                  Icons.search,
                  size: 22.0,
                  color: Colors.black,
                ),
                radius: 20.0,
                backgroundColor: Colors.orange,
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 4.0),
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.of(context).push(
          //           MaterialPageRoute(builder: (context) => notificationn()));
          //     },
          //     // child: CircleAvatar(
          //     //   child: Icon(
          //     //     Icons.notifications_active,
          //     //     size: 22.0,
          //     //     color: Colors.black,
          //     //   ),
          //     //   radius: 20.0,
          //     //   backgroundColor: Colors.orange,
          //     // ),
          //   ),
          // ),
        ],
        //centerTitle: true,
        // automaticallyImplyLeading: false,
      ),

      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        selectedItemColor: Appcolours.Orange,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        selectedLabelStyle:
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), label: "Favourite"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: "Trace food",
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            print(_currentIndex);
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}
