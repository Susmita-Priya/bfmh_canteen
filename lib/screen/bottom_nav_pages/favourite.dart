import 'package:bfmh_canteen/widgets/fetchProducts.dart';
import 'package:bfmh_canteen/widgets/fetchfavt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wishlist",
          style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
              shadows: [
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.black,
                  offset: Offset(3, 3),
                )
              ]),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        // iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SafeArea(
        child: fetchfavt("users-favourite-items"),
      ),
    );
  }
}
