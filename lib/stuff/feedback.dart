import 'package:bfmh_canteen/stuff/seefeedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class feedback extends StatefulWidget {
  const feedback({super.key});

  @override
  State<feedback> createState() => _feedbackState();
}

class _feedbackState extends State<feedback> {
  String? id;
  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;

  Widget fetchDataa(String collectionName) {
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
                    id = snapshot.data!.docs[index].data() as String?;
                    DocumentSnapshot _documentSnapshot =
                        snapshot.data!.docs[index];

                    return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    seefeedback(_documentSnapshot))),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage("assets/profile.png"),
                            ),
                            //fit: BoxFit.cover,

                            title: Text(
                              " ${id} hello",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  fontSize: 19.h),
                            ),
                            // subtitle: Text(
                            //   " ${_documentSnapshot['feedback']}",
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.bold, color: Colors.black),
                            // ),

                            //   trailing: GestureDetector(
                            //     child: CircleAvatar(
                            //       child: Icon(Icons.remove_circle),
                            //     ),
                            //     onTap: () {
                            //       FirebaseFirestore.instance
                            //           .collection(collectionName)
                            //           .doc(_documentSnapshot.id)
                            //           .delete();
                            //     },
                            //   ),
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
          backgroundColor: Colors.orange,
          title: const Text(
            "Feedback List",
          ),
          // automaticallyImplyLeading: false,
          //centerTitle: true,
          // iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        body: SafeArea(
          child: fetchDataa("feedback"),
        ));
  }
}
