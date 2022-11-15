import 'package:bfmh_canteen/screen/bottom_nav_controller.dart';
import 'package:bfmh_canteen/screen/bottom_nav_pages/cart.dart';
import 'package:bfmh_canteen/screen/bottom_nav_pages/payment.dart';
import 'package:bfmh_canteen/widgets/custombutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget fetchData(String collectionName, num? total) {
  // num? total = 0;
  return Container(
    child: Stack(
      children: <Widget>[
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(collectionName)
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("items")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Something is wrong"),
              );
            }
            return ListView.builder(
                itemCount:
                    snapshot.data == null ? 0 : snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  DocumentSnapshot _documentSnapshot =
                      snapshot.data!.docs[index];

                  //                     for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  //                   totalAmount = totalAmount + foodItems[i].price;
                  // }

                  //total = total! + _documentSnapshot['price'];
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(_documentSnapshot['images']),
                      ),
                      title: Text(
                        " ${_documentSnapshot['name']}",
                        // "${total.toString()}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 19.h),
                      ),
                      subtitle: Text(
                        " ${_documentSnapshot['price'].toString()}tK",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                      trailing: GestureDetector(
                        child: CircleAvatar(
                          child: Icon(Icons.delete,
                              color: Color.fromARGB(255, 231, 5, 5)),
                        ),
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection(collectionName)
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .collection("items")
                              .doc(_documentSnapshot.id)
                              .delete()
                              .then((value) => {
                                    Fluttertoast.showToast(
                                        msg: "Successfully Deleted"),
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                bottomnavcontroller())),
                                    //total = 0,
                                    total = total! - _documentSnapshot['price'],
                                    print(total),
                                  });
                        },
                      ),
                    ),
                  );
                });
          },
        ),
      ],
    ),
  );
}
