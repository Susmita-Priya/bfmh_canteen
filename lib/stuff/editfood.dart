import 'package:bfmh_canteen/stuff/productdetails.dart';
import 'package:bfmh_canteen/stuff/updatefood.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class editfood extends StatefulWidget {
  const editfood({super.key});

  @override
  State<editfood> createState() => _editfoodState();
}

class _editfoodState extends State<editfood> {
  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;

  Widget fetchData(String collectionName) {
    return Container(
      child: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(collectionName)
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
                    return //GestureDetector(
                        //     onTap: () => Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (_) =>
                        //                 updatefood(_documentSnapshot,_documentSnapshot.id))),
                        //     child:
                        Card(
                      elevation: 5,
                      child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(_documentSnapshot['product-img']),
                          ),
                          title: Text(
                            "${_documentSnapshot['product-name']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 19.h),
                          ),
                          subtitle: Text(
                            "${_documentSnapshot['product-price'].toString()}tK" +
                                "\n(${_documentSnapshot['product-available']})",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange),
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => updatefood(
                                                  _documentSnapshot
                                                  // name: widget._product['product-name'],
                                                  // des: widget._product['product-description'],
                                                  // avail: widget._product['product-available'],
                                                  // price: widget._product['product-price'],

                                                  )));
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      // color: Color.fromRGBO(0, 153, 255, 1),
                                    )),
                                IconButton(
                                    onPressed: (() {
                                      FirebaseFirestore.instance
                                          .collection(collectionName)
                                          .doc(_documentSnapshot.id)
                                          .delete()
                                          .then((value) => {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Successfully Deleted"),
                                              });
                                    }),
                                    icon: Icon(Icons.delete,
                                        color: Color.fromARGB(255, 231, 5, 5)))
                              ],
                            ),
                          )
                          //  GestureDetector(
                          //   child: CircleAvatar(
                          //     child: Icon(Icons.edit),
                          //   ),
                          //   onTap: () {
                          //     FirebaseFirestore.instance
                          //         .collection(collectionName)
                          //         .doc(_documentSnapshot.id)
                          //         .delete();
                          //   },
                          // ),
                          ),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text(
            "Food list",
          ),
          // automaticallyImplyLeading: false,
          //centerTitle: true,
          // iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        body: SafeArea(
          child: fetchData("products"),
          // customButton("Continue", () => sendUserDataToDB()),
          //  child: Container(
          //   child: Stack(
          //     children: <Widget>[
          //       StreamBuilder(
          //         stream: FirebaseFirestore.instance
          //             .collection('products')
          //             .doc()
          //             .snapshots(),
          //         builder: (BuildContext context, AsyncSnapshot snapshot) {
          //           if (snapshot.hasError) {
          //             return Center(
          //               child: Text("Something is wrong"),
          //             );
          //           }
          //           return ListView.builder(
          //               itemCount:
          //                   snapshot.data == null ? 0 : snapshot.data!.docs.length,
          //               itemBuilder: (_, index) {
          //                 DocumentSnapshot _documentSnapshot =
          //                     snapshot.data!.docs[index];

          //                 return Card(
          //                   elevation: 5,
          //                   child: ListTile(
          //                     leading: Image.network(
          //                       _documentSnapshot['product-img'],
          //                       fit: BoxFit.cover,
          //                     ),
          //                     title: Text(
          //                       " ${_documentSnapshot['name']}",
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.bold,
          //                           color: Colors.black,
          //                           fontSize: 19.h),
          //                     ),
          //                     subtitle: Text(
          //                       " ${_documentSnapshot['price']}tK",
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.bold,
          //                           color: Colors.orange),
          //                     ),
          //                     trailing: GestureDetector(
          //                       child: CircleAvatar(
          //                         child: Icon(Icons.remove_circle),
          //                       ),
          //                       onTap: () {
          //                         FirebaseFirestore.instance
          //                             .collection('products')
          //                             .doc(_documentSnapshot.id)
          //                             .delete();
          //                       },
          //                     ),
          //                   ),
          //                 );
          //               });
          //         },
          //       ),
          //     ],
          //   ),
          // )),
        ));
  }
}
