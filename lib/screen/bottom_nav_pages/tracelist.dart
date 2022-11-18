import 'package:bfmh_canteen/screen/bottom_nav_pages/trace_food.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class tracelist extends StatefulWidget {
  const tracelist({super.key});

  @override
  State<tracelist> createState() => _tracelistState();
}

class _tracelistState extends State<tracelist> {
  double totall = 0;
  String? itemm;
  List<String> productt = [];
  String? qrrr;
  Widget tracelistt(String collectionName) {
    String? email1 = FirebaseAuth.instance.currentUser!.email;
    int n = 0;
    return Container(
      child: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(collectionName)
                .where("email", isEqualTo: email1)
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
                    qrrr = null;
                    n = n + 1;
                    DocumentSnapshot _documentSnapshot =
                        snapshot.data!.docs[index];
                    // qrrr = "Email : $email1" +
                    //     "\n" +
                    //     "Item : ${_documentSnapshot['item']}" +
                    //     "\nTotal :${_documentSnapshot['total']} " +
                    //     "\nStatus :${_documentSnapshot['status']}";
                    return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => tracef(_documentSnapshot))),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/profile.png"),
                              ),
                              //fit: BoxFit.cover,

                              title: Text(
                                //  "Order $n",
                                "${_documentSnapshot['item']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                    fontSize: 19.h),
                              ),
                              subtitle: Text(
                                "${_documentSnapshot['status']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              trailing: Text(
                                "Order $n",
                              )
                              //     child: Row(children: [
                              //   IconButton(
                              //       onPressed: () {
                              //         Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (_) => tracef(_documentSnapshot
                              //                     // name: widget._product['product-name'],
                              //                     // des: widget._product['product-description'],
                              //                     // avail: widget._product['product-available'],
                              //                     // price: widget._product['product-price'],

                              //                     )));
                              //       },
                              //       icon: const Icon(
                              //         Icons.arrow_forward,
                              //         color: Color.fromARGB(137, 0, 102, 9),
                              //       )),
                              //   IconButton(
                              //       onPressed: (() {
                              //         FirebaseFirestore.instance
                              //             .collection(collectionName)
                              //             .doc(_documentSnapshot.id)
                              //             .delete()
                              //             .then((value) => {
                              //                   Fluttertoast.showToast(
                              //                       msg: "Successfully Deleted"),
                              //                 });
                              //       }),
                              //       icon: Icon(Icons.delete,
                              //           color: Color.fromARGB(255, 231, 5, 5)))
                              // ])),
                              ),
                        ));
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
          "My Orders",
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
        child: tracelistt("trace"),
        //customButton("Continue", () => sendUserDataToDB()),
      ),
    );
  }
}
