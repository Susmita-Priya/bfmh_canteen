import 'package:bfmh_canteen/stuff/trace.dart';
import 'package:bfmh_canteen/stuff/trace1.dart';
import 'package:bfmh_canteen/widgets/fetchfeedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class tracesee extends StatefulWidget {
  const tracesee({super.key});

  @override
  State<tracesee> createState() => _traceseeState();
}

class _traceseeState extends State<tracesee> {
  Widget trsee(String collectionName) {
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
                                color: Colors.orange,
                                fontSize: 19.h),
                          ),
                          subtitle: Text(
                            "(${_documentSnapshot['item']})"
                            "\n${_documentSnapshot['status']}"
                            "\n(${_documentSnapshot['total']})",
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: SizedBox(
                            width: 50,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => trace1(
                                                  _documentSnapshot
                                                  // name: widget._product['product-name'],
                                                  // des: widget._product['product-description'],
                                                  // avail: widget._product['product-available'],
                                                  // price: widget._product['product-price'],

                                                  )));
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color.fromARGB(255, 7, 160, 20),
                                    )),
                              ],
                            ),
                          )
                          // trailing: GestureDetector(
                          //   child: CircleAvatar(
                          //     child: Icon(Icons.delete,
                          //         color: Color.fromARGB(255, 231, 5, 5)),
                          //   ),
                          //   onTap: () {
                          //     FirebaseFirestore.instance
                          //         .collection(collectionName)
                          //         .doc(FirebaseAuth.instance.currentUser!.email)
                          //         .collection("items")
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
        title: const Text(
          "Order Status",
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
        child: trsee("trace"),
        //customButton("Continue", () => sendUserDataToDB()),
      ),
    );
  }
}
