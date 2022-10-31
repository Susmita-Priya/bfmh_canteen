import 'package:bfmh_canteen/widgets/fetchProducts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bfmh_canteen/widgets/fetchProducts.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Cart",
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
        //     child: Column(
        //   children: [
        //     Text("hghhghj"),
        //     SizedBox(
        //       height: 165,
        //     ),
        //     Container(
        //       child: fetchData("users-cart-items"),
        //     )
        //   ],
        // )
        child: fetchData("users-cart-items"),
        //customButton("Continue", () => sendUserDataToDB()),
      ),
    );
  }
}
