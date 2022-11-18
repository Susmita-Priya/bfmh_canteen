import 'package:bfmh_canteen/screen/bottom_nav_pages/trace_food.dart';
import 'package:bfmh_canteen/stuff/trace.dart';
import 'package:bfmh_canteen/widgets/fetchfeedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class order extends StatefulWidget {
  const order({super.key});

  @override
  State<order> createState() => _orderState();
}

class _orderState extends State<order> {
  Widget orderlist(String collectionName) {
    String? email1 = FirebaseAuth.instance.currentUser!.email;
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

                    return Card(
                      elevation: 5,
                      child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage("assets/profile.png"),
                          ),
                          //fit: BoxFit.cover,

                          title: Text(
                            "${_documentSnapshot['email']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16.h),
                          ),
                          subtitle: Text(
                            "(" +
                                _documentSnapshot['item_name'] +
                                ")" +
                                "\n\nTotal = ${_documentSnapshot['total'].toString()}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
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
                                              builder: (_) => trace(
                                                  _documentSnapshot
                                                  // name: widget._product['product-name'],
                                                  // des: widget._product['product-description'],
                                                  // avail: widget._product['product-available'],
                                                  // price: widget._product['product-price'],

                                                  )));
                                    },
                                    icon: const Icon(
                                      Icons.notification_add,
                                      color: Color.fromARGB(137, 0, 102, 9),
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
                          )),
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
        title: const Text(
          "OrderList",
          style: TextStyle(
            //fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.orange,
        //automaticallyImplyLeading: false,
        //centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
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
        child: orderlist("order"),
        //customButton("Continue", () => sendUserDataToDB()),
      ),
    );
  }
}
